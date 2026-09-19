import { useState, useCallback, useRef, useEffect } from 'react';
import { useDroppable } from '@dnd-kit/core';
import { iconUrl, placeholderUrl } from '../utils/nui';
import { rarity, SVG_X } from '../utils/items';
import { tr, trf } from '../i18n';
import Frame from './Frame';

const SVG_CHECK = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>;
const SVG_HANDSHAKE = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M16.48 7.58c-.28.28-.67.28-.95 0L12.7 4.76a.67.67 0 0 0-.95 0L9.53 6.97l3.3 3.3a2 2 0 0 1 0 2.83l-.71.71a2 2 0 0 1-2.83 0L6.97 11.5l-1.2 1.2a.67.67 0 0 0 0 .96l2.82 2.82c.28.28.28.67 0 .95L7.64 18.4a.67.67 0 0 0 0 .95l1.41 1.41c.28.28.67.28.95 0l.95-.95c.28-.28.67-.28.95 0l.95.95c.28.28.67.28.95 0l1.41-1.41a.67.67 0 0 0 0-.95l-.95-.95a.67.67 0 0 1 0-.95l1.2-1.2 2.3 2.3c.79.79 2.05.79 2.84 0s.79-2.05 0-2.84L16.48 7.58z"/><path d="M21.71 7.13l-3.54-3.54a1 1 0 0 0-.7-.29h-2.83L18.17 6.83l3.54 3.54V7.83a1 1 0 0 0-.29-.7zM2.29 7.13a1 1 0 0 0-.29.7v2.54L5.54 6.83 9.07 3.3H6.24a1 1 0 0 0-.7.29L2.29 7.13z" opacity=".45"/></svg>;

function TradeSlot({ item, onClick, removable }: { item: any; onClick?: () => void; removable?: boolean }) {
  if (!item) return <div className="trade-slot trade-slot-empty" />;
  const r = rarity(item);
  return (
    <div className={`trade-slot trade-slot-filled ${r}`} onClick={onClick}>
      <img src={iconUrl(item.name)} onError={(e: any) => { e.target.src = placeholderUrl(); }} draggable={false} alt="" />
      {item.count > 1 && <div className="trade-slot-count">{item.count}</div>}
      {removable && <div className="trade-slot-remove">{SVG_X}</div>}
    </div>
  );
}

function TradeDropZone({ children, myConfirmed }: { children: React.ReactNode; myConfirmed: boolean }) {
  const { setNodeRef, isOver } = useDroppable({
    id: 'drop:trade-offer',
    data: { type: 'trade-offer' },
    disabled: myConfirmed,
  });
  return (
    <div ref={setNodeRef} className={`trade-col-drop${isOver ? ' trade-drop-hover' : ''}`}>
      {children}
    </div>
  );
}

export function TradeRequest({ request, onAccept, onDecline }: { request: any; onAccept: () => void; onDecline: () => void }) {
  if (!request) return null;
  return (
    <div className="trade-request-overlay">
      <div className="trade-request-card">
        <Frame px={11} opacity={0.5} />
        <div className="trade-request-icon">{SVG_HANDSHAKE}</div>
        <div className="trade-request-title">{tr('ui_trade_request', 'Trade request')}</div>
        <div className="trade-request-name">{request.fromName}</div>
        <div className="trade-request-sub">{tr('ui_trade_wants', 'wants to trade with you')}</div>
        <div className="trade-request-actions">
          <button className="trade-req-btn decline" onClick={onDecline}>{tr('ui_decline', 'Decline')}</button>
          <button className="trade-req-btn accept" onClick={onAccept}>{tr('ui_accept', 'Accept')}</button>
        </div>
      </div>
    </div>
  );
}

interface TradePanelProps {
  tradeOpen: boolean;
  tradePartner: string;
  myOffer: any[];
  theirOffer: any[];
  myConfirmed: boolean;
  theirConfirmed: boolean;
  tradeCompleting: boolean;
  onRemoveFromOffer: (id: string) => void;
  onConfirm: () => void;
  onCancel: () => void;
}

export default function TradePanel({ tradeOpen, tradePartner, myOffer, theirOffer, myConfirmed, theirConfirmed, tradeCompleting, onRemoveFromOffer, onConfirm, onCancel }: TradePanelProps) {
  const [pos, setPos] = useState({ x: 0, y: 0 });
  const dragging = useRef(false);
  const offset = useRef({ x: 0, y: 0 });

  const onMouseDown = useCallback((e: React.MouseEvent) => {
    if ((e.target as HTMLElement).closest('.trade-close') || (e.target as HTMLElement).closest('.trade-btn') || (e.target as HTMLElement).closest('.trade-slot') || (e.target as HTMLElement).closest('button')) return;
    dragging.current = true;
    offset.current = { x: e.clientX - (pos.x ?? 0), y: e.clientY - (pos.y ?? 0) };
    e.preventDefault();
  }, [pos]);

  useEffect(() => {
    function onMove(e: MouseEvent) { if (!dragging.current) return; setPos({ x: e.clientX - offset.current.x, y: e.clientY - offset.current.y }); }
    function onUp() { dragging.current = false; }
    document.addEventListener('mousemove', onMove);
    document.addEventListener('mouseup', onUp);
    return () => { document.removeEventListener('mousemove', onMove); document.removeEventListener('mouseup', onUp); };
  }, []);

  if (!tradeOpen) return null;

  const mySlots = [];
  for (let i = 0; i < 8; i++) {
    const item = myOffer[i] || null;
    mySlots.push(<TradeSlot key={`my-${i}`} item={item} removable={!!item && !myConfirmed} onClick={item && !myConfirmed ? () => onRemoveFromOffer(item.id) : undefined} />);
  }
  const theirSlots = [];
  for (let i = 0; i < 8; i++) {
    const item = theirOffer[i] || null;
    theirSlots.push(<TradeSlot key={`their-${i}`} item={item} />);
  }

  const useCustomPos = pos.x !== 0 || pos.y !== 0;
  const style: React.CSSProperties = useCustomPos ? { position: 'fixed', left: pos.x, top: pos.y, transform: 'none', right: 'auto' } : {};

  return (
    <div id="trade-panel" style={style} onMouseDown={onMouseDown}>
      <Frame px={13} opacity={0.5} />
      <div className="trade-header trade-drag-handle">
        <div className="trade-header-icon">{SVG_HANDSHAKE}</div>
        <div className="trade-header-text">
          <div className="trade-title">{tr('ui_trade', 'Trade')}</div>
          <div className="trade-partner">{trf('ui_trade_with', 'With %s', tradePartner)}</div>
        </div>
        <div className="trade-drag-hint"><svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"/></svg></div>
        <div className="trade-close" onClick={onCancel}>{SVG_X}</div>
      </div>
      <div className="trade-columns">
        <div className={`trade-col${myConfirmed ? ' trade-confirmed' : ''}`}>
          <div className="trade-col-label">{tr('ui_your_offer', 'Your offer')}</div>
          <TradeDropZone myConfirmed={myConfirmed}>
            <div className="trade-col-grid">{mySlots}</div>
            {!myConfirmed && myOffer.length === 0 && <div className="trade-drop-hint">{tr('ui_drag_items_here', 'Drag items here')}</div>}
          </TradeDropZone>
        </div>
        <div className="trade-divider"><div className="trade-arrows">{SVG_HANDSHAKE}</div></div>
        <div className={`trade-col${theirConfirmed ? ' trade-confirmed' : ''}`}>
          <div className="trade-col-label">{tr('ui_their_offer', 'Their offer')}</div>
          <div className="trade-col-grid">{theirSlots}</div>
        </div>
      </div>
      {!tradeCompleting && (
        <div className="trade-footer">
          <button className="trade-btn cancel" onClick={onCancel}>{tr('ui_cancel', 'Cancel')}</button>
          <button className={`trade-btn confirm${myConfirmed ? ' confirmed' : ''}`} onClick={onConfirm} disabled={myConfirmed}>
            {myConfirmed ? <>{SVG_CHECK} {tr('ui_confirmed', 'Confirmed')}</> : tr('ui_confirm_trade', 'Confirm trade')}
          </button>
        </div>
      )}
      {tradeCompleting && (
        <div className="trade-completing-overlay">
          <div className="trade-completing-icon">{SVG_HANDSHAKE}</div>
          <div className="trade-completing-text">{tr('ui_completing_trade', 'Completing trade')}</div>
          <div className="trade-completing-bar-track"><div className="trade-completing-bar-fill" /></div>
          <div className="trade-completing-sub">{tr('ui_exchanging_items', 'Exchanging items...')}</div>
        </div>
      )}
    </div>
  );
}
