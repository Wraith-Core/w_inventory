import React, { useCallback, useRef, useMemo } from 'react';
import { DragSource, Inventory, InventoryType, Slot, SlotWithItem } from '../../typings';
import { useDrag, useDragDropManager, useDrop } from 'react-dnd';
import { useAppDispatch, useAppSelector } from '../../store';
import WeightBar from '../utils/WeightBar';
import { onDrop } from '../../dnd/onDrop';
import { onBuy } from '../../dnd/onBuy';
import { Items } from '../../store/items';
import { canCraftItem, canPurchaseItem, getItemUrl, isSlotWithItem } from '../../helpers';
import { imagepath } from '../../store/imagepath';
import { onUse } from '../../dnd/onUse';
import { Locale } from '../../store/locale';
import { onCraft } from '../../dnd/onCraft';
import useNuiEvent from '../../hooks/useNuiEvent';
import { ItemsPayload } from '../../reducers/refreshSlots';
import { closeTooltip, openTooltip } from '../../store/tooltip';
import { selectShopPaymentCurrency, selectGoldPriceMultiplier } from '../../store/inventory';
import { openContextMenu } from '../../store/contextMenu';
import { useMergeRefs } from '@floating-ui/react';
import { motion } from 'framer-motion';

interface SlotProps {
  inventoryId: Inventory['id'];
  inventoryType: Inventory['type'];
  inventoryGroups: Inventory['groups'];
  item: Slot;
}

const getRarityColor = (rarity?: string) => {
  switch (rarity) {
    case 'rare':
      return '#a9a9a9'; // chrome step
    case 'epic':
      return '#c6c6c6'; // chrome step
    case 'legendary':
      return '#d8d8d8'; // chrome step
    case 'common':
    default:
      return '#6d6d6d'; // faint
  }
};

const InventorySlot: React.ForwardRefRenderFunction<HTMLDivElement, SlotProps> = (
  { item, inventoryId, inventoryType, inventoryGroups },
  ref
) => {
  const manager = useDragDropManager();
  const dispatch = useAppDispatch();
  const timerRef = useRef<number | null>(null);
  const shopPaymentCurrency = useAppSelector(selectShopPaymentCurrency);
  const goldPriceMultiplier = useAppSelector(selectGoldPriceMultiplier);

  const rarityColor = getRarityColor( item.metadata?.rarity );

  const canDrag = useCallback(() => {
    return canPurchaseItem(item, { type: inventoryType, groups: inventoryGroups }) && canCraftItem(item, inventoryType);
  }, [item, inventoryType, inventoryGroups]);

  const [{ isDragging }, drag] = useDrag<DragSource, void, { isDragging: boolean }>(
    () => ({
      type: 'SLOT',
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      item: () =>
        isSlotWithItem(item, inventoryType !== InventoryType.SHOP)
          ? {
              inventory: inventoryType,
              item: {
                name: item.name,
                slot: item.slot,
              },
              image: item?.name && `url(${getItemUrl(item) || 'none'}`,
            }
          : null,
      canDrag,
    }),
    [inventoryType, item]
  );

  const [{ isOver }, drop] = useDrop<DragSource, void, { isOver: boolean }>(
    () => ({
      accept: 'SLOT',
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      drop: (source) => {
        dispatch(closeTooltip());
        switch (source.inventory) {
          case InventoryType.SHOP:
            onBuy(source, { inventory: inventoryType, item: { slot: item.slot } });
            break;
          case InventoryType.CRAFTING:
            onCraft(source, { inventory: inventoryType, item: { slot: item.slot } });
            break;
          default:
            onDrop(source, { inventory: inventoryType, item: { slot: item.slot } });
            break;
        }
      },
      canDrop: (source) =>
        (source.item.slot !== item.slot || source.inventory !== inventoryType) &&
        inventoryType !== InventoryType.SHOP &&
        inventoryType !== InventoryType.CRAFTING,
    }),
    [inventoryType, item]
  );

  useNuiEvent('refreshSlots', (data: { items?: ItemsPayload | ItemsPayload[] }) => {
    if (!isDragging && !data.items) return;
    if (!Array.isArray(data.items)) return;

    const itemSlot = data.items.find(
      (dataItem) => dataItem.item.slot === item.slot && dataItem.inventory === inventoryId
    );

    if (!itemSlot) return;

    manager.dispatch({ type: 'dnd-core/END_DRAG' });
  });

  const connectRef = (element: HTMLDivElement) => drag(drop(element));

  const handleContext = (event: React.MouseEvent<HTMLDivElement>) => {
    event.preventDefault();
    if (inventoryType !== 'player' || !isSlotWithItem(item)) return;

    dispatch(openContextMenu({ item, coords: { x: event.clientX, y: event.clientY } }));
  };

  const handleClick = (event: React.MouseEvent<HTMLDivElement>) => {
    dispatch(closeTooltip());
    if (timerRef.current) clearTimeout(timerRef.current);
    if (event.ctrlKey && isSlotWithItem(item) && inventoryType !== 'shop' && inventoryType !== 'crafting') {
      onDrop({ item: item, inventory: inventoryType });
    } else if (event.altKey && isSlotWithItem(item) && inventoryType === 'player') {
      onUse(item);
    }
  };

  const refs = useMergeRefs([connectRef, ref]);

  return (
    <motion.div
      ref={refs}
      onContextMenu={handleContext}
      onClick={handleClick}
      className={`inventory-slot rounded-sm custom-scrollbar backdrop-blur-medium transition-smooth
        ${isOver ? "bg-secondary" : "bg-secondary/90"}
        ${isSlotWithItem(item) ? "will-change-transform" : ""}
        `}
      style={{
        filter:
          !canPurchaseItem(item, { type: inventoryType, groups: inventoryGroups }) || !canCraftItem(item, inventoryType)
            ? 'brightness(80%) grayscale(100%)'
            : undefined,
        borderTop: isSlotWithItem(item) ? `2px solid ${rarityColor}` : undefined,
      }}
      initial={{
        opacity: 0,
        scale: 0.95
      }}
      animate={{
        opacity: 1,
        scale: isOver ? 1.02 : 1,
        boxShadow: isOver
          ? "0 4px 16px rgba(0, 0, 0, 0.2)"
          : "0 0 0 rgba(0, 0, 0, 0)"
      }}
      transition={{
        duration: 0.15,
        ease: "easeOut",
        delay: item.slot < 30 ? item.slot * 0.003 : 0
      }}
    >
      {/* Animated Item Image Overlay */}
      {isSlotWithItem(item) && item?.name && (
        <motion.div
          key={`item-image-${item.name}-${item.slot}`}
          className="absolute inset-0 flex items-center justify-center pointer-events-none"
          initial={{
            scale: 0.7,
            opacity: 0
          }}
          animate={{
            scale: 1,
            opacity: 1
          }}
          exit={{
            scale: 0.7,
            opacity: 0
          }}
          transition={{
            duration: 0.2,
            ease: "easeOut"
          }}
        >
          <img
            src={getItemUrl(item as SlotWithItem)}
            alt=""
            style={{
              width: '60%',
              height: '60%',
              objectFit: 'contain',
              imageRendering: '-webkit-optimize-contrast',
            }}
            onError={(e) => {
              const target = e.currentTarget;
              target.onerror = null;
              target.src = `${imagepath}/_placeholder.png`;
            }}
          />
        </motion.div>
      )}
      
      {isSlotWithItem(item) && (
        <div
          className="item-slot-wrapper"
          onMouseEnter={() => {
            timerRef.current = window.setTimeout(() => {
              dispatch(openTooltip({ item, inventoryType }));
            }, 500) as unknown as number;
          }}
          onMouseLeave={() => {
            dispatch(closeTooltip());
            if (timerRef.current) {
              clearTimeout(timerRef.current);
              timerRef.current = null;
            }
          }}
        >
          <div
            className={
              inventoryType === 'player' && item.slot <= 5 ? 'item-hotslot-header-wrapper px-2 place-center' : 'item-slot-header-wrapper px-2'
            }
          >
            {inventoryType === 'player' && item.slot <= 5 && <div className="inventory-slot-number">{item.slot}</div>}
            <div className="item-slot-info-wrapper">
              <p>{item.count ? `x` + item.count.toLocaleString('en-us', (item.name === 'money' || item.name === 'cash') ? { minimumFractionDigits: 2, maximumFractionDigits: 2 } : undefined) : ''}</p>
            </div>
          </div>
          <div> 
            {inventoryType !== 'shop' && item?.durability !== undefined && (
              <WeightBar percent={item.durability} durability />
            )}
            {inventoryType === 'shop' && item?.price !== undefined && (
              <>
                {item?.currency !== 'money' && item.price > 0 && item.currency ? (
                  <div className="item-slot-currency-wrapper">
                    <img
                      src={item.currency ? getItemUrl(item.currency) : 'none'}
                      alt="item-image"
                      style={{
                        imageRendering: '-webkit-optimize-contrast',
                        height: 'auto',
                        width: '2vh',
                        backfaceVisibility: 'hidden',
                        transform: 'translateZ(0)',
                      }}
                    />
                    <p>{item.price.toLocaleString('en-us')}</p>
                  </div>
                ) : (
                  <>
                    {item.price > 0 && (
                      <div
                        className="item-slot-price-wrapper"
                        style={{
                          color:
                            item.currency === 'money' || !item.currency
                              ? '#d2d2d2'
                              : '#cb0101',
                        }}
                      >
                        <p>
                          {item.currency === 'money' || !item.currency
                            ? (Locale.$ || '$')
                            : ''}
                          {item.price.toLocaleString('en-us')}
                        </p>
                      </div>
                    )}
                  </>
                )}
              </>
            )}
            <div className="inventory-slot-label-box hidden">
              <div className="inventory-slot-label-text">
                {item.metadata?.label ? item.metadata.label : Items[item.name]?.label || item.name}
              </div>
            </div>
          </div>
        </div>
      )}
    </motion.div>
  );
};

export default React.memo(React.forwardRef(InventorySlot));
