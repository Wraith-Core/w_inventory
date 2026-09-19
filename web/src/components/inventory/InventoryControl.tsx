import React, { useState } from 'react';
import { useAppDispatch, useAppSelector } from '../../store';
import { selectItemAmount, setItemAmount } from '../../store/inventory';
import UsefulControls from './UsefulControls';

const InventoryControl: React.FC = () => {
  const itemAmount = useAppSelector(selectItemAmount);
  const dispatch = useAppDispatch();

  const [infoVisible, setInfoVisible] = useState(false);

  const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
    let val = parseFloat(event.target.value);
    val = isNaN(val) || val < 0 ? 0 : val;
    event.target.value = val.toString();
    dispatch(setItemAmount(val));
  };

  return (
    <>
      <UsefulControls infoVisible={infoVisible} setInfoVisible={setInfoVisible} />
      <div className="inventory-control">
        <div className="inventory-control-wrapper">
          <input
            className="inventory-control-button inventory-control-input"
            type="number"
            defaultValue={itemAmount}
            onChange={inputHandler}
            min={0}
          />

        </div>
      </div>
    </>
  );
};

export default InventoryControl;


/*const [, use] = useDrop<DragSource, void, any>(() => ({
  accept: 'SLOT',
  drop: (source) => {
    source.inventory === 'player' && onUse(source.item);
  },
}));

const [, give] = useDrop<DragSource, void, any>(() => ({
  accept: 'SLOT',
  drop: (source) => {
    source.inventory === 'player' && onGive(source.item);
  },
})); */