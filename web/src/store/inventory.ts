import { createSlice, current, isFulfilled, isPending, isRejected, PayloadAction } from '@reduxjs/toolkit';
import type { RootState } from '.';
import {
  moveSlotsReducer,
  refreshSlotsReducer,
  setupInventoryReducer,
  stackSlotsReducer,
  swapSlotsReducer,
} from '../reducers';
import { State } from '../typings';

const initialState: State = {
  leftInventory: {
    id: '',
    type: '',
    slots: 0,
    maxWeight: 0,
    items: [],
  },
  rightInventory: {
    label: "Tienda de armas",
    id: '',
    type: '',
    slots: 0,
    maxWeight: 0,
    items: [],
  },
  playerGold: 0,
  playerCash: 0,
  additionalMetadata: new Array(),
  itemAmount: 0,
  shiftPressed: false,
  isBusy: false,
  wornClothingCategories: [],
  removedClothingCategories: [],
  shopPaymentCurrency: 'cash',
  goldPriceMultiplier: 1,
};

export const inventorySlice = createSlice({
  name: 'inventory',
  initialState,
  reducers: {
    stackSlots: stackSlotsReducer,
    swapSlots: swapSlotsReducer,
    setupInventory: setupInventoryReducer,
    moveSlots: moveSlotsReducer,
    refreshSlots: refreshSlotsReducer,
    setAdditionalMetadata: (state, action: PayloadAction<Array<{ metadata: string; value: string }>>) => {
      const metadata = [];

      for (let i = 0; i < action.payload.length; i++) {
        const entry = action.payload[i];
        if (!state.additionalMetadata.find((el) => el.value === entry.value)) metadata.push(entry);
      }

      state.additionalMetadata = [...state.additionalMetadata, ...metadata];
    },
    setItemAmount: (state, action: PayloadAction<number>) => {
      state.itemAmount = action.payload;
    },
    setShiftPressed: (state, action: PayloadAction<boolean>) => {
      state.shiftPressed = action.payload;
    },
    setContainerWeight: (state, action: PayloadAction<number>) => {
      const container = state.leftInventory.items.find((item) => item.metadata?.container === state.rightInventory.id);

      if (!container) return;

      container.weight = action.payload;
    },
    setWornClothingCategories: (state, action: PayloadAction<{ wornClothingCategories: string[]; removedClothingCategories?: string[] }>) => {
      state.wornClothingCategories = action.payload.wornClothingCategories ?? [];
      if (action.payload.removedClothingCategories !== undefined) {
        state.removedClothingCategories = action.payload.removedClothingCategories;
      }
    },
    /** Update account cash/gold from the inventory currency event. */
    setAccountCurrency: (state, action: PayloadAction<{ gold?: number; cash?: number }>) => {
      if (typeof action.payload.gold === 'number') state.playerGold = action.payload.gold;
      if (typeof action.payload.cash === 'number') state.playerCash = action.payload.cash;
    },
    /** Choosing the payment method in the shop: cash or gold only */
    setShopPaymentCurrency: (state, action: PayloadAction<'cash' | 'gold'>) => {
      state.shopPaymentCurrency = action.payload;
    },
    setGoldPriceMultiplier: (state, action: PayloadAction<number>) => {
      state.goldPriceMultiplier = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder.addMatcher(isPending, (state) => {
      state.isBusy = true;

      state.history = {
        leftInventory: current(state.leftInventory),
        rightInventory: current(state.rightInventory),
      };
    });
    builder.addMatcher(isFulfilled, (state) => {
      state.isBusy = false;
    });
    builder.addMatcher(isRejected, (state) => {
      if (state.history && state.history.leftInventory && state.history.rightInventory) {
        state.leftInventory = state.history.leftInventory;
        state.rightInventory = state.history.rightInventory;
      }
      state.isBusy = false;
    });
  },
});

export const {
  setAdditionalMetadata,
  setItemAmount,
  setShiftPressed,
  setupInventory,
  swapSlots,
  moveSlots,
  stackSlots,
  refreshSlots,
  setContainerWeight,
  setWornClothingCategories,
  setAccountCurrency,
  setShopPaymentCurrency,
  setGoldPriceMultiplier,
} = inventorySlice.actions;
export const selectLeftInventory = (state: RootState) => state.inventory.leftInventory;
export const selectRightInventory = (state: RootState) => state.inventory.rightInventory;
export const selectItemAmount = (state: RootState) => state.inventory.itemAmount;
export const selectIsBusy = (state: RootState) => state.inventory.isBusy;
export const selectWornClothingCategories = (state: RootState) => state.inventory.wornClothingCategories;
export const selectRemovedClothingCategories = (state: RootState) => state.inventory.removedClothingCategories;
export const selectPlayerGold = (state: RootState) => state.inventory.playerGold;
export const selectPlayerCash = (state: RootState) => state.inventory.playerCash;
export const selectShopPaymentCurrency = (state: RootState) => state.inventory.shopPaymentCurrency;
export const selectGoldPriceMultiplier = (state: RootState) => state.inventory.goldPriceMultiplier;

export default inventorySlice.reducer;
