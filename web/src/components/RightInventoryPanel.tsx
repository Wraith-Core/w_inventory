import { useMemo, useState, useCallback, useRef, useEffect } from 'react';
import InventoryGrid from './InventoryGrid';
import { N, SVG_X, SVG_BAG, SVG_CASH, SVG_GOLD, fmtWeight } from '../utils/items';
import { InventoryItem, RightInventoryMeta } from '../typings';
import { formatCompact } from '../utils/formatNumber';
import { tr, trf } from '../i18n';
import Frame from './Frame';
import usePanelPosition from '../hooks/usePanelPosition';

const RIGHT_POS_KEY = 'w_inv_right_pos';

/* The badge's icon by the panel's kind - shop/crafting/storage */
const SVG_SHOP = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2a5 5 0 0 0-5 5H4l-1 13a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2L20 7h-3a5 5 0 0 0-5-5zm0 2a3 3 0 0 1 3 3H9a3 3 0 0 1 3-3zm-3 7a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm6 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z" /></svg>;
const SVG_CRAFT = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M13.7 8.3 6.4 15.6l-1.4-1.4a2 2 0 0 0-2.8 2.8l4.8 4.8a2 2 0 0 0 2.8-2.8l-1.4-1.4 7.3-7.3-2-2zM22 5.6 18.4 2l-2.1 2.1-1-1a1 1 0 0 0-1.5 0l-1.6 1.6a1 1 0 0 0 0 1.4l5.7 5.7a1 1 0 0 0 1.4 0l1.6-1.6a1 1 0 0 0 0-1.5l-1-1L22 5.6z" /></svg>;

function loadRightPos(): { x: number; y: number } | null {
  try {
    const raw = localStorage.getItem(RIGHT_POS_KEY);
    if (raw) {
      const p = JSON.parse(raw);
      if (typeof p.x === 'number' && typeof p.y === 'number') return p;
    }
  } catch {}
  return null;
}

interface RightInventoryPanelProps {
  rightInventory: RightInventoryMeta | null;
  rightGrid: (InventoryItem | null)[];
  selected: number | null;
  selectedPanel: string;
  onSelect: (idx: number, panel: string, e: React.MouseEvent) => void;
  onContextMenu: (e: React.MouseEvent, idx: number, panel: string) => void;
  onDoubleClick: (idx: number, item: InventoryItem) => void;
  onMouseOver: (idx: number, panel: string) => void;
  onMouseLeave: () => void;
  playerCash: number;
  playerGold: number;
  shopPaymentCurrency: 'cash' | 'gold';
  onSetPaymentCurrency: (c: 'cash' | 'gold') => void;
  itemAmount: number;
  onSetItemAmount: (n: number) => void;
}

export default function RightInventoryPanel({
  rightInventory,
  rightGrid,
  selected,
  selectedPanel,
  onSelect,
  onContextMenu,
  onDoubleClick,
  onMouseOver,
  onMouseLeave,
  playerCash,
  playerGold,
  shopPaymentCurrency,
  onSetPaymentCurrency,
  itemAmount,
  onSetItemAmount,
}: RightInventoryPanelProps) {
  const [rightPos, setRightPos] = useState<{ x: number; y: number } | null>(loadRightPos);
  const [rpAnimating, setRpAnimating] = useState(false);
  const rightRef = useRef<HTMLDivElement>(null);
  const dragRef = useRef<{ startX: number; startY: number; origX: number; origY: number } | null>(null);

  const isOpen = !!(rightInventory && rightInventory.type !== 'newdrop');
  const fittedRightPos = usePanelPosition(rightRef, rightPos, isOpen);
  useEffect(() => {
    if (isOpen) {
      setRpAnimating(false);
      requestAnimationFrame(() => {
        requestAnimationFrame(() => setRpAnimating(true));
      });
    } else {
      setRpAnimating(false);
    }
  }, [isOpen]);

  const handleDragStart = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    const el = rightRef.current;
    if (!el) return;
    const rect = el.getBoundingClientRect();
    dragRef.current = { startX: e.clientX, startY: e.clientY, origX: rect.left, origY: rect.top };

    const onMove = (ev: MouseEvent) => {
      if (!dragRef.current) return;
      setRightPos({
        x: dragRef.current.origX + (ev.clientX - dragRef.current.startX),
        y: dragRef.current.origY + (ev.clientY - dragRef.current.startY),
      });
    };

    const onUp = () => {
      document.removeEventListener('mousemove', onMove);
      document.removeEventListener('mouseup', onUp);
      setRightPos((cur) => {
        if (cur) { try { localStorage.setItem(RIGHT_POS_KEY, JSON.stringify(cur)); } catch {} }
        return cur;
      });
      dragRef.current = null;
    };

    document.addEventListener('mousemove', onMove);
    document.addEventListener('mouseup', onUp);
  }, []);

  const { totalWeight, itemCount } = useMemo(() => {
    let w = 0, n = 0;
    for (const it of rightGrid) {
      if (!it) continue;
      w += N(it.weight) * it.count;
      n++;
    }
    return { totalWeight: w, itemCount: n };
  }, [rightGrid]);

  if (!rightInventory || rightInventory.type === 'newdrop') return null;

  const isShop = rightInventory.type === 'shop';
  const isCrafting = rightInventory.type === 'crafting';

  const posStyle: React.CSSProperties = fittedRightPos
    ? {
        position: 'fixed',
        left: `${fittedRightPos.x}px`,
        top: `${fittedRightPos.y}px`,
        right: 'auto',
        opacity: rpAnimating ? 1 : 0,
        transform: rpAnimating ? 'none' : 'scale(.8)',
      }
    : {
        opacity: rpAnimating ? 1 : 0,
        transform: rpAnimating ? 'translateY(-50%)' : 'translateY(-50%) scale(.8)',
      };

  return (
    <div id="right-inventory-panel" className="wst-panel" ref={rightRef} style={{ display: 'flex', ...posStyle }}>
      <Frame px={13} opacity={0.5} />
      <div className="wst-header rp-header" onMouseDown={handleDragStart} style={{ cursor: 'grab' }}>
        <div className="inv-badge">{isShop ? SVG_SHOP : isCrafting ? SVG_CRAFT : SVG_BAG}</div>
        <div className="rp-title-area">
          <div className="wst-title rp-title">{rightInventory.label || tr(`ui_inv_${rightInventory.type}`, rightInventory.type)}</div>
          <div className="wst-sub rp-subtitle">
            {isShop ? tr('ui_shop_drag_hint', 'Drag items to your inventory to purchase') :
             isCrafting ? tr('ui_crafting_drag_hint', 'Drag items to your inventory to craft') :
             trf('ui_item_count', '%s item(s)', itemCount)}
          </div>
        </div>
      </div>

      {isShop && (
        <div className="rp-shop-controls">
          <div className="rp-currency-toggle">
            <button
              type="button"
              className={`wst-tab rp-currency-btn ${shopPaymentCurrency === 'cash' ? 'active' : ''}`}
              onClick={() => onSetPaymentCurrency('cash')}
            >
              <span className="rp-currency-icon">{SVG_CASH}</span>
              <span>{formatCompact(playerCash)}</span>
            </button>
            <button
              type="button"
              className={`wst-tab rp-currency-btn gold ${shopPaymentCurrency === 'gold' ? 'active' : ''}`}
              onClick={() => onSetPaymentCurrency('gold')}
            >
              <span className="rp-currency-icon gold">{SVG_GOLD}</span>
              <span>{formatCompact(playerGold)}</span>
            </button>
          </div>
          <div className="rp-amount-control">
            <label className="rp-amount-label">{tr('ui_quantity', 'Quantity')}</label>
            <input
              type="number"
              className="wst-input rp-amount-input"
              value={itemAmount || ''}
              min={0}
              onChange={(e) => onSetItemAmount(parseInt(e.target.value) || 0)}
              placeholder="0"
            />
          </div>
        </div>
      )}

      {!isShop && !isCrafting && (
        <div className="rp-amount-row">
          <label className="rp-amount-label">{tr('ui_quantity', 'Quantity')}</label>
          <input
            type="number"
            className="wst-input rp-amount-input"
            value={itemAmount || ''}
            min={0}
            onChange={(e) => onSetItemAmount(parseInt(e.target.value) || 0)}
            placeholder="0"
          />
        </div>
      )}

      {!isShop && rightInventory.maxWeight != null && (
        <div className="rp-weight-bar">
          <span className="rp-weight-text">{fmtWeight(totalWeight)} / {fmtWeight(rightInventory.maxWeight)}</span>
          <div className="rp-bar">
            <div
              className="rp-bar-fill"
              style={{ width: `${Math.min(100, (totalWeight / (rightInventory.maxWeight || 1)) * 100)}%` }}
            />
          </div>
        </div>
      )}

      <InventoryGrid
        grid={rightGrid}
        category="all"
        search=""
        selected={selected}
        panel="right"
        selectedPanel={selectedPanel}
        inventorySlots={rightInventory.slots}
        onSelect={onSelect}
        onContextMenu={onContextMenu}
        onDoubleClick={onDoubleClick}
        onMouseOver={onMouseOver}
        onMouseLeave={onMouseLeave}
      />
    </div>
  );
}
