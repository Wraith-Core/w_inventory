import { useEffect, useMemo, useState } from 'react';
import { tr } from '../i18n';
import Frame from './Frame';

export interface AmmoPickerOption {
  slot: number;
  item: string;
  label: string;
  count: number;
  active?: boolean;
  /** Bookmarked by right-click in the bag's ammunition picker. */
  preferred?: boolean;
}

export interface AmmoPickerData {
  weaponSlot: number;
  weaponName: string;
  weaponLabel: string;
  loaded: number;
  capacity: number;
  options: AmmoPickerOption[];
}

interface AmmoPickerProps {
  data: AmmoPickerData | null;
  busy: boolean;
  onSelect: (weaponSlot: number, ammoSlot: number) => void;
  onUnload: (weaponSlot: number) => void;
  onSetPreferred: (weaponSlot: number, item: string) => void;
  onClose: () => void;
}

const Cartridge = () => (
  <svg viewBox="0 0 32 64" aria-hidden="true">
    <path d="M11 3h10l3 8v30l-4 12v7H12v-7L8 41V11l3-8Z" />
    <path d="M9 15h14M9 39h14M12 53h8" />
  </svg>
);

export default function AmmoPicker({ data, busy, onSelect, onUnload, onSetPreferred, onClose }: AmmoPickerProps) {
  const defaultSlot = useMemo(() => {
    if (!data?.options?.length) return null;
    return (data.options.find((option) => option.active) || data.options[0]).slot;
  }, [data]);
  const [selectedSlot, setSelectedSlot] = useState<number | null>(defaultSlot);

  useEffect(() => setSelectedSlot(defaultSlot), [defaultSlot]);

  useEffect(() => {
    if (!data) return;
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.preventDefault();
        event.stopPropagation();
        onClose();
      } else if (event.key === 'Enter' && selectedSlot !== null && !busy) {
        event.preventDefault();
        onSelect(data.weaponSlot, selectedSlot);
      }
    };
    document.addEventListener('keydown', onKeyDown, true);
    return () => document.removeEventListener('keydown', onKeyDown, true);
  }, [data, selectedSlot, busy, onSelect, onClose]);

  if (!data) return null;

  const loaded = Math.max(0, Number(data.loaded) || 0);
  const capacity = Math.max(1, Number(data.capacity) || 1);
  const loadPercent = Math.min(100, (loaded / capacity) * 100);
  const selected = data.options.find((option) => option.slot === selectedSlot);
  const selectedLocked = loaded > 0 && selected && !selected.active;

  return (
    <div
      className="ammo-picker-backdrop"
      onMouseDown={(event) => {
        if (event.target === event.currentTarget && !busy) onClose();
      }}
    >
      <section
        id="inv-ammo-picker"
        role="dialog"
        aria-modal="true"
        aria-labelledby="ammo-picker-title"
        onMouseDown={(event) => event.stopPropagation()}
      >
        <Frame px={12} opacity={0.5} />
        <div className="ammo-picker-rail" />

        <header className="ammo-picker-header">
          <div className="ammo-picker-emblem"><Cartridge /></div>
          <div className="ammo-picker-heading">
            <span className="ammo-picker-kicker">{data.weaponLabel}</span>
            <h2 id="ammo-picker-title">{tr('ui_ammo_select_title', 'Choose ammunition')}</h2>
            <p>{tr('ui_ammo_select_subtitle', 'Select the rounds to load into this weapon')}</p>
          </div>
          <button className="ammo-picker-close" type="button" onClick={onClose} disabled={busy} aria-label={tr('ui_cancel', 'Cancel')}>
            ×
          </button>
        </header>

        <div className="ammo-picker-load">
          <div className="ammo-picker-load-copy">
            <span>{tr('ui_ammo_loaded', 'Loaded')}</span>
            <strong>{loaded}<small> / {capacity}</small></strong>
          </div>
          <div className="ammo-picker-load-track"><i style={{ width: `${loadPercent}%` }} /></div>
        </div>

        <div className="ammo-picker-options" role="radiogroup">
          {data.options.map((option, index) => {
            const chosen = option.slot === selectedSlot;
            const locked = loaded > 0 && !option.active;
            return (
              <button
                type="button"
                role="radio"
                aria-checked={chosen}
                className={`ammo-picker-option${chosen ? ' selected' : ''}${locked ? ' locked' : ''}`}
                key={`${option.slot}:${option.item}`}
                onClick={() => setSelectedSlot(option.slot)}
                onContextMenu={(event) => {
                  event.preventDefault();
                  if (!busy) onSetPreferred(data.weaponSlot, option.item);
                }}
                disabled={busy}
                title={tr('ui_ammo_preferred_hint', 'Select a type, then Load rounds · Right-click to mark a favorite')}
              >
                <span className="ammo-picker-index">{String(index + 1).padStart(2, '0')}</span>
                <span className="ammo-picker-cartridge"><Cartridge /></span>
                <span className="ammo-picker-option-copy">
                  <strong>{option.label || option.item}</strong>
                  <small>{tr('ui_ammo_available', 'Available')} · {option.count}</small>
                </span>
                {option.preferred && <span className="ammo-picker-preferred">★ {tr('ui_ammo_preferred', 'Preferred')}</span>}
                {option.active && <span className="ammo-picker-current">{tr('ui_ammo_current', 'Current')}</span>}
                <span className="ammo-picker-radio"><i /></span>
              </button>
            );
          })}
        </div>

        {selectedLocked && (
          <div className="ammo-picker-warning">
            <span>{tr('ammo_switch_loaded', 'Unload the current rounds before switching ammo type')}</span>
            <button type="button" onClick={() => onUnload(data.weaponSlot)} disabled={busy}>
              {tr('ui_ammo_unload', 'Unload current rounds')}
            </button>
          </div>
        )}

        <p className="ammo-picker-hint">{tr('ui_ammo_preferred_hint', 'Select a type, then Load rounds · Right-click to mark a favorite')}</p>

        <footer className="ammo-picker-actions">
          <button type="button" className="ammo-picker-cancel" onClick={onClose} disabled={busy}>
            {tr('ui_cancel', 'Cancel')}
          </button>
          <button
            type="button"
            className="ammo-picker-confirm"
            onClick={() => selectedSlot !== null && onSelect(data.weaponSlot, selectedSlot)}
            disabled={busy || selectedSlot === null || !!selectedLocked}
          >
            <Cartridge />
            <span>{busy ? '…' : tr('ui_ammo_load', 'Load rounds')}</span>
          </button>
        </footer>
      </section>
    </div>
  );
}
