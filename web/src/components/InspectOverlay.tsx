import { useEffect, useRef, useCallback } from 'react';
import { rarity, N, fmtType, fmtWeight } from '../utils/items';
import { getItemUrl, itemImageError } from '../utils/nui';
import { InventoryItem } from '../typings';
import { tr } from '../i18n';

interface InspectOverlayProps {
  item: InventoryItem | null;
  onClose: () => void;
}

export default function InspectOverlay({ item, onClose }: InspectOverlayProps) {
  const bgRef = useRef<HTMLDivElement>(null);
  const barsRef = useRef<HTMLDivElement>(null);
  const bodyRef = useRef<HTMLDivElement>(null);
  const closeTimers = useRef<ReturnType<typeof setTimeout>[]>([]);

  useEffect(() => {
    if (!item) return;
    const t1 = setTimeout(() => {
      bgRef.current?.classList.add('active');
      barsRef.current?.classList.add('active');
    }, 25);
    const t2 = setTimeout(() => {
      bodyRef.current?.classList.add('active');
    }, 180);
    return () => { clearTimeout(t1); clearTimeout(t2); };
  }, [item]);

  useEffect(() => {
    return () => {
      closeTimers.current.forEach(clearTimeout);
    };
  }, []);

  const handleClose = useCallback(() => {
    closeTimers.current.forEach(clearTimeout);
    closeTimers.current = [];

    bodyRef.current?.classList.remove('active');
    if (bodyRef.current) bodyRef.current.style.transition = 'opacity .25s,transform .25s';
    barsRef.current?.classList.remove('active');

    closeTimers.current.push(setTimeout(() => bgRef.current?.classList.remove('active'), 80));
    closeTimers.current.push(setTimeout(() => onClose(), 500));
  }, [onClose]);

  if (!item) return <div id="inspect-overlay" />;

  const r = rarity(item);

  return (
    <div id="inspect-overlay" style={{ display: 'flex' }}>
      <div className="inspect-bg" ref={bgRef} />
      <div className="inspect-bars" ref={barsRef}>
        <div className="bar-t" />
        <div className="bar-b" />
      </div>
      <div className="inspect-body" ref={bodyRef}>
        <img
          className="inspect-img"
          src={getItemUrl(item)}
          onError={(e) => { itemImageError(e.currentTarget, item); }}
          alt=""
        />
        <div className="wst-title inspect-label">{item.label || item.name}</div>
        <div className={`inspect-rarity detail-rarity ${r}`}>{r}</div>
        <div className="wst-rule inspect-sep" />
        <div className="wst-sub inspect-desc">{item.desc || tr('ui_no_description', 'No description.')}</div>
        <div className="inspect-stats">
          <div className="inspect-s">
            <div className="inspect-sv">{fmtWeight(N(item.weight))}</div>
            <div className="inspect-sl">{tr('ui_weight', 'Weight')}</div>
          </div>
          <div className="inspect-s">
            <div className="inspect-sv">{item.count}</div>
            <div className="inspect-sl">{tr('ui_quantity', 'Quantity')}</div>
          </div>
          <div className="inspect-s">
            <div className="inspect-sv">{fmtType(item.type)}</div>
            <div className="inspect-sl">{tr('ui_type', 'Type')}</div>
          </div>
          {item.isContainer && (
            <div className="inspect-s">
              <div className="inspect-sv">{fmtWeight(N(item.containerMaxWeight))}</div>
              <div className="inspect-sl">{tr('ui_capacity', 'Capacity')}</div>
            </div>
          )}
        </div>
        <div className="wst-button inspect-x" onClick={handleClose}>[ {tr('ui_esc_close', 'ESC TO CLOSE')} ]</div>
      </div>
    </div>
  );
}
