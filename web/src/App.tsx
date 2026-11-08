import { useState, useCallback, useRef, useEffect, useMemo } from 'react';
import { DndContext, DragOverlay, MouseSensor, useSensor, useSensors, pointerWithin } from '@dnd-kit/core';
import useInventory from './hooks/useInventory';
import useNui from './hooks/useNui';
import useSound from './hooks/useSound';
import { useToast } from './hooks/useToast';
import usePanelPosition from './hooks/usePanelPosition';
import { remPx, CONTAINER_W_REM, DETAIL_W_REM, PANEL_GAP_REM, loadPanelPos, savePanelPos } from './utils/layout';
import { useHotbar } from './hooks/useHotbar';
import { fetchNui } from './utils/nui';
import { N } from './utils/items';
import { InventoryItem, ItemData } from './typings';
import InventoryGrid from './components/InventoryGrid';
import DetailPanel from './components/DetailPanel';
import ContainerPanel from './components/ContainerPanel';
import RightInventoryPanel from './components/RightInventoryPanel';
import ContextMenu from './components/ContextMenu';
import Tooltip from './components/Tooltip';
import InspectOverlay from './components/InspectOverlay';
import CategoryBar from './components/CategoryBar';
import WeightBar, { WeightProgress } from './components/WeightBar';
import ToastContainer from './components/Toast';
import DragGhost from './components/DragGhost';
import DropZone from './components/DropZone';
import Toolbar from './components/Toolbar';
import SplitDialog from './components/SplitDialog';
import HotBar from './components/HotBar';
import TradePanel, { TradeRequest } from './components/TradePanel';
import AmmoPicker, { AmmoPickerData } from './components/AmmoPicker';
import { SVG_X, SVG_SATCHEL, SVG_CASH, SVG_GOLD } from './utils/items';
import Glyph from './components/Glyph';
import { isEnvBrowser } from './utils/misc';
import { formatCompact } from './utils/formatNumber';
import { tr, trf } from './i18n';

function parseDropId(id: string | undefined | null) {
  if (!id || typeof id !== 'string') return null;
  if (id === 'ground-drop') return { type: 'ground' as const };
  if (id === 'drop:trade-offer') return { type: 'trade-offer' as const };
  if (id.startsWith('drop:filled:')) {
    const parts = id.split(':');
    return { type: 'filled' as const, panel: parts[2], idx: parseInt(parts[3]) };
  }
  if (id.startsWith('drop:empty:')) {
    const parts = id.split(':');
    return { type: 'empty' as const, panel: parts[2], gridIndex: parseInt(parts[3]) };
  }
  return null;
}

function calcGridWeight(grid: (InventoryItem | null)[]) {
  let t = 0;
  for (const it of grid) {
    if (!it) continue;
    t += N(it.weight) * it.count;
    if (it.isContainer && it.containerContentWeight) t += N(it.containerContentWeight);
  }
  return t;
}

export default function App() {
  const [visible, setVisible] = useState(false);
  const [animating, setAnimating] = useState(false);
  const { state, dispatch, getGrid, getItemsList } = useInventory();
  const { toasts, addToast } = useToast();
  const hotbar = useHotbar();
  const playSound = useSound();
  const itemsDbRef = useRef<Record<string, ItemData | undefined>>({});

  const busyFetch = useCallback(<T,>(eventName: string, data?: unknown): Promise<T> => {
    dispatch({ type: 'SET_BUSY', busy: true });
    return fetchNui<T>(eventName, data).then((res) => {
      // Make sure the busy state is cleared after the reply arrives
      setTimeout(() => dispatch({ type: 'SET_BUSY', busy: false }), 100);
      return res;
    }).catch(() => {
      dispatch({ type: 'SET_BUSY', busy: false });
      return undefined as any;
    });
  }, [dispatch]);

  const [ctx, setCtx] = useState({ visible: false, x: 0, y: 0, idx: null as number | null, panel: 'main' });
  const [tooltip, setTooltip] = useState<{ item: InventoryItem | null; rect: DOMRect | null }>({ item: null, rect: null });
  const [split, setSplit] = useState({ visible: false, idx: null as number | null, panel: 'main' });
  const [ammoPicker, setAmmoPicker] = useState<AmmoPickerData | null>(null);
  const [ammoPickerBusy, setAmmoPickerBusy] = useState(false);
  const [dragItem, setDragItem] = useState<InventoryItem | null>(null);
  const [isDragging, setIsDragging] = useState(false);
  const lastUsedRef = useRef<Record<string, number>>({});
  const busyTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    if (state.isBusy) {
      if (busyTimerRef.current) clearTimeout(busyTimerRef.current);
      busyTimerRef.current = setTimeout(() => {
        dispatch({ type: 'SET_BUSY', busy: false });
        busyTimerRef.current = null;
      }, 5000);
    } else {
      if (busyTimerRef.current) {
        clearTimeout(busyTimerRef.current);
        busyTimerRef.current = null;
      }
    }
  }, [state.isBusy, dispatch]);

  const wrapperRef = useRef<HTMLDivElement>(null);

  const PANEL_POS_KEY = 'w_inv_panel_pos';
  // saved in design px (ui-scale), so it lands at the same place on every resolution
  const loadSavedPos = useCallback((): { x: number; y: number } | null => loadPanelPos(PANEL_POS_KEY), []);

  const [panelPos, setPanelPos] = useState<{ x: number; y: number } | null>(loadSavedPos);
  const attachedWidth = (state.containerOpen !== null ? CONTAINER_W_REM + PANEL_GAP_REM : 0) + (state.selected !== null ? DETAIL_W_REM + PANEL_GAP_REM : 0);
  const fittedPanelPos = usePanelPosition(wrapperRef, panelPos, visible, remPx(attachedWidth));
  const panelDragRef = useRef<{ startX: number; startY: number; origX: number; origY: number } | null>(null);

  const handlePanelDragStart = useCallback((e: React.MouseEvent) => {
    if ((e.target as HTMLElement).closest('#inv-close-btn')) return;
    e.preventDefault();
    const wrapper = wrapperRef.current;
    if (!wrapper) return;
    const rect = wrapper.getBoundingClientRect();
    panelDragRef.current = {
      startX: e.clientX,
      startY: e.clientY,
      origX: rect.left,
      origY: rect.top,
    };

    const onMove = (ev: MouseEvent) => {
      if (!panelDragRef.current) return;
      const dx = ev.clientX - panelDragRef.current.startX;
      const dy = ev.clientY - panelDragRef.current.startY;
      const nx = panelDragRef.current.origX + dx;
      const ny = panelDragRef.current.origY + dy;
      setPanelPos({ x: nx, y: ny });
    };

    const onUp = () => {
      document.removeEventListener('mousemove', onMove);
      document.removeEventListener('mouseup', onUp);
      setPanelPos((cur) => {
        if (cur) {
          savePanelPos(PANEL_POS_KEY, cur);
        }
        return cur;
      });
      panelDragRef.current = null;
    };

    document.addEventListener('mousemove', onMove);
    document.addEventListener('mouseup', onUp);
  }, []);

  const sensors = useSensors(
    useSensor(MouseSensor, { activationConstraint: { distance: 5 } }),
  );

  const itemCount = useMemo(() => {
    let n = 0;
    for (const it of state.grid) if (it) n++;
    return n;
  }, [state.grid]);

  const closeTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    return () => {
      if (closeTimerRef.current) clearTimeout(closeTimerRef.current);
      if (busyTimerRef.current) clearTimeout(busyTimerRef.current);
    };
  }, []);

  const stableSetVisible = useCallback((v: boolean) => {
    if (v) {
      if (closeTimerRef.current) {
        clearTimeout(closeTimerRef.current);
        closeTimerRef.current = null;
      }
      setVisible(true);
      setAnimating(false);
      playSound('open');
      requestAnimationFrame(() => {
        requestAnimationFrame(() => setAnimating(true));
      });
    } else {
      setAnimating(false);
      playSound('close');
      if (closeTimerRef.current) {
        clearTimeout(closeTimerRef.current);
      }
      closeTimerRef.current = setTimeout(() => {
        setVisible(false);
        closeTimerRef.current = null;
      }, 400);
    }
  }, [playSound]);

  useNui(dispatch, stableSetVisible, addToast, hotbar, itemsDbRef);

  useEffect(() => {
    const prevent = (e: DragEvent) => e.preventDefault();
    window.addEventListener('dragstart', prevent);
    return () => window.removeEventListener('dragstart', prevent);
  }, []);

  useEffect(() => {
    if (!isEnvBrowser()) {
      fetchNui('uiLoaded', {});
    }
  }, []);

  useEffect(() => {
    hotbar.syncWithGrid(state.grid);
  }, [state.grid, hotbar.syncWithGrid]);

  useEffect(() => {
    function handler(event: MessageEvent) {
      const data = event.data;
      if (!data) return;
      if (data.action === 'showHotbar') hotbar.showHotbar();
      if (data.action === 'setHotbarVisible') hotbar.setVisible(data.visible === true);
      if (data.action === 'useHotbarSlot') {
        const si = data.slot;
        if (si >= 0 && si < 5) {
          hotbar.useSlot(si);
          hotbar.showHotbar();
        }
      }
      if (data.action === 'openAmmoPicker' && data.data) {
        setCtx((current) => ({ ...current, visible: false }));
        setTooltip({ item: null, rect: null });
        setAmmoPickerBusy(false);
        setAmmoPicker(data.data as AmmoPickerData);
      }
    }
    window.addEventListener('message', handler);
    return () => window.removeEventListener('message', handler);
  }, [hotbar.setVisible, hotbar.showHotbar, hotbar.useSlot]);

  function checkUseCooldown(itemName: string) {
    const now = Date.now();
    const last = lastUsedRef.current[itemName] || 0;
    if (now - last < 2000) {
      addToast(tr('ui_item_cooldown', 'This item is on cooldown'), 'error');
      playSound('error');
      return false;
    }
    lastUsedRef.current[itemName] = now;
    return true;
  }

  function handleDragStart(event: any) {
    if (state.isBusy) {
      event.cancel?.();
      return;
    }
    const data = event.active.data.current;
    if (data?.item) {
      setDragItem(data.item);
      setIsDragging(true);
      setTooltip({ item: null, rect: null });
      setCtx((c) => ({ ...c, visible: false }));
      playSound('pickup');
    }
  }

  function handleDragEnd(event: any) {
    const { active, over } = event;
    setDragItem(null);
    setIsDragging(false);

    if (!over || !active) return;
    if (state.isBusy) return;

    const src = active.data.current;
    if (!src?.item) return;

    const dst = parseDropId(over.id as string);
    if (!dst) return;

    if (dst.type === 'trade-offer') {
      if (!state.tradeOpen || state.myConfirmed) return;
      if (src.panel !== 'main') return;
      // Stop the shop's elements being added to a trade
      if (state.rightInventory?.type === 'shop' || state.rightInventory?.type === 'crafting') {
        if (src.panel === 'right') return;
      }
      handleTradeAddItem(src.item);
      playSound('drop');
      return;
    }

    if (dst.type === 'ground') {
      // Dropping on the ground is from the player's bag only. What is inside a bag lying there or a chest
      // or a shop is not dropped again - the server refuses it too, and this guard stops
      // the pointless call and keeps the interface honest.
      if (src.panel !== 'main') {
        addToast(tr('ui_cannot_place_here', 'You cannot place items here'), 'error');
        playSound('error');
        return;
      }

      busyFetch('swapItems', {
        fromSlot: src.item.slot,
        toSlot: 1,
        fromType: 'player',
        toType: 'newdrop',
        count: state.itemAmount > 0 ? state.itemAmount : src.item.count,
      });
      playSound('drop');
      return;
    }

    if (dst.type === 'filled' || dst.type === 'empty') {
      const dstIdx = dst.type === 'filled' ? dst.idx! : (dst as any).gridIndex;
      const srcPanel = src.panel;
      const dstPanel = dst.type === 'filled' ? dst.panel : (dst as any).panel;

      const dstItem = dst.type === 'filled' ? over.data.current?.item : null;

      let resolvedToSlot: number;
      if (dstItem) {
        resolvedToSlot = dstItem.slot;
      } else {
        resolvedToSlot = dstIdx + 1;
      }

      if (src.item.slot === resolvedToSlot && srcPanel === dstPanel) return;

      if (srcPanel === dstPanel) {
        // Stop the elements being moved inside the shop or the crafting (they are fixed in place)
        if (srcPanel === 'right' && (state.rightInventory?.type === 'shop' || state.rightInventory?.type === 'crafting')) {
          return;
        }
        const fromType = srcPanel === 'right' ? (state.rightInventory?.type || 'player') : 'player';
        busyFetch('swapItems', {
          fromSlot: src.item.slot,
          toSlot: resolvedToSlot,
          fromType: fromType,
          toType: fromType,
          count: state.itemAmount > 0 ? state.itemAmount : src.item.count,
        });
      } else {
        const fromType = srcPanel === 'right' ? (state.rightInventory?.type || 'player') : 'player';
        const toType = dstPanel === 'right' ? (state.rightInventory?.type || 'player') : 'player';
        const crossToSlot = resolvedToSlot;

        // Stop the elements being dragged into the shop or the crafting (read only)
        if ((state.rightInventory?.type === 'shop' || state.rightInventory?.type === 'crafting') && dstPanel === 'right' && srcPanel === 'main') {
          addToast(tr('ui_cannot_place_here', 'You cannot place items here'), 'error');
          playSound('error');
          return;
        }

        if (state.rightInventory?.type === 'shop' && srcPanel === 'right') {
          busyFetch('buyItem', {
            fromSlot: src.item.slot,
            toSlot: crossToSlot,
            fromType: fromType,
            toType: toType,
            count: state.itemAmount > 0 ? state.itemAmount : 1,
            paymentCurrency: state.shopPaymentCurrency,
          });
        } else if (state.rightInventory?.type === 'crafting' && srcPanel === 'right') {
          busyFetch('craftItem', {
            fromSlot: src.item.slot,
            toSlot: crossToSlot,
            fromType: fromType,
            toType: toType,
            count: state.itemAmount > 0 ? state.itemAmount : 1,
          });
        } else {
          const count = state.itemAmount > 0 ? state.itemAmount : src.item.count;
          busyFetch('swapItems', {
            fromSlot: src.item.slot,
            toSlot: crossToSlot,
            fromType: fromType,
            toType: toType,
            count: count,
          });
        }
      }
      playSound('drop');
      return;
    }
  }

  const handleClose = useCallback(() => {
    setCtx((c) => ({ ...c, visible: false }));
    setTooltip({ item: null, rect: null });
    setSplit({ visible: false, idx: null, panel: 'main' });
    setAmmoPicker(null);
    setAmmoPickerBusy(false);
    setDragItem(null);
    setIsDragging(false);
    if (state.tradeOpen) {
      fetchNui('cancelTrade', { tradeId: state.tradeId });
    }
    dispatch({ type: 'RESET' });
    fetchNui('exit');
    stableSetVisible(false);
  }, [dispatch, stableSetVisible, state.tradeOpen, state.tradeId]);

  const handleSelect = useCallback((idx: number, panel: string, event: React.MouseEvent) => {
    if (isDragging) return;
    setCtx((c) => ({ ...c, visible: false }));
    dispatch({ type: 'SELECT', index: idx, panel });
  }, [dispatch, isDragging]);

  const handleContextMenu = useCallback((e: React.MouseEvent, idx: number, panel: string) => {
    if (isDragging || state.isBusy) return;
    e.preventDefault();
    e.stopPropagation();
    dispatch({ type: 'SELECT', index: idx, panel });
    setCtx({ visible: true, x: e.clientX, y: e.clientY, idx, panel });
  }, [dispatch, isDragging, state.isBusy]);

  const handleDoubleClick = useCallback((idx: number, item: InventoryItem) => {
    if (state.isBusy) return;
    if (item.isContainer) {
      dispatch({ type: 'OPEN_CONTAINER', index: idx });
    } else {
      if (!checkUseCooldown(item.name)) return;
      fetchNui('useItem', item.slot);
    }
  }, [dispatch, state.isBusy]);

  const handleMouseOver = useCallback((idx: number, panel: string) => {
    if (isDragging) return;
    const grid = getGrid(panel);
    const it = grid[idx];
    if (!it) return;
    const gridId = panel === 'container' ? 'container-grid' : panel === 'right' ? 'right-grid' : 'inv-grid';
    const el = document.querySelector(`#${gridId} .slot[data-idx="${idx}"]`);
    if (el) {
      setTooltip({ item: it, rect: el.getBoundingClientRect() });
    }
  }, [getGrid, isDragging]);

  const handleMouseLeave = useCallback(() => {
    setTooltip({ item: null, rect: null });
  }, []);

  const handleUseItem = useCallback((idx: number) => {
    if (state.isBusy) return;
    const it = state.grid[idx];
    if (!it) return;
    if (!checkUseCooldown(it.name)) return;
    fetchNui('useItem', it.slot);
  }, [state.grid, state.isBusy]);

  const handleDropItem = useCallback((idx: number) => {
    if (state.isBusy) return;
    const it = state.grid[idx];
    if (!it) return;
    busyFetch('swapItems', {
      fromSlot: it.slot,
      toSlot: 1,
      fromType: 'player',
      toType: 'newdrop',
      count: state.itemAmount > 0 ? state.itemAmount : it.count,
    });
    playSound('drop');
  }, [state.grid, state.isBusy, state.itemAmount, busyFetch, playSound]);

  const handleGiveItem = useCallback((idx: number) => {
    if (state.isBusy) return;
    const it = state.grid[idx];
    if (!it) return;
    busyFetch('giveItem', { slot: it.slot, count: state.itemAmount > 0 ? state.itemAmount : it.count });
  }, [state.grid, state.isBusy, state.itemAmount, busyFetch]);

  const handleInspect = useCallback((idx: number, panel: string) => {
    dispatch({ type: 'INSPECT', index: idx, panel });
  }, [dispatch]);

  const handleOpenContainer = useCallback((idx: number) => {
    const it = state.grid[idx];
    if (!it || !it.isContainer) return;
    dispatch({ type: 'OPEN_CONTAINER', index: idx });
  }, [state.grid, dispatch]);

  const handleStoreIn = useCallback((idx: number) => {
    if (state.isBusy) return;
    const it = state.grid[idx];
    if (!it || state.containerOpen === null || it.isContainer) return;
    busyFetch('swapItems', {
      fromSlot: it.slot,
      toSlot: 0,
      fromType: 'player',
      toType: 'container',
      count: state.itemAmount > 0 ? state.itemAmount : it.count,
    });
  }, [state.grid, state.isBusy, state.containerOpen, busyFetch]);

  const handleTakeOut = useCallback((idx: number) => {
    if (state.isBusy) return;
    const it = state.containerGrid[idx];
    if (!it || state.containerOpen === null) return;
    busyFetch('swapItems', {
      fromSlot: it.slot,
      toSlot: 0,
      fromType: 'container',
      toType: 'player',
      count: it.count,
    });
  }, [state.containerGrid, state.isBusy, state.containerOpen, busyFetch]);


  const handleCloseContainer = useCallback(() => {
    dispatch({ type: 'CLOSE_CONTAINER' });
  }, [dispatch]);

  const handleCloseInspect = useCallback(() => {
    dispatch({ type: 'CLOSE_INSPECT' });
  }, [dispatch]);

  const handleCategoryChange = useCallback((cat: string) => {
    dispatch({ type: 'SET_CATEGORY', category: cat });
  }, [dispatch]);

  const handleSearchChange = useCallback((e: React.ChangeEvent<HTMLInputElement>) => {
    dispatch({ type: 'SET_SEARCH', search: e.target.value });
  }, [dispatch]);

  const handleSearchClear = useCallback(() => {
    dispatch({ type: 'SET_SEARCH', search: '' });
  }, [dispatch]);

  const handleSort = useCallback(async () => {
    if (state.isBusy) return;

    const gridSize = state.grid.length;

    const items: { slot: number; count: number; name: string; type: string; label: string }[] = [];
    for (const it of state.grid) {
      if (it && it.slot >= 1 && it.slot <= gridSize) {
        items.push({ slot: it.slot, count: it.count, name: it.name, type: it.type || 'item_misc', label: it.label || it.name });
      }
    }

    if (items.length <= 1) return;

    const order: Record<string, number> = { item_weapon: 0, item_ammo: 1, item_food: 2, item_misc: 3, item_collectables: 4 };
    const sorted = [...items].sort((a, b) => {
      if (a.type !== b.type) return (order[a.type] ?? 6) - (order[b.type] ?? 6);
      return a.label.localeCompare(b.label);
    });

    const pos = new Map<number, number>();
    for (const it of items) pos.set(it.slot, it.slot);

    const swaps: { fromSlot: number; toSlot: number }[] = [];

    for (let i = 0; i < sorted.length; i++) {
      const targetSlot = i + 1;
      const wanted = sorted[i].slot;
      const currentPos = pos.get(wanted)!;

      if (currentPos === targetSlot) continue;

      let evictedOrig: number | null = null;
      for (const [orig, cur] of pos) {
        if (cur === targetSlot) { evictedOrig = orig; break; }
      }

      swaps.push({ fromSlot: currentPos, toSlot: targetSlot });

      pos.set(wanted, targetSlot);
      if (evictedOrig !== null) pos.set(evictedOrig, currentPos);
    }

    if (swaps.length === 0) {
      addToast(tr('ui_already_sorted', 'Inventory is already sorted'), 'info');
      return;
    }

    dispatch({ type: 'SET_BUSY', busy: true });
    addToast(tr('ui_sorting', 'Sorting inventory...'), 'info');

    for (const swap of swaps) {
      await fetchNui('swapItems', {
        fromSlot: swap.fromSlot,
        toSlot: swap.toSlot,
        fromType: 'player',
        toType: 'player',
        count: 9999,
      });
    }

    addToast(tr('ui_sorted', 'Inventory sorted'), 'info');
  }, [state.grid, state.isBusy, dispatch, addToast]);

  const handleQuickStack = useCallback(() => {
    if (state.containerOpen === null) return;
    addToast(tr('ui_quick_stack', 'Quick stack'), 'info');
  }, [state.containerOpen, addToast]);

  const handleSplitRequest = useCallback((idx: number, panel: string) => {
    if (state.isBusy) return;
    const grid = getGrid(panel);
    const it = grid[idx];
    if (!it || it.count <= 1) return;
    setSplit({ visible: true, idx, panel });
  }, [state.isBusy, getGrid]);

  const handleSplitConfirm = useCallback((amount: number) => {
    if (state.isBusy) return;
    if (split.idx === null) return;
    const grid = getGrid(split.panel);
    const it = grid[split.idx];
    if (!it) { setSplit({ visible: false, idx: null, panel: 'main' }); return; }

    if (amount <= 0 || amount >= it.count) {
      addToast(tr('ui_invalid_amount', 'Invalid amount'), 'error');
      setSplit({ visible: false, idx: null, panel: 'main' });
      return;
    }

    const fromType = split.panel === 'right' ? (state.rightInventory?.type || 'player') : 'player';

    const emptySlot = grid.findIndex((slot, i) => slot === null && i !== split.idx);
    if (emptySlot === -1) {
      addToast(tr('ui_no_empty_slot', 'No empty slot is available'), 'error');
      setSplit({ visible: false, idx: null, panel: 'main' });
      return;
    }

    busyFetch('swapItems', {
      fromSlot: it.slot,
      toSlot: emptySlot + 1,
      fromType: fromType,
      toType: fromType,
      count: amount,
    });
    setSplit({ visible: false, idx: null, panel: 'main' });
    addToast(trf('ui_split_complete', 'Split %s x %s', amount, it.label || it.name), 'info');
  }, [split, state.isBusy, getGrid, addToast, busyFetch, state.rightInventory]);

  const handleSplitCancel = useCallback(() => {
    setSplit({ visible: false, idx: null, panel: 'main' });
  }, []);

  const handleAmmoPickerClose = useCallback(() => {
    if (ammoPickerBusy) return;
    setAmmoPicker(null);
  }, [ammoPickerBusy]);

  const handleAmmoPickerSelect = useCallback(async (weaponSlot: number, ammoSlot: number) => {
    if (ammoPickerBusy) return;
    setAmmoPickerBusy(true);
    const accepted = await fetchNui<boolean>('reloadWeapon', { weaponSlot, ammoSlot });
    setAmmoPickerBusy(false);
    if (accepted !== false) setAmmoPicker(null);
  }, [ammoPickerBusy]);

  const handleAmmoPickerUnload = useCallback(async (weaponSlot: number) => {
    if (ammoPickerBusy) return;
    setAmmoPickerBusy(true);
    await fetchNui('removeAmmo', weaponSlot);
    setAmmoPickerBusy(false);
    setAmmoPicker(null);
  }, [ammoPickerBusy]);

  const handleAmmoPickerPreferred = useCallback(async (weaponSlot: number, item: string) => {
    if (ammoPickerBusy) return;
    // Pinning does not close the picker: it is a setting, not the load action,
    // and the star has to be visible for the choice to have registered.
    const reply = await fetchNui<{ ok?: boolean; preferred?: string | null }>('setPreferredAmmo', { weaponSlot, item });
    if (!reply?.ok) return;
    setAmmoPicker((current) => (current && current.weaponSlot === weaponSlot
      ? { ...current, options: current.options.map((option) => ({ ...option, preferred: option.item === reply.preferred })) }
      : current));
  }, [ammoPickerBusy]);

  const handleCustomButton = useCallback((idx: number, buttonId: number) => {
    const it = state.grid[idx];
    if (!it) return;
    fetchNui('useButton', { id: buttonId, slot: it.slot });
  }, [state.grid]);

  const handleRemoveAmmo = useCallback((idx: number) => {
    const it = state.grid[idx];
    if (!it || Number(it.metadata?.ammo || 0) <= 0) return;
    fetchNui('removeAmmo', it.slot);
  }, [state.grid]);

  const handleSetPaymentCurrency = useCallback((c: 'cash' | 'gold') => {
    dispatch({ type: 'SET_SHOP_CURRENCY', currency: c });
  }, [dispatch]);

  const handleSetItemAmount = useCallback((n: number) => {
    dispatch({ type: 'SET_ITEM_AMOUNT', amount: n });
  }, [dispatch]);

  const handleTradeAccept = useCallback(() => {
    if (!state.tradeRequest) return;
    fetchNui('acceptTrade', { tradeId: state.tradeRequest.tradeId });
    dispatch({ type: 'TRADE_CLEAR_REQUEST' });
  }, [state.tradeRequest, dispatch]);

  const handleTradeDecline = useCallback(() => {
    if (!state.tradeRequest) return;
    fetchNui('declineTrade', { tradeId: state.tradeRequest.tradeId });
    dispatch({ type: 'TRADE_CLEAR_REQUEST' });
  }, [state.tradeRequest, dispatch]);

  const handleTradeAddItem = useCallback((item: InventoryItem) => {
    if (state.myOffer.some((o: any) => o.id === item.id)) {
      addToast(tr('ui_trade_item_exists', 'This item is already in the offer'), 'error');
      return;
    }
    const newOffer = [...state.myOffer, { id: item.id, name: item.name, label: item.label, count: item.count, weight: item.weight }];
    dispatch({ type: 'TRADE_SET_MY_OFFER', items: newOffer });
    fetchNui('offerTradeItems', { tradeId: state.tradeId, items: newOffer });
  }, [state.myOffer, state.tradeId, dispatch, addToast]);

  const handleTradeRemoveItem = useCallback((itemId: string) => {
    const newOffer = state.myOffer.filter((o: any) => o.id !== itemId);
    dispatch({ type: 'TRADE_SET_MY_OFFER', items: newOffer });
    fetchNui('offerTradeItems', { tradeId: state.tradeId, items: newOffer });
  }, [state.myOffer, state.tradeId, dispatch]);

  const handleTradeConfirm = useCallback(() => {
    dispatch({ type: 'TRADE_MY_CONFIRM' });
    fetchNui('confirmTrade', { tradeId: state.tradeId });
  }, [state.tradeId, dispatch]);

  const handleTradeCancel = useCallback(() => {
    fetchNui('cancelTrade', { tradeId: state.tradeId });
  }, [state.tradeId]);

  useEffect(() => {
    function onKeyDown(e: KeyboardEvent) {
      if (!visible) return;
      const tag = (document.activeElement as HTMLElement)?.tagName || '';
      const typing = tag === 'INPUT' || tag === 'TEXTAREA';

      if (e.key === 'Escape') {
        if (ammoPicker) { handleAmmoPickerClose(); e.preventDefault(); return; }
        if (state.tradeOpen) { handleTradeCancel(); e.preventDefault(); return; }
        if (split.visible) { handleSplitCancel(); e.preventDefault(); return; }
        if (state.inspecting !== null) { handleCloseInspect(); e.preventDefault(); return; }
        if (state.containerOpen !== null) { handleCloseContainer(); e.preventDefault(); return; }
        if (typing) { (document.activeElement as HTMLElement).blur(); e.preventDefault(); return; }
        handleClose();
        e.preventDefault();
      }
      if (typing) return;
      if (e.key === 'i' || e.key === 'I') {
        handleClose();
        e.preventDefault();
      }
      if (e.key >= '1' && e.key <= '6') {
        const cats = ['all', 'item_ammo', 'item_food', 'item_misc', 'item_collectables', 'item_weapon'];
        handleCategoryChange(cats[parseInt(e.key) - 1]);
        e.preventDefault();
      }
      if (e.key === 's' || e.key === 'S') {
        handleSort();
        e.preventDefault();
      }
    }
    document.addEventListener('keydown', onKeyDown);
    return () => document.removeEventListener('keydown', onKeyDown);
  }, [visible, state.inspecting, state.containerOpen, state.tradeOpen, split.visible, ammoPicker, handleAmmoPickerClose, handleCloseInspect, handleCloseContainer, handleClose, handleCategoryChange, handleSort, handleSplitCancel, handleTradeCancel]);

  const selectedItem = state.selected !== null ? getGrid(state.panel)[state.selected] : null;
  const ctxItem = ctx.visible && ctx.idx !== null ? getGrid(ctx.panel)[ctx.idx] : null;
  const inspectItem = state.inspecting !== null ? getGrid(state.inspectPanel)[state.inspecting] : null;
  const splitItem = split.visible && split.idx !== null ? getGrid(split.panel)[split.idx] : null;

  const customButtons = useMemo(() => {
    if (!ctxItem?.name) return undefined;
    const data = itemsDbRef.current[ctxItem.name];
    return data?.buttons?.map((button, index) => ({
      ...(typeof button === 'string' ? { label: button } : button),
      id: index + 1,
    }));
  }, [ctxItem]);

  if (!visible) return (
    <>
      <HotBar slots={hotbar.slots} visible={hotbar.hotbarVisible} onUseSlot={hotbar.useSlot} />
      <ToastContainer toasts={toasts} />
    </>
  );

  return (
    <DndContext sensors={sensors} collisionDetection={pointerWithin} onDragStart={handleDragStart} onDragEnd={handleDragEnd}>
      <div id="inventory" style={{ display: 'block' }}>
        <div
          id="inventory-wrapper" className="wf-shell"
          ref={wrapperRef}
          style={{
            opacity: animating ? 1 : 0,
            ...(fittedPanelPos
              ? {
                  left: `${fittedPanelPos.x}px`,
                  top: `${fittedPanelPos.y}px`,
                  transform: animating ? 'none' : 'scale(.8)',
                }
              : {
                  transform: animating ? 'translateY(-50%)' : 'translateY(-50%) scale(.8)',
                }),
          }}
        >
          <div className="top" onMouseDown={handlePanelDragStart} style={{ cursor: 'grab' }}>
            {/* The bag's badge and the close button at one width, and the title between them in the middle */}
            <div className="inv-badge">{SVG_SATCHEL}</div>
            <div className="inv-titles">
              <span className="title" id="inv-title">{tr('ui_inventory', 'Inventory')}</span>
            </div>
            <div id="inv-close-btn" onClick={handleClose}>{SVG_X}</div>
          </div>
          <div className="inv-weight-block">
            <WeightBar grid={state.grid} maxWeight={state.maxWeight} />
            <WeightProgress grid={state.grid} maxWeight={state.maxWeight} />
          </div>
          <div className="inv-hr" />
          <div id="inv-currency-row">
            <div className="inv-currency cash">
              <span className="inv-currency-icon">{SVG_CASH}</span>
              <span className="inv-currency-val">{formatCompact(state.playerCash)}</span>
            </div>
            <div className="inv-currency gold">
              <span className="inv-currency-icon">{SVG_GOLD}</span>
              <span className="inv-currency-val">{formatCompact(state.playerGold)}</span>
            </div>
          </div>
          {/* Search and quantity share one row: search grows to fill, quantity
              stays compact at the end. They used to be two stacked rows, which
              wasted a whole line and left the quantity field floating alone. */}
          <div id="inv-search-row">
            <div className="inv-search">
              <input
                type="text"
                className="search-bar"
                id="inv-search"
                placeholder={tr('ui_search_items', 'Search items...')}
                value={state.search}
                onChange={handleSearchChange}
                spellCheck={false}
                autoComplete="off"
              />
              {state.search ? (
                <button
                  type="button"
                  className="inv-search-clear"
                  onClick={handleSearchClear}
                  aria-label={tr('ui_cancel', 'Cancel')}
                >
                  <Glyph tex="cross" />
                </button>
              ) : null}
            </div>
            {/* No visible label — the field sits beside the search box and its
                purpose is obvious from the number in it. The name is kept as
                title/aria-label so it is still announced and shown on hover. */}
            <div id="inv-amount-row">
              <input
                type="number"
                className="inv-amount-input"
                value={state.itemAmount || ''}
                min={0}
                onChange={(e) => handleSetItemAmount(parseInt(e.target.value) || 0)}
                placeholder="0"
                title={tr('ui_quantity', 'Quantity')}
                aria-label={tr('ui_quantity', 'Quantity')}
              />
            </div>
          </div>
          <InventoryGrid
            grid={state.grid}
            category={state.category}
            search={state.search}
            selected={state.selected}
            panel="main"
            selectedPanel={state.panel}
            hotbarSlots={hotbar.slots}
            onSelect={handleSelect}
            onContextMenu={handleContextMenu}
            onDoubleClick={handleDoubleClick}
            onMouseOver={handleMouseOver}
            onMouseLeave={handleMouseLeave}
          />
          <Toolbar
            onSort={handleSort}
            onQuickStack={handleQuickStack}
            containerOpen={state.containerOpen}
          />
          <CategoryBar active={state.category} onChange={handleCategoryChange} grid={state.grid} />
        </div>

        <DetailPanel
          item={selectedItem}
          panel={state.panel}
          containerOpen={state.containerOpen}
          panelPos={fittedPanelPos}
        />

        <ContainerPanel
          containerOpen={state.containerOpen}
          containerGrid={state.containerGrid}
          containerLabel={state.containerLabel}
          containerMaxWeight={state.containerMaxWeight}
          containerSlots={state.containerSlots}
          selected={state.selected}
          selectedPanel={state.panel}
          onSelect={handleSelect}
          onContextMenu={handleContextMenu}
          onDoubleClick={handleDoubleClick}
          onMouseOver={handleMouseOver}
          onMouseLeave={handleMouseLeave}
          onClose={handleCloseContainer}
          panelPos={fittedPanelPos}
        />

        <RightInventoryPanel
          rightInventory={state.rightInventory}
          rightGrid={state.rightGrid}
          selected={state.selected}
          selectedPanel={state.panel}
          onSelect={handleSelect}
          onContextMenu={handleContextMenu}
          onDoubleClick={handleDoubleClick}
          onMouseOver={handleMouseOver}
          onMouseLeave={handleMouseLeave}
          playerCash={state.playerCash}
          playerGold={state.playerGold}
          shopPaymentCurrency={state.shopPaymentCurrency}
          onSetPaymentCurrency={handleSetPaymentCurrency}
          itemAmount={state.itemAmount}
          onSetItemAmount={handleSetItemAmount}
        />

        <ContextMenu
          visible={ctx.visible}
          x={ctx.x}
          y={ctx.y}
          item={ctxItem}
          idx={ctx.idx}
          panel={ctx.panel}
          containerOpen={state.containerOpen}
          onClose={() => setCtx((c) => ({ ...c, visible: false }))}
          onUse={handleUseItem}
          onDrop={handleDropItem}
          onGive={handleGiveItem}
          onInspect={handleInspect}
          onOpenContainer={handleOpenContainer}
          onStoreIn={handleStoreIn}
          onTakeOut={handleTakeOut}
          onSplit={handleSplitRequest}
          onRemoveAmmo={handleRemoveAmmo}
          customButtons={customButtons}
          onCustomButton={handleCustomButton}
        />

        <Tooltip item={tooltip.item} anchorRect={tooltip.rect} />
        <InspectOverlay item={inspectItem} onClose={handleCloseInspect} />

        <SplitDialog
          item={splitItem}
          visible={split.visible}
          onConfirm={handleSplitConfirm}
          onCancel={handleSplitCancel}
        />

        <AmmoPicker
          data={ammoPicker}
          busy={ammoPickerBusy}
          onSelect={handleAmmoPickerSelect}
          onUnload={handleAmmoPickerUnload}
          onSetPreferred={handleAmmoPickerPreferred}
          onClose={handleAmmoPickerClose}
        />

        <DropZone active={isDragging && !!dragItem} />

        <TradeRequest
          request={state.tradeRequest}
          onAccept={handleTradeAccept}
          onDecline={handleTradeDecline}
        />

        <TradePanel
          tradeOpen={state.tradeOpen}
          tradePartner={state.tradePartner}
          myOffer={state.myOffer}
          theirOffer={state.theirOffer}
          myConfirmed={state.myConfirmed}
          theirConfirmed={state.theirConfirmed}
          tradeCompleting={state.tradeCompleting}
          onRemoveFromOffer={handleTradeRemoveItem}
          onConfirm={handleTradeConfirm}
          onCancel={handleTradeCancel}
        />
      </div>

      <DragOverlay dropAnimation={null}>
        {dragItem ? <DragGhost item={dragItem} /> : null}
      </DragOverlay>

      <HotBar slots={hotbar.slots} visible={hotbar.hotbarVisible} onUseSlot={hotbar.useSlot} />
      <ToastContainer toasts={toasts} />
    </DndContext>
  );
}
