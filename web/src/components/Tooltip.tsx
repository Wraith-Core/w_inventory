import { useRef, useEffect } from 'react';
import { rarity, N, fmtWeight } from '../utils/items';
import { InventoryItem } from '../typings';
import { tr } from '../i18n';

interface TooltipProps {
  item: InventoryItem | null;
  anchorRect: DOMRect | null;
}

export default function Tooltip({ item, anchorRect }: TooltipProps) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (item && ref.current) {
      ref.current.style.opacity = '0';
      ref.current.style.display = 'block';
      requestAnimationFrame(() => {
        if (ref.current) ref.current.style.opacity = '1';
      });
    }
  }, [item]);

  if (!item || !anchorRect) return <div id="inventory-tooltip" />;

  const r = rarity(item);
  const ammoEntries = item.ammo ? Object.entries(item.ammo).filter(([, v]) => v > 0) : [];
  const pctRound = item.percentage != null ? Math.round(item.percentage) : null;

  return (
    <div
      id="inventory-tooltip"
      ref={ref}
      style={{
        display: 'block',
        left: anchorRect.x + anchorRect.width / 2,
        top: anchorRect.y - 8,
        transform: 'translate(-50%,-100%)',
        opacity: 0,
      }}
    >
      <div className="tt-arrow" />
      <div className={`tt-name ${r}`}>{item.label || item.name}</div>
      <div className={`tt-rarity-dot ${r}`} />
      {item.desc && <div className="tt-desc">{item.desc}</div>}
      <div className="tt-stats">
        {item.weight > 0 && (
          <div className="tt-stat">
            <span className="tt-stat-l">{tr('ui_weight', 'Weight')}</span>
            <span className="tt-stat-v">{fmtWeight(N(item.weight))}</span>
          </div>
        )}
        {item.count > 1 && (
          <div className="tt-stat">
            <span className="tt-stat-l">{tr('ui_quantity', 'Quantity')}</span>
            <span className="tt-stat-v">{item.count}</span>
          </div>
        )}
        {item.isContainer && (
          <div className="tt-stat">
            <span className="tt-stat-l">{tr('ui_storage', 'Storage')}</span>
            <span className="tt-stat-v">{fmtWeight(N(item.containerContentWeight))}/{fmtWeight(N(item.containerMaxWeight))}</span>
          </div>
        )}
        {pctRound != null && (
          <div className="tt-stat">
            <span className="tt-stat-l">{tr('ui_durability', 'Durability')}</span>
            <span className={`tt-stat-v dur-${pctRound <= 25 ? 'low' : pctRound <= 60 ? 'mid' : 'high'}`}>{pctRound}%</span>
          </div>
        )}
        {item.isWeapon && (
          <div className="tt-stat">
            <span className="tt-stat-l">{tr('ui_status', 'Status')}</span>
            <span className={`tt-stat-v ${item.equipped ? 'dur-high' : ''}`}>{item.equipped ? tr('ui_equipped', 'Equipped') : tr('ui_in_bag', 'In bag')}</span>
          </div>
        )}
        {ammoEntries.map(([type, count]) => (
          <div className="tt-stat" key={type}>
            <span className="tt-stat-l">{tr('ui_ammo', 'Ammo')}</span>
            <span className="tt-stat-v">{count}</span>
          </div>
        ))}
      </div>
      <div className="tt-hint">
        {item.isWeapon ? tr('ui_hint_weapon', 'Double-click to equip/unequip · Right-click for more') :
         item.isContainer ? tr('ui_hint_container', 'Double-click to open · Right-click for more') :
         item.canUse ? tr('ui_hint_usable', 'Double-click to use · Right-click for more') :
         tr('ui_hint_move', 'Drag to move · Right-click for more')}
      </div>
    </div>
  );
}
