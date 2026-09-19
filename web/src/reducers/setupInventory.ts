import { CaseReducer, PayloadAction } from '@reduxjs/toolkit';
import { getItemData, itemDurability } from '../helpers';
import { Items } from '../store/items';
import { Inventory, State } from '../typings';

export const setupInventoryReducer: CaseReducer<
  State,
  PayloadAction<{
    leftInventory?: Inventory;
    rightInventory?: Inventory;
    wornClothingCategories?: string[];
    removedClothingCategories?: string[];
  }>
> = (state, action) => {
  const { leftInventory, rightInventory, wornClothingCategories, removedClothingCategories } = action.payload;
  const curTime = Math.floor(Date.now() / 1000);

  if (leftInventory) {
    if (typeof (leftInventory as Inventory & { playerGold?: number }).playerGold === 'number')
      state.playerGold = (leftInventory as Inventory & { playerGold: number }).playerGold;
    if (typeof (leftInventory as Inventory & { playerCash?: number }).playerCash === 'number')
      state.playerCash = (leftInventory as Inventory & { playerCash: number }).playerCash;
    if (typeof (leftInventory as Inventory & { goldPriceMultiplier?: number }).goldPriceMultiplier === 'number')
      state.goldPriceMultiplier = (leftInventory as Inventory & { goldPriceMultiplier: number }).goldPriceMultiplier;
    state.leftInventory = {
      ...leftInventory,
      items: Array.from(Array(leftInventory.slots), (_, index) => {
        const item = Object.values(leftInventory.items).find((item) => item?.slot === index + 1) || {
          slot: index + 1,
        };

        if (!item.name) return item;

        if (typeof Items[item.name] === 'undefined') {
          getItemData(item.name);
        }

        item.durability = itemDurability(item.metadata, curTime);
        return item;
      }),
    };
  }

  if (rightInventory)
    state.rightInventory = {
      ...rightInventory,
      items: Array.from(Array(rightInventory.slots), (_, index) => {
        const item = Object.values(rightInventory.items).find((item) => item?.slot === index + 1) || {
          slot: index + 1,
        };

        if (!item.name) return item;

        if (typeof Items[item.name] === 'undefined') {
          getItemData(item.name);
        }

        item.durability = itemDurability(item.metadata, curTime);
        return item;
      }),
    };

  if (wornClothingCategories !== undefined) state.wornClothingCategories = wornClothingCategories;
  if (action.payload.removedClothingCategories !== undefined) state.removedClothingCategories = action.payload.removedClothingCategories;
  state.shiftPressed = false;
  state.isBusy = false;
};
