import { rarity, rarityLabel, N, fmtWeight } from '../utils/items';
import { getItemUrl, itemImageError } from '../utils/nui';
import { setClipboard } from '../utils/setClipboard';
import { InventoryItem } from '../typings';
import { tr } from '../i18n';
import Frame from './Frame';
import { useLayoutEffect, useRef, useState } from 'react';
import usePanelPosition from '../hooks/usePanelPosition';
import { PANEL_W_REM, CONTAINER_W_REM, PANEL_GAP_REM, remPx } from '../utils/layout';

interface DetailPanelProps {
  item: InventoryItem | null;
  panel: string;
  containerOpen: string | null;
  panelPos?: { x: number; y: number } | null;
}

/** Two texts that say the same thing once case, spaces, direction marks and end punctuation are set aside. */
function sameText(a?: string, b?: string): boolean {
  const norm = (s?: string) => String(s ?? '').normalize('NFKC').replace(/[\u200e\u200f\u061c]/g, '')
    .replace(/[\s.\u06d4\u2026!?\u061f,\u060c:;\-\u2013\u2014]+/g, ' ').trim().toLowerCase();
  const left = norm(a);
  return left !== '' && left === norm(b);
}

export default function DetailPanel({ item, panel, containerOpen, panelPos }: DetailPanelProps) {
  const panelRef = useRef<HTMLDivElement>(null);
  const bodyRef = useRef<HTMLDivElement>(null);
  // The body (description + rows) is the only part that scrolls, with no bar: a fade on the edge that has more.
  const [fade, setFade] = useState({ top:false, bottom:false });
  const extra = PANEL_W_REM + PANEL_GAP_REM + (containerOpen !== null ? CONTAINER_W_REM + PANEL_GAP_REM : 0);
  const fitted = usePanelPosition(panelRef, panelPos ? { x:panelPos.x + remPx(extra), y:panelPos.y } : null, !!item);
  // Back to the top when another item is shown; a refresh of the same item (the grid rebuilt) keeps the place.
  const itemKey = item ? `${panel}:${item.slot}:${item.name}` : '';
  useLayoutEffect(() => { if (bodyRef.current) bodyRef.current.scrollTop = 0; }, [itemKey]);
  useLayoutEffect(() => {
    const body = bodyRef.current;
    if (!body) return;
    const measure = () => {
      const top = body.scrollTop > 1;
      const bottom = body.scrollTop + body.clientHeight < body.scrollHeight - 1;
      setFade(old => old.top === top && old.bottom === bottom ? old : { top, bottom });
    };
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(body);
    Array.from(body.children).forEach(child => observer.observe(child));
    body.addEventListener('scroll', measure, { passive:true });
    return () => { observer.disconnect(); body.removeEventListener('scroll', measure); };
  }, [item]);
  if (!item) return <div id="inventory-detail" style={{ display: 'none' }} />;

  const r = rarity(item);
  const shifted = containerOpen !== null;
  const totalWeight = fmtWeight(N(item.weight));
  const unitWeight = item.count > 1 ? fmtWeight(N(item.weight) / item.count) : fmtWeight(N(item.weight));
  const ammoEntries = item.ammo ? Object.entries(item.ammo).filter(([, v]) => v > 0) : [];
  const pctRound = item.percentage != null ? Math.round(item.percentage) : null;
  const title = item.label || item.name;
  // A catalogue with no description repeats the name there: the line says nothing new, so it is left out.
  const desc = item.desc && !sameText(item.desc, title) && !sameText(item.desc, item.name) ? item.desc : null;

  const posStyle: React.CSSProperties = fitted
    ? {
        left: `${fitted.x}px`,
        top: `${fitted.y}px`,
        transform: 'none',
      }
    : {};

  return (
    <div
      id="inventory-detail"
      ref={panelRef}
      className={'wst-panel ' + (fitted ? 'positioned' : shifted ? 'shifted' : '')}
      style={{ display: 'flex', ...posStyle }}
      onWheel={(e) => {
        // The wheel over the picture or the footer still moves the body.
        const body = bodyRef.current;
        if (body && !body.contains(e.target as Node)) body.scrollTop += e.deltaY;
      }}
    >
      <Frame px={11} opacity={0.45} />
      <div className={`detail-hero ${r}`}>
        <div className="detail-img-wrap">
          <img
            src={getItemUrl(item)}
            onError={(e) => { itemImageError(e.currentTarget, item); }}
            alt=""
          />
        </div>
        <div className="wst-title detail-name">{title}</div>
        <div className={`detail-rarity ${r}`}>{rarityLabel(r)}</div>
      </div>

      <div className="wst-rule detail-sep" />

      <div ref={bodyRef} className={'detail-body' + (fade.top ? ' fade-top' : '') + (fade.bottom ? ' fade-bottom' : '')}>
      {desc && <div className="wst-sub detail-desc">{desc}</div>}

      <div className="detail-stats">
        <div className="wst-row detail-stat">
          <span className="lbl">{tr('ui_weight', 'Weight')}</span>
          <span className="val">{unitWeight}</span>
        </div>
        <div className="wst-row detail-stat">
          <span className="lbl">{tr('ui_quantity', 'Quantity')}</span>
          <span className="val">{item.count}</span>
        </div>
        {item.count > 1 && (
          <div className="wst-row detail-stat">
            <span className="lbl">{tr('ui_total_weight', 'Total weight')}</span>
            <span className="val">{totalWeight}</span>
          </div>
        )}
        {item.isContainer && (
          <div className="wst-row detail-stat">
            <span className="lbl">{tr('ui_storage', 'Storage')}</span>
            <span className="val">{fmtWeight(N(item.containerContentWeight))}/{fmtWeight(N(item.containerMaxWeight))}</span>
          </div>
        )}
        {item.isWeapon && (
          <div className="wst-row detail-stat">
            <span className="lbl">{tr('ui_status', 'Status')}</span>
            <span className={`val ${item.equipped ? 'equipped-text' : ''}`}>{item.equipped ? tr('ui_equipped', 'Equipped') : tr('ui_in_bag', 'In bag')}</span>
          </div>
        )}
        {item.isWeapon && (item.metadata?.serial || item.metadata?.serial_number) && (
          <div
            className="wst-row detail-stat"
            style={{ cursor: 'pointer' }}
            title={tr('ui_click_copy_serial', 'Click to copy serial number')}
            onClick={() => setClipboard(String(item.metadata?.serial || item.metadata?.serial_number))}
          >
            <span className="lbl">{tr('ui_serial', 'Serial number')}</span>
            <span className="val" style={{ fontSize: '.42rem', letterSpacing: '.04em' }}>
              {item.metadata?.serial || item.metadata?.serial_number} ⧉
            </span>
          </div>
        )}
        {ammoEntries.map(([type, count]) => (
          <div className="wst-row detail-stat" key={type}>
            <span className="lbl">{tr('ui_ammo', 'Ammo')}</span>
            <span className="val">{count}</span>
          </div>
        ))}
        {pctRound != null && (
          <div className="wst-row detail-stat">
            <span className="lbl">{tr('ui_durability', 'Durability')}</span>
            <span className={`val dur-${pctRound <= 25 ? 'low' : pctRound <= 60 ? 'mid' : 'high'}`}>{pctRound}%</span>
          </div>
        )}
      </div>
      </div>

      <div className="wst-rule detail-sep" />

      <div className="detail-hint">
        <svg viewBox="0 0 24 24" fill="currentColor" style={{width:'.5rem',height:'.5rem',opacity:.4}}><path d="M2 12C2 6.48 6.48 2 12 2s10 4.48 10 10-4.48 10-10 10S2 17.52 2 12zm11-1v6h-2v-6h2zm0-4v2h-2V7h2z"/></svg>
        {tr('ui_right_click_options', 'Right-click for options')}
      </div>
    </div>
  );
}
