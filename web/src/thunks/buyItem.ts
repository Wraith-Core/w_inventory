import { createAsyncThunk } from '@reduxjs/toolkit';
import { fetchNui } from '../utils/fetchNui';

export const buyItem = createAsyncThunk(
  'inventory/buyItem',
  async (
    data: {
      fromSlot: number;
      fromType: string;
      toSlot: number;
      toType: string;
      count: number;
      /** The payment method when buying with the cash currency: cash or gold (the player's choice) */
      paymentCurrency?: 'cash' | 'gold';
    },
    { rejectWithValue }
  ) => {
    try {
      const response = await fetchNui<boolean>('buyItem', data);

      if (response === false) {
        return rejectWithValue(response);
      }
    } catch (error) {
      return rejectWithValue(false);
    }
  }
);
