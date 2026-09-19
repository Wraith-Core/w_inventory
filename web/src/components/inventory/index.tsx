import React, { useState, useImperativeHandle, forwardRef, useCallback } from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import InventoryHotbar from './InventoryHotbar';
import { useAppDispatch } from '../../store';
import { refreshSlots, setAdditionalMetadata, setAccountCurrency, setupInventory } from '../../store/inventory';
import { useExitListener } from '../../hooks/useExitListener';
import type { Inventory as InventoryProps } from '../../typings';
import RightInventory from './RightInventory';
import LeftInventory from './LeftInventory';
import Tooltip from '../utils/Tooltip';
import { closeTooltip } from '../../store/tooltip';
import InventoryContext from './InventoryContext';
import { closeContextMenu } from '../../store/contextMenu';
import Fade from '../utils/transitions/Fade';
import { ExtraControls } from './ExtraControls';

export const InventoryPositionContext = React.createContext<{
  mainPosition: { x: number; y: number };
  secondaryPosition: { x: number; y: number };
  isMainDragging: boolean;
  isSecondaryDragging: boolean;
  onMainDragHandleMouseDown: (e: React.MouseEvent) => void;
  onSecondaryDragHandleMouseDown: (e: React.MouseEvent) => void;
} | null>(null);

const Inventory = forwardRef((_, ref) => {
  const [inventoryVisible, setInventoryVisible] = useState(false);
  const [mainPosition, setMainPosition] = useState({ x: 0, y: 0 });
  const [secondaryPosition, setSecondaryPosition] = useState({ x: 0, y: 0 });
  const [isMainDragging, setIsMainDragging] = useState(false);
  const [isSecondaryDragging, setIsSecondaryDragging] = useState(false);
  const dispatch = useAppDispatch();

  const onMainDragHandleMouseDown = useCallback((e: React.MouseEvent) => {
    if (e.button !== 0) return;
    e.preventDefault();
    setIsMainDragging(true);
    const startX = e.clientX - mainPosition.x;
    const startY = e.clientY - mainPosition.y;
    const onMove = (e2: MouseEvent) => {
      setMainPosition({ x: e2.clientX - startX, y: e2.clientY - startY });
    };
    const onUp = () => {
      setIsMainDragging(false);
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
    };
    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
  }, [mainPosition.x, mainPosition.y]);

  const onSecondaryDragHandleMouseDown = useCallback((e: React.MouseEvent) => {
    if (e.button !== 0) return;
    e.preventDefault();
    setIsSecondaryDragging(true);
    const startX = e.clientX - secondaryPosition.x;
    const startY = e.clientY - secondaryPosition.y;
    const onMove = (e2: MouseEvent) => {
      setSecondaryPosition({ x: e2.clientX - startX, y: e2.clientY - startY });
    };
    const onUp = () => {
      setIsSecondaryDragging(false);
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
    };
    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
  }, [secondaryPosition.x, secondaryPosition.y]);

  useNuiEvent<boolean>('setInventoryVisible', setInventoryVisible);
  useNuiEvent<false>('closeInventory', () => {
    setInventoryVisible(false);
    dispatch(closeContextMenu());
    dispatch(closeTooltip());
  });
  useExitListener(setInventoryVisible);

  useNuiEvent<{
    leftInventory?: InventoryProps;
    rightInventory?: InventoryProps;
    wornClothingCategories?: string[];
    removedClothingCategories?: string[];
  }>('setupInventory', (data) => {
    dispatch(setupInventory(data));
    !inventoryVisible && setInventoryVisible(true);
  });

  useNuiEvent('refreshSlots', (data) => dispatch(refreshSlots(data)));

  useNuiEvent('displayMetadata', (data: Array<{ metadata: string; value: string }>) => {
    dispatch(setAdditionalMetadata(data));
  });

  useNuiEvent<{ cash?: number; gold?: number }>('updateCurrency', (data) => {
    if (data == null) return;
    dispatch(setAccountCurrency({ cash: data?.cash, gold: data?.gold }));
  });

  return (
    <>
      <Fade in={inventoryVisible}>
        <InventoryPositionContext.Provider value={{
          mainPosition,
          secondaryPosition,
          isMainDragging,
          isSecondaryDragging,
          onMainDragHandleMouseDown,
          onSecondaryDragHandleMouseDown,
        }}>
          <div className="inventory-wrapper">
            {/* <ExtraControls /> */}
            <div style={{ transform: `translate(${mainPosition.x}px, ${mainPosition.y}px)` }}>
              <LeftInventory />
            </div>
            <div style={{ transform: `translate(${secondaryPosition.x}px, ${secondaryPosition.y}px)` }}>
              <RightInventory />
            </div>
            <Tooltip />
            <InventoryContext />
          </div>
        </InventoryPositionContext.Provider>
      </Fade>
      <InventoryHotbar />
    </>
  );
});

export default Inventory;
