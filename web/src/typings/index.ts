export * from './slot';
export * from './inventory';
export * from './dnd';
export type { ItemData } from './item';
export * from './state';

export interface WSlot {
  slot: number;
  name?: string;
  count?: number;
  weight?: number;
  metadata?: { [key: string]: any };
  durability?: number;
  price?: number;
  currency?: string;
  ingredients?: { [key: string]: number };
  duration?: number;
  image?: string;
  grade?: number | number[];
}

export interface WInventory {
  id: string;
  type: string;
  slots: number;
  items: WSlot[];
  maxWeight?: number;
  label?: string;
  groups?: Record<string, number>;
}

export interface InventoryItem {
  slot: number;
  name: string;
  label: string;
  count: number;
  weight: number;
  limit: number;
  type?: string;
  desc?: string;
  canUse?: boolean;
  percentage?: number | null;
  isWeapon?: boolean;
  weaponId?: string | number;
  equipped?: boolean;
  isContainer?: boolean;
  containerMaxWeight?: number;
  containerContentWeight?: number;
  containerSlots?: number;
  ammo?: Record<string, number>;
  id?: string | number;
  durability?: number;
  price?: number;
  currency?: string;
  ingredients?: { [key: string]: number };
  duration?: number;
  grade?: number | number[];
  metadata?: { [key: string]: any };
}

export interface RightInventoryMeta {
  type: string;
  id: string;
  label: string;
  slots: number;
  maxWeight?: number;
  groups?: Record<string, number>;
}
