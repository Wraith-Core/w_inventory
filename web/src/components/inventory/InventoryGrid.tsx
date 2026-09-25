import React, { useContext, useEffect, useMemo, useRef, useState } from 'react';
import { WInventory as Inventory } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import { getTotalWeight } from '../../helpers';
import { useAppSelector, useAppDispatch } from '../../store';
import { selectPlayerGold, selectPlayerCash, selectShopPaymentCurrency, setShopPaymentCurrency } from '../../store/inventory';
import { useIntersection } from '../../hooks/useIntersection';
import InventoryControl from './InventoryControl';
import {Backpack, WeightIcon} from 'lucide-react';
import { InventoryButtonCategory } from './InventoryButtonCategory';
import { IconName } from 'lucide-react/dynamic';
import { motion, AnimatePresence } from 'framer-motion';
import ClothingButton from './ClothingButton';
import ClothingInterface from './ClothingInterface';
import { Locale } from '../../store/locale';
import { InventoryPositionContext } from './index';
import { fetchNui } from '../../utils/fetchNui';
import { formatCompact } from '../../utils/formatNumber';

const PAGE_SIZE = 30;

/** Disabling the clothing tab from the interface only (the code stays so it can be enabled later) */
const CLOTHING_TAB_ENABLED = false;

interface InventoryMeta {
  isMainInventory?: boolean;
  isDropInventory?: {
    value: boolean,
    type: string,
    shouldRender: boolean;
  };
}

const InventoryGrid: React.FC<{ inventory: Inventory, renderControl?: boolean, meta?: InventoryMeta }> = ({ inventory, renderControl, meta = {} }) => {
  const positionContext = useContext(InventoryPositionContext);
  const isThisDragging =
    (meta?.isMainInventory && positionContext?.isMainDragging) ||
    (meta?.isDropInventory?.value && positionContext?.isSecondaryDragging);
  const weight = useMemo(
    () => (inventory.maxWeight !== undefined ? Math.floor(getTotalWeight(inventory.items) * 1000) / 1000 : 0),
    [inventory.maxWeight, inventory.items]
  );
  const [page, setPage] = useState(0);
  const [isClothingMode, setIsClothingMode] = useState(false);
  const containerRef = useRef(null);
  const { ref, entry } = useIntersection({ threshold: 0.5 });
  const isBusy = useAppSelector((state: any) => state.inventory.isBusy);
  const playerGold = useAppSelector(selectPlayerGold);
  const playerCash = useAppSelector(selectPlayerCash);
  const shopPaymentCurrency = useAppSelector(selectShopPaymentCurrency);
  const dispatch = useAppDispatch();

  useEffect(() => {
    if (entry && entry.isIntersecting) {
      setPage((prev) => ++prev);
    }
  }, [entry]);

  // On opening the clothing tab: asking the client for the list of clothes currently worn
  useEffect(() => {
    if (CLOTHING_TAB_ENABLED && meta?.isMainInventory && isClothingMode) {
      fetchNui('requestWornClothing', {});
    }
  }, [meta?.isMainInventory, isClothingMode]);

  return (
    <motion.div
      className={`flex flex-col gap-2 backdrop-blur-medium transition-smooth ${isClothingMode ? 'overflow-visible' : 'overflow-y-hidden'}`}
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.3, ease: "easeOut" }}
    >
      <motion.div
          className={`relative inventory-grid-wrapper rounded-md
           transition-all duration-300
          ${isThisDragging ? 'inventory-panel-dragging' : ''}
          ${meta?.isDropInventory?.value
            ? meta.isDropInventory.shouldRender
              ? "opacity-100 h-auto py-1.5 border w-[520px] px-1"
              : "opacity-0 h-0 scale-y-[50%] scale-x-0 p-0"
            : meta?.isMainInventory
              ? isClothingMode
                ? "py-1.5 border w-[520px] h-auto px-1"
                : "py-1.5 border w-[520px] h-[554px] px-1"
              : renderControl
                ? "py-1.5 border w-[520px] h-[342px] px-1"
                : "h-0 opacity-0 overflow-hidden p-0 w-[520px]"
          }`}
          style={{
            pointerEvents: isBusy ? 'none' : 'auto',
            borderWidth: '1px',
            borderColor: "var(--color-accent)",
            background: isThisDragging ? 'rgba(22, 22, 22, 0.75)' : '#161616',
          }}
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{
            duration: 0.25,
            ease: "easeOut"
          }}
      >
        {/* Main Inventory Header - Figma Style; left part = drag handle */}
        {meta?.isMainInventory && (
          <div className="flex justify-between items-center rounded backdrop-blur-medium transition-smooth">
            <div
              className="inventory-header-drag-handle flex items-center gap-3 cursor-move select-none"
              onMouseDown={positionContext?.onMainDragHandleMouseDown}
              role="button"
              aria-label="Drag to move inventory"
            >
              <motion.div
                className="flex items-center gap-3"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ duration: 0.2, ease: "easeOut" }}
              >
                <div className="w-8 h-8 rounded flex items-center justify-center">
                  <Backpack size={25} color="#ffffffff" />
                </div>
                <AnimatePresence mode="wait">
                  <motion.h2
                    className="text-white text-2xl font-main font-bold tracking-wider uppercase"
                    key={isClothingMode ? "clothing" : "inventory"}
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    exit={{ opacity: 0 }}
                    transition={{
                      duration: 0.15,
                      ease: "easeInOut"
                    }}
                  >
                    {isClothingMode ? Locale["ui_clothing"] || "Clothing" : Locale["ui_inventory"] || "Inventory"}
                  </motion.h2>
                </AnimatePresence>
              </motion.div>
            </div>
            <motion.div
              className="flex items-center gap-4"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.2, ease: "easeOut" }}
            >
              {CLOTHING_TAB_ENABLED && (
                <ClothingButton
                  isActive={isClothingMode}
                  onClick={() => setIsClothingMode(!isClothingMode)}
                />
              )}
              <div className="inventory-control-header">
                <InventoryControl />
              </div>
            </motion.div>
          </div>
        )}

        <div>
          {/* Weight Display - Figma Style */}
          { inventory.maxWeight && (
            <div className="relative mt-1 mb-2">
              <div className="flex items-center justify-between gap-2 mb-1">
                {/* The cash and gold balances from PlayerData.money (gold is an accounting currency) */}
                {meta?.isMainInventory && (
                  <div className="flex gap-3 text-sm font-medium tabular-nums">
                    <span className="text-[#EDE6D6]" title="Cash">Cash: {formatCompact(playerCash)}</span>
                  </div>
                )}
                <span className="flex-1" />
              </div>
              <WeightBar
                percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0}
                current={weight}
                max={inventory.maxWeight}
              />
            </div>
          )}

          {
            !meta?.isMainInventory && (
              <div
                style={{ color: "rgb(227 228 227)" }}
                className="relative flex flex-col rounded mt-2 py-1 pb-2 mx-1"
              >
                <div
                  className="flex justify-around cursor-move select-none inventory-header-drag-handle"
                  onMouseDown={positionContext?.onSecondaryDragHandleMouseDown}
                  role="button"
                  aria-label="Drag to move this panel"
                >
                  <p style={{ textTransform: "uppercase" }}>
                    { meta.isDropInventory?.type === "newdrop" ? (Locale["ui_floor"] || "Floor") : inventory.label }
                  </p>
                </div>
                {inventory.type === 'shop' && (
                  <div className="flex flex-col gap-2 mt-2" style={{ color: 'rgb(227 228 227)' }}>
                    <div className="flex gap-2 justify-center text-xs tabular-nums">
                      <span className="text-[#EDE6D6]">Cash: {formatCompact(playerCash)}</span>
                    </div>
                  </div>
                )}
              </div>
            )
          }

          { /* <div className="inventory-grid-header-wrapper">
            <p>{inventory.label}</p>
            {inventory.maxWeight && (
              <p>
                {weight / 1000}/{inventory.maxWeight / 1000}kg
              </p>
            )}
          </div>
          <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} /> */ }
        </div>

        {/* Conditional rendering: Clothing Interface or Inventory Grid (disabled when CLOTHING_TAB_ENABLED = false) */}
        {CLOTHING_TAB_ENABLED && meta?.isMainInventory && isClothingMode ? (
          <motion.div
            className="p-3"
            initial={{ opacity: 0, scale: 0.95, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.95, y: -20 }}
            transition={{ duration: 0.4, ease: "easeOut" }}
          >
            <ClothingInterface />
          </motion.div>
        ) : (
          <motion.div
            className="relative inventory-grid-outer"
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: 0.2, ease: "easeOut" }}
          >
            <motion.div
              className="inv-grid inventory-grid-container"
              ref={containerRef}
              style={{
                maxHeight: meta?.isMainInventory
                  ? '15.5rem'  // 4 rows (20 slots), scroll for the rest
                  : '15.5rem',
                overflowY: 'auto',
                direction: 'ltr'
              }}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.6, delay: 0.3 }}
            >
              <AnimatePresence>
                {inventory.items.slice(0, (page + 1) * PAGE_SIZE).map((item: any, index: number) => (
                  <InventorySlot
                    key={`${inventory.type}-${inventory.id}-${item.slot}`}
                    item={item}
                    ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                    inventoryType={inventory.type}
                    inventoryGroups={inventory.groups}
                    inventoryId={inventory.id}
                  />
                ))}
              </AnimatePresence>
            </motion.div>
            {/* A gradient below the slots (a fixed colour so it works in the game too) */}
            <motion.div
              className="absolute bottom-0 left-0 right-0 h-12 pointer-events-none rounded-b"
              style={{
                background: 'linear-gradient(to top, #161616 0%, rgba(22, 22, 22, 0) 100%)',
              }}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.8, delay: 0.6 }}
            />
          </motion.div>
        )}
      </motion.div>
    </motion.div>
  );
};

export default InventoryGrid;
