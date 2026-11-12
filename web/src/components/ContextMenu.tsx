import { useEffect, useRef } from 'react';
import { SVG_BAG, SVG_EYE } from '../utils/items';
import { InventoryItem } from '../typings';
import { tr, trf } from '../i18n';
import { iso } from '../utils/words';
import { wsPx } from '../utils/wsScale';

const SVG_USE = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg>;
const SVG_SPLIT = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M14 4l2.29 2.29-2.88 2.88 1.42 1.42 2.88-2.88L20 10V4h-6zm-4 0H4v6l2.29-2.29 4.71 4.7V20h2v-8.41l-5.29-5.3L10 4z"/></svg>;
const SVG_STORE = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-2 10h-4v4h-2v-4H7v-2h4V7h2v4h4v2z"/></svg>;
const SVG_DROP = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>;
const SVG_TAKE = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19 12v7H5v-7H3v7c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2v-7h-2zm-6 .67l2.59-2.58L17 11.5l-5 5-5-5 1.41-1.41L11 12.67V3h2v9.67z"/></svg>;
const SVG_GIVE = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>;
const SVG_UNLOAD = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M7 3h10v2H7V3zm1 4h8l2 4v8a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2v-8l2-4zm2 3-1 2v6h6v-6l-1-2h-4zm-7 1h2v8H3v-8zm16 0h2v8h-2v-8z"/></svg>;

interface ContextMenuProps {
  visible: boolean;
  x: number;
  y: number;
  item: InventoryItem | null;
  idx: number | null;
  panel: string;
  containerOpen: string | null;
  onClose: () => void;
  onUse: (idx: number) => void;
  onDrop: (idx: number) => void;
  onGive: (idx: number) => void;
  onInspect: (idx: number, panel: string) => void;
  onOpenContainer: (idx: number) => void;
  onStoreIn: (idx: number) => void;
  onTakeOut: (idx: number) => void;
  onSplit: (idx: number, panel: string) => void;
  onRemoveAmmo: (idx: number) => void;
  customButtons?: Array<{ id: number; label: string; group?: string }>;
  onCustomButton?: (idx: number, buttonId: number) => void;
  /** How many a Give hands over (the quantity field, or the whole stack) - shown under the option. */
  giveCount?: number;
}

export default function ContextMenu({ visible, x, y, item, idx, panel, containerOpen, onClose, onUse, onDrop, onGive, onInspect, onOpenContainer, onStoreIn, onTakeOut, onSplit, onRemoveAmmo, customButtons, onCustomButton, giveCount }: ContextMenuProps) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!visible) return;
    function handler(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) onClose();
    }
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, [visible, onClose]);

  useEffect(() => {
    if (visible && ref.current) {
      ref.current.style.opacity = '0';
      const m = wsPx(8);
      ref.current.style.left = `${Math.max(m, Math.min(x, window.innerWidth - ref.current.offsetWidth - m))}px`;
      ref.current.style.top = `${Math.max(m, Math.min(y, window.innerHeight - ref.current.offsetHeight - m))}px`;
      requestAnimationFrame(() => {
        if (ref.current) ref.current.style.opacity = '1';
      });
    }
  }, [visible, x, y]);

  if (!visible || !item || idx === null) return <div id="inventory-options" />;

  const sections: React.ReactNode[][] = [];

  if (panel === 'main') {
    const primary: React.ReactNode[] = [];
    if (item.isContainer) {
      primary.push(
        <div key="open" className="option" onClick={() => { onOpenContainer(idx); onClose(); }}>
          {SVG_BAG} <span>{tr('ui_open', 'Open')}</span> <kbd className="opt-key">{tr('ui_double_click', 'Double-click')}</kbd>
        </div>
      );
    } else {
      primary.push(
        <div key="use" className="option" onClick={() => { onUse(idx); onClose(); }}>
          {SVG_USE} <span>{tr('ui_use', 'Use')}</span> <kbd className="opt-key">{tr('ui_double_click', 'Double-click')}</kbd>
        </div>
      );
    }
    primary.push(
      <div key="inspect" className="option" onClick={() => { onInspect(idx, 'main'); onClose(); }}>
        {SVG_EYE} <span>{tr('ui_inspect', 'Inspect')}</span>
      </div>
    );
    if (primary.length > 0) sections.push(primary);

    const secondary: React.ReactNode[] = [];
    if (item.count > 1) {
      secondary.push(
        <div key="split" className="option" onClick={() => { onSplit(idx, panel); onClose(); }}>
          {SVG_SPLIT} <span>{tr('ui_split', 'Split')}</span>
        </div>
      );
    }
    if (containerOpen !== null && !item.isContainer) {
      secondary.push(
        <div key="store" className="option" onClick={() => { onStoreIn(idx); onClose(); }}>
          {SVG_STORE} <span>{tr('ui_store_container', 'Store in container')}</span>
        </div>
      );
    }
    if (Number(item.metadata?.ammo || 0) > 0) {
      secondary.push(
        <div key="unload-ammo" className="option" onClick={() => { onRemoveAmmo(idx); onClose(); }}>
          {SVG_UNLOAD} <span>{tr('ui_remove_ammo', 'Remove ammo')}</span>
        </div>
      );
    }

    if (customButtons && customButtons.length > 0 && onCustomButton) {
      for (const btn of customButtons) {
        secondary.push(
          <div key={`btn-${btn.id}-${btn.label}`} className="option" onClick={() => { onCustomButton(idx, btn.id); onClose(); }}>
            {SVG_USE} <span>{btn.label}</span>
          </div>
        );
      }
    }

    if (secondary.length > 0) sections.push(secondary);

    const danger: React.ReactNode[] = [];
    danger.push(
      <div key="give" className="option" onClick={() => { onGive(idx); onClose(); }}>
        {SVG_GIVE} <span>{tr('ui_give', 'Give')}{giveCount != null && giveCount > 0 && item && (
          <small className="nb-opt-sub">{trf('ui_nb_give_to', 'you give %s %s to the player beside you', iso(giveCount), item.label || item.name)}</small>
        )}</span>
      </div>
    );
    danger.push(
      <div key="drop" className="option danger" onClick={() => { onDrop(idx); onClose(); }}>
        {SVG_DROP} <span>{tr('ui_drop', 'Drop')}</span>
      </div>
    );
    sections.push(danger);
  } else if (panel === 'container') {
    sections.push([
      <div key="takeout" className="option" onClick={() => { onTakeOut(idx); onClose(); }}>
        {SVG_TAKE} <span>{tr('ui_take_out', 'Take out')}</span>
      </div>,
      <div key="inspect" className="option" onClick={() => { onInspect(idx, 'container'); onClose(); }}>
        {SVG_EYE} <span>{tr('ui_inspect', 'Inspect')}</span>
      </div>,
    ]);
  } else if (panel === 'right') {
    sections.push([
      <div key="inspect" className="option" onClick={() => { onInspect(idx, 'right'); onClose(); }}>
        {SVG_EYE} <span>{tr('ui_inspect', 'Inspect')}</span>
      </div>,
    ]);
  }

  const elements: React.ReactNode[] = [];
  sections.forEach((sec, si) => {
    if (si > 0) elements.push(<div key={`sep-${si}`} className="opt-sep" />);
    sec.forEach((el) => elements.push(el));
  });

  return (
    <div
      id="inventory-options"
      ref={ref}
      className="show wf-shell is-small"
      style={{ left: x, top: y, opacity: 0 }}
      onMouseDown={e => e.stopPropagation()}
    >
      <div className="opt-header">{item.label || item.name}</div>
      {elements}
    </div>
  );
}
