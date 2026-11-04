import { useRef, useEffect } from 'react';
import { rarity, N, fmtWeight } from '../utils/items';
import { InventoryItem } from '../typings';
import { tr } from '../i18n';
import Frame from './Frame';
import { wsPx } from '../utils/wsScale';

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
      if (anchorRect) {
        const width = ref.current.offsetWidth;
        const height = ref.current.offsetHeight;
        const m = wsPx(8);
        const center = Math.max(width / 2 + m, Math.min(anchorRect.x + anchorRect.width / 2, window.innerWidth - width / 2 - m));
        const above = anchorRect.y - height - m >= m;
        const top = above ? anchorRect.y - m : Math.min(anchorRect.bottom + m, window.innerHeight - height - m);
        ref.current.style.left = `${center}px`;
        ref.current.style.top = `${Math.max(m, top)}px`;
        ref.current.style.transform = above ? 'translate(-50%,-100%)' : 'translateX(-50%)';
        ref.current.dataset.placement = above ? 'above' : 'below';
      }
      requestAnimationFrame(() => {
        if (ref.current) ref.current.style.opacity = '1';
      });
    }
  }, [item, anchorRect]);

  if (!item || !anchorRect) return <div id="inventory-tooltip" />;

  const r = rarity(item);
  const ammoEntries = item.ammo ? Object.entries(item.ammo).filter(([, v]) => v > 0) : [];
  const pctRound = item.percentage != null ? Math.round(item.percentage) : null;

  return (
    <div
      id="inventory-tooltip"
      className="wst-panel"
      ref={ref}
      style={{
        display: 'block',
        left: anchorRect.x + anchorRect.width / 2,
        top: anchorRect.y - wsPx(8),
        transform: 'translate(-50%,-100%)',
        opacity: 0,
      }}
    >
      <Frame />
      <div className="tt-arrow" />
      <div className={`wst-title tt-name ${r}`}>{item.label || item.name}</div>
      <div className={`tt-rarity-dot ${r}`} />
      {item.desc && <div className="wst-sub tt-desc">{item.desc}</div>}
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
