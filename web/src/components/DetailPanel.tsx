import { rarity, rarityLabel, N, fmtWeight } from '../utils/items';
import { getItemUrl, itemImageError } from '../utils/nui';
import { setClipboard } from '../utils/setClipboard';
import { InventoryItem } from '../typings';
import { tr, trf } from '../i18n';
import { iso, kgShort, durabilityWord } from '../utils/words';
import { Fold } from './Notebook';
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

/** Metadata the sentence and rows above do not already say, as raw key / value lines for the advanced fold. */
const SHOWN_META = new Set(['label', 'description', 'descriptionKey', 'descriptionArgs', 'durability', 'ammo', 'serial',
  'serial_number', 'container', 'containerMaxWeight', 'containerContentWeight', 'containerSlots', 'image', 'imageurl']);
function metaRows(meta: Record<string, any> | undefined): Array<[string, string]> {
  if (!meta || typeof meta !== 'object') return [];
  const rows: Array<[string, string]> = [];
  for (const [key, value] of Object.entries(meta)) {
    if (SHOWN_META.has(key) || value == null || value === '') continue;
    let text = typeof value === 'object' ? JSON.stringify(value) : String(value);
    if (text.length > 48) text = text.slice(0, 47) + '…';
    rows.push([key, text]);
    if (rows.length >= 12) break;
  }
  return rows;
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
  const ammoEntries = item.ammo ? Object.entries(item.ammo).filter(([, v]) => v > 0) : [];
  const pctRound = item.percentage != null ? Math.round(item.percentage) : null;
  const title = item.label || item.name;
  // A catalogue with no description repeats the name there: the line says nothing new, so it is left out.
  const desc = item.desc && !sameText(item.desc, title) && !sameText(item.desc, item.name) ? item.desc : null;
  // The plain sentence in place of the weight / quantity / total rows.
  const unitGrams = item.count > 1 ? N(item.weight) / item.count : N(item.weight);
  const plain = item.count > 1
    ? trf('ui_nb_detail_many', 'You have %s · %s kg each, %s kg in all.', iso(item.count), iso(kgShort(unitGrams)), iso(kgShort(N(item.weight))))
    : trf('ui_nb_detail_one', 'It weighs %s kg.', iso(kgShort(unitGrams)));
  const serialRaw = item.isWeapon ? (item.metadata?.serial || item.metadata?.serial_number) : null;
  const serial = serialRaw ? String(serialRaw) : null;
  const rawMeta = metaRows(item.metadata);

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
      className={'wf-shell' + (fitted ? ' positioned' : shifted ? ' shifted' : '')}
      style={{ display: 'flex', ...posStyle }}
      onWheel={(e) => {
        // The wheel over the picture or the footer still moves the body.
        const body = bodyRef.current;
        if (body && !body.contains(e.target as Node)) body.scrollTop += e.deltaY;
      }}
    >
      <div className={`detail-hero ${r}`}>
        <div className="detail-img-wrap">
          <img
            src={getItemUrl(item)}
            onError={(e) => { itemImageError(e.currentTarget, item); }}
            alt=""
          />
        </div>
        <div className="detail-name">{title}</div>
        <div className={`detail-rarity ${r}`}>{rarityLabel(r)}</div>
      </div>

      <div className="detail-sep" />

      <div ref={bodyRef} className={'detail-body' + (fade.top ? ' fade-top' : '') + (fade.bottom ? ' fade-bottom' : '')}>
      {desc && <div className="detail-desc">{desc}</div>}

      <div className="detail-plain">{plain}</div>

      <div className="detail-stats">
        {item.isContainer && (
          <div className="detail-stat">
            <span className="lbl">{tr('ui_storage', 'Storage')}</span>
            <span className="val">{fmtWeight(N(item.containerContentWeight))}/{fmtWeight(N(item.containerMaxWeight))}</span>
          </div>
        )}
        {item.isWeapon && (
          <div className="detail-stat">
            <span className="lbl">{tr('ui_status', 'Status')}</span>
            <span className={`val nb-words ${item.equipped ? 'equipped-text' : ''}`}>{item.equipped ? tr('ui_equipped', 'Equipped') : tr('ui_in_bag', 'In bag')}</span>
          </div>
        )}
        {ammoEntries.map(([type, count]) => (
          <div className="detail-stat" key={type}>
            <span className="lbl">{tr('ui_ammo', 'Ammo')}</span>
            <span className="val">{count}</span>
          </div>
        ))}
        {pctRound != null && (
          <div className="detail-stat">
            <span className="lbl">{tr('ui_durability', 'Durability')}</span>
            <span className={`val nb-words dur-${pctRound <= 25 ? 'low' : pctRound <= 60 ? 'mid' : 'high'}`}>{durabilityWord(pctRound)} · {iso(pctRound + '%')}</span>
          </div>
        )}
      </div>

      <Fold key={itemKey} title={tr('ui_nb_advanced', 'Advanced options')}>
        <div className="detail-stats nb-adv">
          <div className="detail-stat">
            <span className="lbl">{tr('ui_nb_item_id', 'Item id')}</span>
            <span className="val">{item.name}</span>
          </div>
          <div className="detail-stat">
            <span className="lbl">{tr('ui_nb_slot', 'Slot')}</span>
            <span className="val">{item.slot}</span>
          </div>
          {serial && (
            <div
              className="detail-stat"
              style={{ cursor: 'pointer' }}
              title={tr('ui_click_copy_serial', 'Click to copy serial number')}
              onClick={() => setClipboard(serial)}
            >
              <span className="lbl">{tr('ui_serial', 'Serial number')}</span>
              <span className="val" style={{ fontSize: '.42rem', letterSpacing: '.04em' }}>{serial} ⧉</span>
            </div>
          )}
          {rawMeta.map(([key, value]) => (
            <div className="detail-stat" key={key}>
              <span className="lbl nb-raw">{key}</span>
              <span className="val nb-raw">{value}</span>
            </div>
          ))}
        </div>
      </Fold>
      </div>

      <div className="detail-sep" />

      <div className="detail-hint">
        <svg viewBox="0 0 24 24" fill="currentColor" style={{width:'.5rem',height:'.5rem',opacity:.4}}><path d="M2 12C2 6.48 6.48 2 12 2s10 4.48 10 10-4.48 10-10 10S2 17.52 2 12zm11-1v6h-2v-6h2zm0-4v2h-2V7h2z"/></svg>
        {tr('ui_right_click_options', 'Right-click for options')}
      </div>
    </div>
  );
}
