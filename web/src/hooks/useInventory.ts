import { useReducer, useCallback } from 'react';
import { InventoryItem, WInventory, WSlot, ItemData, RightInventoryMeta } from '../typings';
import { N, normalizeItem } from '../utils/items';
import { tr, trf } from '../i18n';

const MIN_GRID_SIZE = 50;

export interface InventoryState {
  grid: (InventoryItem | null)[];
  maxWeight: number;
  category: string;
  search: string;
  selected: number | null;
  panel: 'main' | 'container';

  rightInventory: RightInventoryMeta | null;
  rightGrid: (InventoryItem | null)[];

  containerOpen: string | null;
  containerGrid: (InventoryItem | null)[];
  containerMaxWeight: number;
  containerSlots: number;
  containerLabel: string;

  inspecting: number | null;
  inspectPanel: string;

  playerCash: number;
  playerGold: number;
  shopPaymentCurrency: 'cash' | 'gold';
  goldPriceMultiplier: number;
  itemAmount: number;
  isBusy: boolean;

  additionalMetadata: Array<{ metadata: string; value: string }>;
  wornClothingCategories: string[];
  removedClothingCategories: string[];

  tradeOpen: boolean;
  tradeCompleting: boolean;
  tradeId: string | null;
  tradePartner: string;
  myOffer: any[];
  theirOffer: any[];
  myConfirmed: boolean;
  theirConfirmed: boolean;
  tradeRequest: any | null;
}

const initial: InventoryState = {
  grid: new Array(MIN_GRID_SIZE).fill(null),
  maxWeight: 200,
  category: 'all',
  search: '',
  selected: null,
  panel: 'main',
  rightInventory: null,
  rightGrid: [],
  containerOpen: null,
  containerGrid: new Array(MIN_GRID_SIZE).fill(null),
  containerMaxWeight: 0,
  containerSlots: 15,
  containerLabel: '',
  inspecting: null,
  inspectPanel: 'main',
  playerCash: 0,
  playerGold: 0,
  shopPaymentCurrency: 'cash',
  goldPriceMultiplier: 1,
  itemAmount: 0,
  isBusy: false,
  additionalMetadata: [],
  wornClothingCategories: [],
  removedClothingCategories: [],
  tradeOpen: false,
  tradeCompleting: false,
  tradeId: null,
  tradePartner: '',
  myOffer: [],
  theirOffer: [],
  myConfirmed: false,
  theirConfirmed: false,
  tradeRequest: null,
};

/**
 * The description in the player's language: a metadata key + arguments (identification), a
 * metadata description that is a dictionary key (garbage), or the catalogue text.
 */
function describe(slot: WSlot, data: ItemData | undefined): string | undefined {
  const meta: any = slot.metadata || {};
  if (typeof meta.descriptionKey === 'string') {
    const args: Array<string | number> = Array.isArray(meta.descriptionArgs) ? meta.descriptionArgs : [];
    return trf(meta.descriptionKey, meta.description || meta.descriptionKey, ...args.map((a) => tr(String(a), String(a))));
  }
  const text = meta.description || data?.description;
  return typeof text === 'string' ? tr(text, text) : text;
}

function slotToItem(slot: WSlot, itemsDb: Record<string, ItemData | undefined>): InventoryItem | null {
  if (!slot.name) return null;
  const data = itemsDb[slot.name];
  const curTime = Math.floor(Date.now() / 1000);
  let durability = slot.metadata?.durability;
  if (durability !== undefined && durability > 100 && slot.metadata?.degrade) {
    durability = ((durability - curTime) / (60 * slot.metadata.degrade)) * 100;
  }
  if (durability !== undefined && durability < 0) durability = 0;

  return {
    slot: slot.slot,
    name: slot.name,
    label: slot.metadata?.label || data?.label || slot.name,
    count: slot.count ?? 1,
    weight: slot.weight ?? 0,
    limit: 0,
    type: data?.category || undefined,
    desc: describe(slot, data),
    canUse: data?.usable ?? false,
    percentage: durability ?? slot.durability ?? null,
    durability: durability ?? slot.durability,
    isWeapon: !!data?.weapon,
    equipped: false,
    isContainer: !!slot.metadata?.container,
    containerMaxWeight: slot.metadata?.containerMaxWeight,
    containerContentWeight: slot.metadata?.containerContentWeight,
    containerSlots: slot.metadata?.containerSlots,
    id: slot.metadata?.id ?? `${slot.name}-${slot.slot}`,
    price: slot.price,
    currency: slot.currency,
    ingredients: slot.ingredients,
    duration: slot.duration,
    grade: slot.grade,
    metadata: slot.metadata,
    ammo: slot.metadata?.ammo ? { default: slot.metadata.ammo } : undefined,
    weaponId: slot.metadata?.weaponId,
  };
}

function inventoryToGrid(inv: WInventory, itemsDb: Record<string, ItemData | undefined>): (InventoryItem | null)[] {
  const size = Math.max(MIN_GRID_SIZE, inv.slots || 50);
  const grid: (InventoryItem | null)[] = new Array(size).fill(null);

  if (!inv.items) return grid;

  // Lua tables can serialize as either arrays or objects (when keys are numbers with gaps)
  const items = inv.items;
  if (Array.isArray(items)) {
    for (const slot of items) {
      if (!slot || !slot.name) continue;
      const idx = slot.slot - 1;
      if (idx >= 0 && idx < size) {
        grid[idx] = slotToItem(slot, itemsDb);
      }
    }
  } else if (typeof items === 'object') {
    for (const key of Object.keys(items)) {
      const slot = (items as any)[key];
      if (!slot || !slot.name) continue;
      const slotNum = slot.slot ?? parseInt(key);
      const idx = slotNum - 1;
      if (idx >= 0 && idx < size) {
        grid[idx] = slotToItem(slot, itemsDb);
      }
    }
  }

  return grid;
}

function rarityRank(item: InventoryItem): number {
  const r = item.metadata?.rarity;
  const ranks: Record<string, number> = { common: 0, uncommon: 1, rare: 2, epic: 3, legendary: 4, mythic: 5, exotic: 6, divine: 7 };
  if (r && ranks[r] !== undefined) return ranks[r];
  return 0;
}

export type InventoryAction = { type: string; [key: string]: any };

function reducer(state: InventoryState, action: InventoryAction): InventoryState {
  switch (action.type) {
    case 'SETUP_INVENTORY': {
      const itemsDb = (window as any).__oxItems || {};
      const newState = { ...state };

      if (action.leftInventory) {
        const left = action.leftInventory as WInventory;
        newState.grid = inventoryToGrid(left, itemsDb);
        newState.maxWeight = left.maxWeight ?? state.maxWeight;

        if ((left as any).playerGold !== undefined) newState.playerGold = (left as any).playerGold;
        if ((left as any).playerCash !== undefined) newState.playerCash = (left as any).playerCash;
        if ((left as any).goldPriceMultiplier !== undefined) newState.goldPriceMultiplier = (left as any).goldPriceMultiplier;
      }

      if (action.rightInventory) {
        const right = action.rightInventory as WInventory;
        newState.rightInventory = {
          type: right.type,
          id: right.id,
          label: right.label || '',
          slots: right.slots,
          maxWeight: right.maxWeight,
          groups: right.groups,
        };
        newState.rightGrid = inventoryToGrid(right, itemsDb);
      }

      if (action.wornClothingCategories) newState.wornClothingCategories = action.wornClothingCategories;
      if (action.removedClothingCategories !== undefined) newState.removedClothingCategories = action.removedClothingCategories;

      newState.selected = null;
      newState.isBusy = false;
      return newState;
    }

    case 'REFRESH_SLOTS': {
      const itemsDb = (window as any).__oxItems || {};
      const newGrid = [...state.grid];
      const newRightGrid = [...state.rightGrid];
      const newState = { ...state };

      if (action.items) {
        const items = Array.isArray(action.items) ? action.items : [action.items];
        for (const data of items) {
          if (!data?.item) continue;
          const slot = data.item;
          const idx = slot.slot - 1;
          const isRight = data.inventory && data.inventory !== 'player';

          // If the quantity is zero: remove the element from the grid
          const isEmpty = !slot.name || slot.count === 0 || slot.count === '0';

          if (isRight) {
            if (idx >= 0 && idx < newRightGrid.length) {
              newRightGrid[idx] = isEmpty ? null : slotToItem(slot, itemsDb);
            }
          } else {
            if (idx >= 0 && idx < newGrid.length) {
              newGrid[idx] = isEmpty ? null : slotToItem(slot, itemsDb);
            }
          }
        }
        newState.grid = newGrid;
        newState.rightGrid = newRightGrid;
      }

      // action.itemCount is informational only — do NOT mutate __oxItems

      if (action.weightData) {
        const { inventoryId, maxWeight } = action.weightData;
        if (state.rightInventory && inventoryId === state.rightInventory.id) {
          newState.rightInventory = { ...state.rightInventory, maxWeight };
        } else {
          newState.maxWeight = maxWeight;
        }
      }

      if (action.slotsData) {
        const { inventoryId, slots } = action.slotsData;
        if (state.rightInventory && inventoryId === state.rightInventory.id) {
          newState.rightInventory = { ...state.rightInventory, slots };
        }
      }

      newState.isBusy = false;
      return newState;
    }

    // The catalogue (window.__oxItems) changed language: re-pick the label and the
    // description of every slot on screen (a custom metadata label stays as it is).
    case 'RELABEL_ITEMS': {
      const itemsDb = (window as any).__oxItems || {};
      const relabel = (it: InventoryItem | null): InventoryItem | null => {
        if (!it || !it.name) return it;
        const data = itemsDb[it.name];
        if (!data) return it;
        return {
          ...it,
          label: it.metadata?.label || data.label || it.name,
          desc: describe({ slot: it.slot, name: it.name, metadata: it.metadata }, data),
        };
      };
      return {
        ...state,
        grid: state.grid.map(relabel),
        rightGrid: state.rightGrid.map(relabel),
        containerGrid: state.containerGrid.map(relabel),
      };
    }

    case 'SET_CATEGORY':
      return { ...state, category: action.category, selected: null };

    case 'SET_SEARCH':
      return { ...state, search: action.search };

    case 'SELECT':
      return { ...state, selected: action.index, panel: action.panel };

    case 'DESELECT':
      return { ...state, selected: null };

    case 'DROP_ITEM':
    case 'SWAP_ITEMS':
    case 'MERGE_STACKS':
    case 'MOVE_TO_EMPTY':
      return { ...state, isBusy: true, selected: null };

    case 'OPEN_CONTAINER': {
      const it = state.grid[action.index];
      if (!it || !it.isContainer) return state;
      return {
        ...state,
        containerLabel: it.label || it.name,
        containerMaxWeight: N(it.containerMaxWeight) || 20,
        containerSlots: it.containerSlots || 15,
        containerOpen: it.id as string,
        containerGrid: new Array(MIN_GRID_SIZE).fill(null),
      };
    }

    case 'CLOSE_CONTAINER':
      return {
        ...state,
        containerOpen: null,
        containerGrid: new Array(MIN_GRID_SIZE).fill(null),
        selected: null,
      };

    case 'SET_CONTAINER_ITEMS': {
      if (state.containerOpen !== action.containerItemId) return state;
      const items = (action.items || []).map(normalizeItem);
      const g: (InventoryItem | null)[] = new Array(MIN_GRID_SIZE).fill(null);
      for (let i = 0; i < items.length && i < g.length; i++) {
        g[i] = items[i];
      }
      return { ...state, containerGrid: g };
    }

    case 'INSPECT':
      return { ...state, inspecting: action.index, inspectPanel: action.panel };

    case 'CLOSE_INSPECT':
      return { ...state, inspecting: null };

    case 'SORT_ITEMS':
      return state;

    case 'SET_CURRENCY':
      return {
        ...state,
        playerCash: action.cash !== undefined ? action.cash : state.playerCash,
        playerGold: action.gold !== undefined ? action.gold : state.playerGold,
      };

    case 'SET_ITEM_AMOUNT':
      return { ...state, itemAmount: action.amount };

    case 'SET_SHOP_CURRENCY':
      return { ...state, shopPaymentCurrency: action.currency };

    case 'SET_BUSY':
      return { ...state, isBusy: action.busy };

    case 'SET_ADDITIONAL_METADATA': {
      const existing = state.additionalMetadata;
      const incoming = action.metadata as Array<{ metadata: string; value: string }>;
      const newEntries = incoming.filter(e => !existing.find(x => x.value === e.value));
      return { ...state, additionalMetadata: [...existing, ...newEntries] };
    }

    case 'SET_WORN_CLOTHING':
      return {
        ...state,
        wornClothingCategories: action.wornClothingCategories ?? state.wornClothingCategories,
        removedClothingCategories: action.removedClothingCategories !== undefined ? action.removedClothingCategories : state.removedClothingCategories,
      };

    case 'TRADE_REQUEST':
      return { ...state, tradeRequest: { fromSrc: action.fromSrc, fromName: action.fromName, tradeId: action.tradeId } };
    case 'TRADE_CLEAR_REQUEST':
      return { ...state, tradeRequest: null };
    case 'TRADE_OPEN':
      return { ...state, tradeOpen: true, tradeCompleting: false, tradeId: action.tradeId, tradePartner: action.partnerName, myOffer: [], theirOffer: [], myConfirmed: false, theirConfirmed: false, tradeRequest: null };
    case 'TRADE_UPDATE_THEIR':
      return { ...state, theirOffer: action.items || [], myConfirmed: false, theirConfirmed: false };
    case 'TRADE_SET_MY_OFFER':
      return { ...state, myOffer: action.items || [], myConfirmed: false, theirConfirmed: false };
    case 'TRADE_CONFIRM_RESET':
      return { ...state, myConfirmed: false, theirConfirmed: false };
    case 'TRADE_MY_CONFIRM':
      return { ...state, myConfirmed: true };
    case 'TRADE_PARTNER_CONFIRMED':
      return { ...state, theirConfirmed: true };
    case 'TRADE_COMPLETING':
      return { ...state, tradeCompleting: true };
    case 'TRADE_COMPLETE':
    case 'TRADE_CANCELLED':
      return { ...state, tradeOpen: false, tradeCompleting: false, tradeId: null, tradePartner: '', myOffer: [], theirOffer: [], myConfirmed: false, theirConfirmed: false, tradeRequest: null };

    case 'RESET':
      return {
        ...state,
        category: 'all',
        search: '',
        selected: null,
        inspecting: null,
        rightInventory: null,
        rightGrid: [],
        containerOpen: null,
        containerGrid: new Array(MIN_GRID_SIZE).fill(null),
        tradeOpen: false,
        tradeCompleting: false,
        tradeId: null,
        tradePartner: '',
        myOffer: [],
        theirOffer: [],
        myConfirmed: false,
        theirConfirmed: false,
        tradeRequest: null,
      };

    default:
      return state;
  }
}

export default function useInventory() {
  const [state, dispatch] = useReducer(reducer, initial);

  const getGrid = useCallback(
    (panel: string) => {
      if (panel === 'container') return state.containerGrid;
      if (panel === 'right') return state.rightGrid;
      return state.grid;
    },
    [state.grid, state.containerGrid, state.rightGrid],
  );

  const getItemsList = useCallback(
    (panel: string) => getGrid(panel).filter((it): it is InventoryItem => it !== null),
    [getGrid],
  );

  return { state, dispatch, getGrid, getItemsList };
}
