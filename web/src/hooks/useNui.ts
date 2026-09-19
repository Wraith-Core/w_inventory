import { useEffect, useRef } from 'react';
import { InventoryAction } from './useInventory';
import { setImagePath } from '../utils/nui';
import { installLocale, tr } from '../i18n';

export default function useNui(
  dispatch: React.Dispatch<InventoryAction>,
  setVisible: (v: boolean) => void,
  addToast: (msg: string, type?: string) => void,
  hotbar: any,
  itemsDbRef: React.MutableRefObject<Record<string, any>>
) {
  const tradeTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    function handler(event: MessageEvent) {
      const msg = event.data;
      if (!msg || !msg.action) return;

      // w_inventory Lua sends: { action = 'xxx', data = { ... } }
      // The actual payload is in msg.data (except for a few messages)
      const payload = msg.data;

      switch (msg.action) {
        case 'init': {
          // { locale: 'ar' | 'en', dir: 'rtl' | 'ltr', strings: { ui_*: string } } - sent at load
          // and again on every live language switch
          if (payload.strings) {
            installLocale(payload.strings, payload.locale, payload.dir);
          }
          if (payload.items) {
            (window as any).__oxItems = payload.items;
            itemsDbRef.current = payload.items;
            // a language switch re-sends the catalogue alone: the slots already on
            // screen carry a baked label, re-pick it from the new dictionary
            if (!payload.leftInventory) dispatch({ type: 'RELABEL_ITEMS' });
          }
          if (payload.imagepath) {
            setImagePath(payload.imagepath);
          }
          if (payload.leftInventory) {
            dispatch({
              type: 'SETUP_INVENTORY',
              leftInventory: payload.leftInventory,
              wornClothingCategories: payload.wornClothingCategories,
              removedClothingCategories: payload.removedClothingCategories,
            });
          }
          break;
        }

        case 'setupInventory': {
          dispatch({
            type: 'SETUP_INVENTORY',
            leftInventory: payload.leftInventory,
            rightInventory: payload.rightInventory,
            wornClothingCategories: payload.wornClothingCategories,
            removedClothingCategories: payload.removedClothingCategories,
          });
          setVisible(true);
          break;
        }

        case 'setInventoryVisible':
          setVisible(payload);
          break;

        case 'closeInventory':
          setVisible(false);
          dispatch({ type: 'RESET' });
          break;

        case 'refreshSlots':
          dispatch({
            type: 'REFRESH_SLOTS',
            items: payload.items,
            itemCount: payload.itemCount,
            weightData: payload.weightData,
            slotsData: payload.slotsData,
          });
          break;

        case 'toggleHotbar':
          if (hotbar?.showHotbar) hotbar.showHotbar();
          break;

        // Currency updates send cash/gold at the top level, not inside data.
        case 'updateCurrency':
          dispatch({ type: 'SET_CURRENCY', cash: msg.cash, gold: msg.gold });
          break;

        case 'displayMetadata':
          dispatch({ type: 'SET_ADDITIONAL_METADATA', metadata: payload });
          break;

        case 'setWornClothingCategories':
          dispatch({
            type: 'SET_WORN_CLOTHING',
            wornClothingCategories: payload.wornClothingCategories,
            removedClothingCategories: payload.removedClothingCategories,
          });
          break;

        case 'itemNotify': {
          if (payload && Array.isArray(payload)) {
            const [slotData, text, count] = payload;
            const label = slotData?.label || slotData?.name || '';
            const localText = tr(text, text);
            const toastMsg = count ? `${localText} ${count}x ${label}` : `${localText} ${label}`;
            addToast(toastMsg.trim(), text === 'ui_removed' ? 'error' : 'info');
          }
          break;
        }

        case 'show':
          setVisible(true);
          break;

        case 'hide':
          setVisible(false);
          dispatch({ type: 'RESET' });
          break;

        case 'setItems':
          dispatch({
            type: 'SETUP_INVENTORY',
            leftInventory: {
              items: payload?.items || payload,
              maxWeight: payload?.maxWeight,
              slots: payload?.items?.length || 50,
              id: 'player',
              type: 'player',
            },
          });
          break;

        case 'setContainerItems':
          dispatch({ type: 'SET_CONTAINER_ITEMS', containerItemId: payload.containerItemId, items: payload.items });
          break;

        case 'toast':
          addToast(payload.message, payload.type);
          break;

        case 'loadHotbar':
          try {
            const parsed = JSON.parse(payload.slotsJson);
            if (hotbar?.loadSlots) hotbar.loadSlots(parsed);
          } catch (_) {}
          break;

        case 'tradeRequest':
          dispatch({ type: 'TRADE_REQUEST', fromSrc: payload.fromSrc, fromName: payload.fromName, tradeId: payload.tradeId });
          break;
        case 'tradeAccepted':
          dispatch({ type: 'TRADE_OPEN', tradeId: payload.tradeId, partnerName: payload.partnerName });
          break;
        case 'tradeCancelled':
          dispatch({ type: 'TRADE_CANCELLED' });
          addToast(payload.reason || tr('ui_trade_cancelled', 'Trade cancelled.'), 'info');
          break;
        case 'tradeUpdate':
          dispatch({ type: 'TRADE_UPDATE_THEIR', items: payload.items });
          break;
        case 'tradeConfirmReset':
          dispatch({ type: 'TRADE_CONFIRM_RESET' });
          break;
        case 'tradePartnerConfirmed':
          dispatch({ type: 'TRADE_PARTNER_CONFIRMED' });
          addToast(tr('ui_trade_partner_confirmed', 'The other player confirmed the trade.'), 'info');
          break;
        case 'tradeComplete':
          dispatch({ type: 'TRADE_COMPLETING' });
          if (tradeTimerRef.current) clearTimeout(tradeTimerRef.current);
          tradeTimerRef.current = setTimeout(() => {
            dispatch({ type: 'TRADE_COMPLETE' });
            addToast(tr('ui_trade_complete', 'Trade completed successfully!'), 'success');
            tradeTimerRef.current = null;
          }, 2500);
          break;
      }
    }

    window.addEventListener('message', handler);
    return () => {
      window.removeEventListener('message', handler);
      if (tradeTimerRef.current) clearTimeout(tradeTimerRef.current);
    };
  }, [dispatch, setVisible, addToast, hotbar, itemsDbRef]);
}
