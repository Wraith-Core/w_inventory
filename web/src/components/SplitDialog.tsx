import { useState, useEffect, useCallback } from 'react';
import type { CSSProperties } from 'react';
import { getItemUrl, itemImageError } from '../utils/nui';
import { InventoryItem } from '../typings';
import { tr, trf } from '../i18n';
import Frame from './Frame';

interface SplitDialogProps {
  item: InventoryItem | null;
  visible: boolean;
  onConfirm: (amount: number) => void;
  onCancel: () => void;
}

export default function SplitDialog({ item, visible, onConfirm, onCancel }: SplitDialogProps) {
  const [amount, setAmount] = useState(1);

  useEffect(() => {
    if (visible && item) {
      setAmount(Math.max(1, Math.floor(item.count / 2)));
    }
  }, [visible, item]);

  const handleConfirm = useCallback(() => {
    if (!item) return;
    if (amount > 0 && amount < item.count) {
      onConfirm(amount);
    }
  }, [amount, item, onConfirm]);

  if (!visible || !item) return null;

  const max = item.count - 1;
  const keepAmount = item.count - amount;
  const fill = max > 1 ? ((amount - 1) / (max - 1)) * 100 : 100;

  return (
    <>
      <div className="split-backdrop" onClick={onCancel} />
      <div id="inv-split-dialog" className="wst-panel" style={{ display: 'flex' }}>
        <Frame px={11} opacity={0.5} />
        <div className="wst-header split-header">
          <img
            src={getItemUrl(item)}
            onError={(e) => { itemImageError(e.currentTarget, item); }}
            alt="" className="split-icon"
          />
          <div className="wst-title split-title">{trf('ui_split_title', 'Split %s', item.label || item.name)}</div>
        </div>

        <div className="split-preview">
          <div className="split-stack">
            <span className="split-stack-num">{keepAmount}</span>
            <span className="split-stack-label">{tr('ui_keep', 'Keep')}</span>
          </div>
          <div className="split-arrow">
            <svg viewBox="0 0 24 24" fill="currentColor"><path d="M16.01 11H4v2h12.01v3L20 12l-3.99-4z"/></svg>
          </div>
          <div className="split-stack">
            <span className="split-stack-num highlight">{amount}</span>
            <span className="split-stack-label">{tr('ui_split', 'Split')}</span>
          </div>
        </div>

        <div className="split-slider-wrap">
          <span className="wst-button split-adj" onClick={() => setAmount((a) => Math.max(1, a - 1))}>−</span>
          <input
            type="range"
            className="w-range split-slider"
            style={{ '--w-fill': `${fill}%` } as CSSProperties}
            min={1} max={max} value={amount}
            onChange={(e) => setAmount(parseInt(e.target.value) || 1)}
          />
          <span className="wst-button split-adj" onClick={() => setAmount((a) => Math.min(max, a + 1))}>+</span>
        </div>

        <div className="split-actions">
          <div className="wst-button split-btn" onClick={onCancel}>{tr('ui_cancel', 'Cancel')}</div>
          <div className="wst-button primary split-btn confirm" onClick={handleConfirm}>{tr('ui_split', 'Split')}</div>
        </div>
      </div>
    </>
  );
}
