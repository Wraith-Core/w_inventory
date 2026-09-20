import { getItemUrl, itemImageError } from '../utils/nui';
import { rarity } from '../utils/items';
import { InventoryItem } from '../typings';

interface DragGhostProps {
  item: InventoryItem;
}

export default function DragGhost({ item }: DragGhostProps) {
  if (!item) return null;

  const r = rarity(item);

  return (
    <div id="inv-drag-ghost" style={{ display: 'flex' }} className={r}>
      <img
        src={getItemUrl(item)}
        onError={(e) => { itemImageError(e.currentTarget, item); }}
        alt=""
      />
      {item.count > 1 && <span className="ghost-count">{item.count}</span>}
    </div>
  );
}
