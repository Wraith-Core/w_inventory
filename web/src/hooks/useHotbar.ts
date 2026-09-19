import { useState, useCallback, useRef, useEffect } from 'react';
import { fetchNui } from '../utils/nui';
import { InventoryItem } from '../typings';

const HOTBAR_SIZE = 5;

export interface HotbarSlot {
  id: string | number;
  name: string;
  label: string;
  isWeapon: boolean;
  weaponId?: string | number;
  canUse: boolean;
  equipped: boolean;
  slot: number;
}

function itemToHotbarSlot(item: InventoryItem): HotbarSlot {
  return {
    id: item.id || `${item.name}-${item.slot}`,
    name: item.name,
    label: item.label,
    isWeapon: !!item.isWeapon,
    weaponId: item.weaponId,
    canUse: !!item.canUse,
    equipped: !!item.equipped,
    slot: item.slot,
  };
}

export function useHotbar() {
  const [slots, setSlots] = useState<(HotbarSlot | null)[]>(() => new Array(HOTBAR_SIZE).fill(null));
  const [hotbarVisible, setHotbarVisible] = useState(false);
  const hideTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const slotsRef = useRef(slots);
  slotsRef.current = slots;

  useEffect(() => {
    return () => {
      if (hideTimer.current) clearTimeout(hideTimer.current);
    };
  }, []);

  const showHotbar = useCallback(() => {
    setHotbarVisible(true);
    if (hideTimer.current) clearTimeout(hideTimer.current);
    hideTimer.current = setTimeout(() => {
      setHotbarVisible(false);
      hideTimer.current = null;
    }, 2500);
  }, []);

  const setVisible = useCallback((visible: boolean) => {
    if (hideTimer.current) {
      clearTimeout(hideTimer.current);
      hideTimer.current = null;
    }

    setHotbarVisible(visible);
  }, []);

  const syncWithGrid = useCallback((grid: (InventoryItem | null)[]) => {
    setSlots((prev) => {
      const next: (HotbarSlot | null)[] = [];
      let changed = false;

      for (let i = 0; i < HOTBAR_SIZE; i++) {
        const gridItem = i < grid.length ? grid[i] : null;
        const prevSlot = prev[i] ?? null;

        if (!gridItem) {
          if (prevSlot !== null) changed = true;
          next.push(null);
        } else {
          const newSlot = itemToHotbarSlot(gridItem);
          if (
            !prevSlot ||
            prevSlot.name !== newSlot.name ||
            prevSlot.slot !== newSlot.slot ||
            prevSlot.label !== newSlot.label ||
            prevSlot.equipped !== newSlot.equipped
          ) {
            changed = true;
          }
          next.push(newSlot);
        }
      }

      return changed ? next : prev;
    });
  }, []);

  const useSlot = useCallback((slotIdx: number) => {
    const item = slotsRef.current[slotIdx];
    if (!item) return;
    fetchNui('useItem', item.slot);
  }, []);

  const loadSlots = useCallback((_savedSlots: (HotbarSlot | null)[]) => {
    // no-op: hotbar is now auto-synced from first 5 grid slots
  }, []);

  const resetSlots = useCallback(() => {
    setSlots(new Array(HOTBAR_SIZE).fill(null));
  }, []);

  return { slots, hotbarVisible, showHotbar, setVisible, syncWithGrid, useSlot, loadSlots, resetSlots };
}
