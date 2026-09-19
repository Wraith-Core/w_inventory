import { useState } from 'react';
import { iconUrl, placeholderUrl } from '../utils/nui';
import { rarity } from '../utils/items';
import { HotbarSlot } from '../hooks/useHotbar';
import { tr, trf } from '../i18n';

interface HotBarProps {
  slots: (HotbarSlot | null)[];
  visible: boolean;
  onUseSlot: (idx: number) => void;
}

export default function HotBar({ slots, visible, onUseSlot }: HotBarProps) {
  const [hoveredSlot, setHoveredSlot] = useState<number | null>(null);

  return (
    <div id="hotbar" className={visible ? 'hb-visible' : ''}>
      {slots.map((slot, i) => {
        const r = slot ? rarity(slot) : '';
        return (
          <div
            key={i}
            className={`hb-slot${slot ? ' hb-filled' : ''}${slot?.equipped ? ' hb-equipped' : ''} ${r}`}
            onClick={() => slot && onUseSlot(i)}
            onMouseEnter={() => slot && setHoveredSlot(i)}
            onMouseLeave={() => setHoveredSlot(null)}
          >
            <div className="hb-key">{i + 1}</div>
            {slot ? (
              <>
                <img
                  src={iconUrl(slot.name)}
                  onError={(e) => { (e.target as HTMLImageElement).src = placeholderUrl(); }}
                  draggable={false}
                  alt=""
                />
                <div className="hb-label">{slot.label || slot.name}</div>
                {slot.isWeapon && slot.equipped && <div className="hb-equip-dot" />}
              </>
            ) : (
              <div className="hb-empty-text">{tr('ui_empty', 'Empty')}</div>
            )}
            {hoveredSlot === i && slot && (
              <div className="hb-tooltip">
                <div className="hb-tooltip-name">{slot.label || slot.name}</div>
                <div className="hb-tooltip-hint">{trf('ui_hotbar_hint', 'Press %s to %s', i + 1, slot.isWeapon ? (slot.equipped ? tr('ui_unequip', 'unequip') : tr('ui_equip', 'equip')) : tr('ui_use_action', 'use'))}</div>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
}
