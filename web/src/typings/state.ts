import { Inventory } from './inventory';
import { Slot } from './slot';

export type State = {
  leftInventory: Inventory;
  rightInventory: Inventory;
  itemAmount: number;
  shiftPressed: boolean;
  isBusy: boolean;
  /** The gold balance (an accounting currency only - not physical) */
  playerGold: number;
  /** The cash balance */
  playerCash: number;
  additionalMetadata: Array<{ metadata: string; value: string }>;
  /** The clothing categories worn (the library's ped component categories) */
  wornClothingCategories: string[];
  /** The categories taken off from the interface that can be put back on */
  removedClothingCategories: string[];
  /** The payment method in the shop: cash or gold (the player's choice) */
  shopPaymentCurrency: 'cash' | 'gold';
  /** The multiplier converting a cash price into gold (from bp_economy) */
  goldPriceMultiplier: number;
  history?: {
    leftInventory: Inventory;
    rightInventory: Inventory;
  };
};
