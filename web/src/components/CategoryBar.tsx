import { useMemo, useState } from 'react';
import { CATEGORIES, categoryName } from '../utils/items';
import { InventoryItem } from '../typings';

interface CategoryBarProps {
  active: string;
  onChange: (cat: string) => void;
  grid: (InventoryItem | null)[];
}

export default function CategoryBar({ active, onChange, grid }: CategoryBarProps) {
  const [hovered, setHovered] = useState<string | null>(null);

  const counts = useMemo(() => {
    let total = 0;
    const c: Record<string, number> = {};
    for (const it of grid) {
      if (!it) continue;
      total++;
      const t = it.type || 'item_misc';
      c[t] = (c[t] || 0) + 1;
    }
    c.all = total;
    return c;
  }, [grid]);

  return (
    <div className="categories" id="inv-cats">
      {CATEGORIES.map((c) => {
        const count = counts[c.id] || 0;
        const name = categoryName(c.id);
        return (
          <div
            key={c.id}
            className={`category${c.id === active ? ' active' : ''}${c.id !== 'all' && count === 0 ? ' dim' : ''}`}
            onClick={() => onChange(c.id)}
            onMouseEnter={() => setHovered(c.id)}
            onMouseLeave={() => setHovered(null)}
          >
            {c.icon}
            {c.id !== 'all' && count > 0 && <span className="cat-count">{count}</span>}
            {hovered === c.id && (
              <div className="cat-tooltip">{name} ({count})</div>
            )}
          </div>
        );
      })}
    </div>
  );
}
