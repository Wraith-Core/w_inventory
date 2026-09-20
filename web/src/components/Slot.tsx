import { useDraggable, useDroppable, useDndContext } from '@dnd-kit/core';
import { rarity } from '../utils/items';
import { getItemUrl, itemImageError } from '../utils/nui';
import { SVG_BAG } from '../utils/items';
import { InventoryItem } from '../typings';
import { formatCompact } from '../utils/formatNumber';

interface SlotProps {
  item: InventoryItem | null;
  idx: number;
  gridIndex: number;
  selected: boolean;
  panel: string;
  hotbarIndex?: number | null;
  dimmed?: boolean;
  onSelect: (idx: number, panel: string, e: React.MouseEvent) => void;
  onContextMenu: (e: React.MouseEvent, idx: number, panel: string) => void;
  onDoubleClick: (idx: number, item: InventoryItem) => void;
  onMouseOver: (idx: number, panel: string) => void;
  onMouseLeave: () => void;
}

function Slot({ item, idx, gridIndex, selected, panel, hotbarIndex, dimmed, onSelect, onContextMenu, onDoubleClick, onMouseOver, onMouseLeave }: SlotProps) {
  const { active } = useDndContext();
  const currentlyDragging = !!active;
  const isHotbarAssigned = hotbarIndex != null && hotbarIndex >= 0;
  const dragId = `drag:${panel}:${gridIndex}`;
  const dropId = item ? `drop:filled:${panel}:${gridIndex}` : `drop:empty:${panel}:${gridIndex}`;

  const draggable = useDraggable({
    id: dragId,
    disabled: !item || !!dimmed,
    data: { item, idx: gridIndex, panel, type: 'item' },
  });

  const droppable = useDroppable({
    id: dropId,
    data: { item, idx: gridIndex, gridIndex, panel, filled: !!item },
  });

  if (!item) {
    return (
      <div
        className={`slot${droppable.isOver ? ' drag-over' : ''}`}
        ref={droppable.setNodeRef}
        data-grid-index={gridIndex}
      >
        <div className="slot-inner" />
      </div>
    );
  }

  const r = rarity(item);
  const cls = [
    'slot filled wst-card', r,
    selected ? 'selected' : '',
    draggable.isDragging ? 'drag-source' : '',
    droppable.isOver ? 'drag-over' : '',
    item.isWeapon && item.equipped ? 'weapon-equipped' : '',
    isHotbarAssigned ? 'hotbar-assigned' : '',
    dimmed ? 'filter-dimmed' : '',
  ].filter(Boolean).join(' ');

  const delay = Math.min(gridIndex * 0.025, 0.4);
  const pct = item.percentage != null ? item.percentage : null;
  let durClass = 'high';
  if (pct !== null) {
    if (pct <= 25) durClass = 'low';
    else if (pct <= 60) durClass = 'mid';
  }

  return (
    <div
      className={cls}
      ref={(el) => { draggable.setNodeRef(el); droppable.setNodeRef(el); }}
      data-idx={gridIndex}
      data-grid-index={gridIndex}
      style={{ animationDelay: `${delay}s` }}
      onClick={(e) => onSelect(gridIndex, panel, e)}
      onDoubleClick={() => onDoubleClick(gridIndex, item)}
      onContextMenu={(e) => onContextMenu(e, gridIndex, panel)}
      onMouseOver={currentlyDragging ? undefined : () => onMouseOver(gridIndex, panel)}
      onMouseLeave={currentlyDragging ? undefined : onMouseLeave}
      {...draggable.listeners}
      {...draggable.attributes}
    >
      <div className="slot-inner">
        {item.isContainer && <div className="bag-icon">{SVG_BAG}</div>}
        {isHotbarAssigned && (
          <div className="hotbar-badge">{hotbarIndex! + 1}</div>
        )}
        {item.isWeapon && item.equipped && (
          <div className="equipped-badge">
            <svg viewBox="0 0 24 24" fill="currentColor" width="10" height="10"><path d="M12 2L9 9H2l6 4.5L5.5 22 12 17l6.5 5L16 13.5 22 9h-7z"/></svg>
          </div>
        )}
        <img
          src={getItemUrl(item)}
          onError={(e) => { itemImageError(e.currentTarget, item); }}
          draggable={false}
          alt=""
        />
        {item.count > 1 && <div className="count">{formatCompact(item.count)}</div>}
        {pct !== null && (
          <div className="durability-bar">
            <div className={`durability-fill ${durClass}`} style={{ width: `${pct}%` }} />
          </div>
        )}
        {item.price != null && item.price > 0 && (
          <div className={`price-badge${item.currency && item.currency !== 'money' ? ' currency-item' : ''}`}>
            {(!item.currency || item.currency === 'money') ? (
              <span className="price-cash">${formatCompact(item.price)}</span>
            ) : (
              <span className="price-custom">{formatCompact(item.price)}</span>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default Slot;
