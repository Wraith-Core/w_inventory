import { useMemo, useState, useEffect, useRef } from 'react';
import InventoryGrid from './InventoryGrid';
import { N, SVG_BAG, SVG_X, fmtWeight } from '../utils/items';
import { InventoryItem } from '../typings';
import { tr, trf } from '../i18n';
import { iso, kgShort, itemsWord } from '../utils/words';
import usePanelPosition from '../hooks/usePanelPosition';
import { PANEL_W_REM, PANEL_GAP_REM, remPx } from '../utils/layout';

const SVG_LOCK = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM9 8V6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9z"/></svg>;
const SVG_UNLOCK = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6h2c0-1.66 1.34-3 3-3s3 1.34 3 3v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2z"/></svg>;
const SVG_WEIGHT = <svg viewBox="0 0 24 24" fill="currentColor" style={{width:'.55rem',height:'.55rem'}}><path d="M12 3a4 4 0 0 0-3.46 2H4l1.5 13.5C5.73 20.44 7.41 21 8 21h8c.59 0 2.27-.56 2.5-2.5L20 5h-4.54A4 4 0 0 0 12 3zm0 2a2 2 0 1 1 0 4 2 2 0 0 1 0-4z"/></svg>;

interface ContainerPanelProps {
  containerOpen: string | null;
  containerGrid: (InventoryItem | null)[];
  containerLabel: string;
  containerMaxWeight: number;
  containerSlots: number;
  selected: number | null;
  selectedPanel: string;
  onSelect: (idx: number, panel: string, e: React.MouseEvent) => void;
  onContextMenu: (e: React.MouseEvent, idx: number, panel: string) => void;
  onDoubleClick: (idx: number, item: InventoryItem) => void;
  onMouseOver: (idx: number, panel: string) => void;
  onMouseLeave: () => void;
  onClose: () => void;
  panelPos?: { x: number; y: number } | null;
}

export default function ContainerPanel({ containerOpen, containerGrid, containerLabel, containerMaxWeight, containerSlots, selected, selectedPanel, onSelect, onContextMenu, onDoubleClick, onMouseOver, onMouseLeave, onClose, panelPos }: ContainerPanelProps) {
  const [entered, setEntered] = useState(false);
  const panelRef = useRef<HTMLDivElement>(null);
  const fitted = usePanelPosition(panelRef, panelPos ? { x:panelPos.x + remPx(PANEL_W_REM + PANEL_GAP_REM), y:panelPos.y } : null, containerOpen !== null);

  useEffect(() => {
    if (containerOpen !== null) {
      requestAnimationFrame(() => requestAnimationFrame(() => setEntered(true)));
    } else {
      setEntered(false);
    }
  }, [containerOpen]);

  const { cw, itemCount } = useMemo(() => {
    let w = 0, n = 0;
    for (const it of containerGrid) {
      if (!it) continue;
      // Slot weight already includes the full stack and its metadata.
      w += N(it.weight);
      n++;
    }
    return { cw: w, itemCount: n };
  }, [containerGrid]);

  if (containerOpen === null) return <div id="container-panel" style={{ display: 'none' }} />;

  const wp = containerMaxWeight > 0 ? Math.min(100, (cw / containerMaxWeight) * 100) : 0;
  const weightZone = wp > 90 ? 'critical' : wp > 70 ? 'warn' : 'ok';
  const slotPct = containerSlots > 0 ? Math.min(100, (itemCount / containerSlots) * 100) : 0;

  const cpPosStyle: React.CSSProperties = fitted
    ? {
        left: `${fitted.x}px`,
        top: `${fitted.y}px`,
        transform: entered ? 'none' : 'translateX(-10px) scale(.97)',
      }
    : {};

  return (
    <div id="container-panel" ref={panelRef} className={'wf-shell' + (entered ? ' cp-entered' : '')} style={{ display: 'flex', ...cpPosStyle }}>
      <div className="cp-header">
        <div className="cp-title-area">
          <div className="cp-icon">{SVG_BAG}</div>
          <div className="cp-title-text">
            <div className="cp-title">{containerLabel}</div>
            <div className="cp-subtitle">{(itemCount === 0 ? tr('ui_nb_side_empty', 'Nothing inside') : trf('ui_nb_side_has', 'Holds %s', itemsWord(itemCount)))
              + (containerMaxWeight > 0 ? ' · ' + trf('ui_nb_kg_of', '%s of %s kg', iso(kgShort(cw)), iso(kgShort(containerMaxWeight))) : '')}</div>
          </div>
        </div>
        <div className="cp-close" onClick={onClose}>{SVG_X}</div>
      </div>

      <div className="cp-metrics">
        <div className={`cp-metric ${weightZone}`}>
          <div className="cp-metric-header">
            {SVG_WEIGHT}
            <span className="cp-metric-label">{tr('ui_weight', 'Weight')}</span>
            <span className="cp-metric-value">{fmtWeight(cw)} / {fmtWeight(containerMaxWeight)}</span>
          </div>
          <div className="cp-bar">
            <div className="cp-bar-fill" style={{ width: `${wp}%` }} />
            {wp > 70 && <div className="cp-bar-marker" style={{ left: '70%' }} />}
            {wp > 90 && <div className="cp-bar-marker warn" style={{ left: '90%' }} />}
          </div>
        </div>
        <div className="cp-metric">
          <div className="cp-metric-header">
            <svg viewBox="0 0 24 24" fill="currentColor" style={{width:'.55rem',height:'.55rem'}}><path d="M4 8h4V4H4v4zm6 12h4v-4h-4v4zm-6 0h4v-4H4v4zm0-6h4v-4H4v4zm6 0h4v-4h-4v4zm6-10v4h4V4h-4zm-6 4h4V4h-4v4zm6 6h4v-4h-4v4zm0 6h4v-4h-4v4z"/></svg>
            <span className="cp-metric-label">{tr('ui_slots', 'Slots')}</span>
            <span className="cp-metric-value">{itemCount} / {containerSlots}</span>
          </div>
          <div className="cp-bar">
            <div className="cp-bar-fill slots" style={{ width: `${slotPct}%` }} />
          </div>
        </div>
      </div>

      <div className="cp-divider" />

      {itemCount === 0 ? (
        <div className="cp-empty">
          <div className="cp-empty-icon">{SVG_UNLOCK}</div>
          <div className="cp-empty-text">{tr('ui_empty', 'Empty')}</div>
          <div className="cp-empty-hint">{tr('ui_container_empty_hint', 'Drag items here or right-click to store')}</div>
        </div>
      ) : (
        <InventoryGrid
          grid={containerGrid}
          category="all"
          search=""
          selected={selected}
          panel="container"
          selectedPanel={selectedPanel}
          onSelect={onSelect}
          onContextMenu={onContextMenu}
          onDoubleClick={onDoubleClick}
          onMouseOver={onMouseOver}
          onMouseLeave={onMouseLeave}
        />
      )}

      <div className="cp-footer">
        <div className="cp-footer-lock">{itemCount > 0 ? SVG_LOCK : SVG_UNLOCK}</div>
        <span>{tr('ui_drag_between_panels', 'Drag items between panels')}</span>
      </div>
    </div>
  );
}
