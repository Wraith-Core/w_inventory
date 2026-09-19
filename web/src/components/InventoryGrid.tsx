import { useMemo } from 'react';
import Slot from './Slot';
import { COLS, MIN_ROWS } from '../utils/items';
import { InventoryItem } from '../typings';
import { HotbarSlot } from '../hooks/useHotbar';
import { tr } from '../i18n';

interface InventoryGridProps {
  grid: (InventoryItem | null)[];
  category: string;
  search: string;
  selected: number | null;
  panel: string;
  selectedPanel: string;
  inventorySlots?: number;
  hotbarSlots?: (HotbarSlot | null)[];
  onSelect: (idx: number, panel: string, e: React.MouseEvent) => void;
  onContextMenu: (e: React.MouseEvent, idx: number, panel: string) => void;
  onDoubleClick: (idx: number, item: InventoryItem) => void;
  onMouseOver: (idx: number, panel: string) => void;
  onMouseLeave: () => void;
}

export default function InventoryGrid({ grid, category, search, selected, panel, selectedPanel, inventorySlots, hotbarSlots, onSelect, onContextMenu, onDoubleClick, onMouseOver, onMouseLeave }: InventoryGridProps) {
  const isFiltering = category !== 'all' || (search && search.length > 0);

  const hotbarMap = useMemo(() => {
    const map = new Map<number, number>();
    if (panel === 'main' && hotbarSlots) {
      for (let hi = 0; hi < hotbarSlots.length; hi++) {
        const hs = hotbarSlots[hi];
        if (!hs) continue;
        for (let gi = 0; gi < grid.length; gi++) {
          const it = grid[gi];
          if (it && it.slot === hs.slot && it.name === hs.name && !map.has(gi)) {
            map.set(gi, hi);
            break;
          }
        }
      }
    }
    return map;
  }, [panel, hotbarSlots, grid]);

  const filterSet = useMemo(() => {
    if (!isFiltering) return null;
    const q = (search || '').toLowerCase();
    const matches = new Set<number>();
    for (let gi = 0; gi < grid.length; gi++) {
      const item = grid[gi];
      if (!item) continue;
      if (category !== 'all' && (item.type || 'item_misc') !== category) continue;
      if (q && (item.label || item.name).toLowerCase().indexOf(q) === -1) continue;
      matches.add(gi);
    }
    return matches;
  }, [grid, category, search, isFiltering]);

  const rendered = useMemo(() => {
    let lastFilled = -1;
    for (let i = grid.length - 1; i >= 0; i--) {
      if (grid[i] !== null) { lastFilled = i; break; }
    }
    const minSlots = MIN_ROWS * COLS;
    const needed = Math.max(lastFilled + 1, minSlots, inventorySlots || 0);
    const totalSlots = Math.ceil(needed / COLS) * COLS;

    const slots: React.ReactNode[] = [];
    for (let gi = 0; gi < totalSlots; gi++) {
      const item = grid[gi] || null;
      const dimmed = filterSet !== null && item !== null && !filterSet.has(gi);
      slots.push(
        <Slot
          key={`s-${panel}-${gi}`}
          item={item}
          idx={gi}
          gridIndex={gi}
          selected={selectedPanel === panel && selected === gi}
          panel={panel}
          hotbarIndex={hotbarMap.get(gi) ?? null}
          dimmed={dimmed}
          onSelect={onSelect}
          onContextMenu={onContextMenu}
          onDoubleClick={onDoubleClick}
          onMouseOver={onMouseOver}
          onMouseLeave={onMouseLeave}
        />
      );
    }
    return slots;
  }, [grid, selected, selectedPanel, panel, hotbarMap, filterSet, inventorySlots, onSelect, onContextMenu, onDoubleClick, onMouseOver, onMouseLeave]);

  const hasItems = grid.some((it) => it !== null);

  return (
    <>
      <div className="inv-grid" id={panel === 'container' ? 'container-grid' : panel === 'right' ? 'right-grid' : 'inv-grid'} style={{ display: 'grid' }}>
        {rendered}
      </div>
      {panel === 'main' && !hasItems && (
        <div id="inv-empty" style={{ display: 'flex', pointerEvents: 'none' }}>
          <svg viewBox="0 0 24 24" fill="currentColor"><path d="M20 6h-4V4c0-1.1-.9-2-2-2h-4c-1.1 0-2 .9-2 2v2H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2zm-6 0h-4V4h4v2z"/></svg>
          <div className="empty-text">{tr('ui_bag_empty', 'Your inventory is empty')}</div>
          <div className="empty-hint">{tr('ui_items_appear_here', 'Your items will appear here')}</div>
        </div>
      )}
    </>
  );
}
