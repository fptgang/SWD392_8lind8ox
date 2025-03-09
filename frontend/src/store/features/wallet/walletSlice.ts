import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { notification } from 'antd';
import { RootState } from '../../index';

interface WalletState {
  balance: number;
  loading: boolean;
  error: string | null;
}

const initialState: WalletState = {
  balance: 0,
  loading: false,
  error: null,
};

// Create async thunk for fetching wallet balance
export const fetchWalletBalance = createAsyncThunk<
  number,
  void,
  { state: RootState; rejectValue: string }
>('wallet/fetchBalance', async (_, { rejectWithValue }) => {
  try {
    // Mock API call - replace with actual API call
    const response = await fetch('/api/wallet/balance');
    
    if (!response.ok) {
      throw new Error('Failed to fetch wallet balance');
    }
    
    const data = await response.json();
    return data.balance;
  } catch (error: any) {
    notification.error({
      message: 'Failed to fetch wallet balance',
      description: error.message || 'Something went wrong',
    });
    return rejectWithValue(error.message || 'Failed to fetch wallet balance');
  }
});

// Create async thunk for topping up wallet
export const topUpWallet = createAsyncThunk<
  number,
  number,
  { state: RootState; rejectValue: string }
>('wallet/topUp', async (amount, { rejectWithValue }) => {
  try {
    if (amount <= 0) {
      throw new Error('Amount must be greater than zero');
    }
    
    // Mock API call - replace with actual API call
    const response = await fetch('/api/wallet/topup', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ amount }),
    });
    
    if (!response.ok) {
      throw new Error('Failed to top up wallet');
    }
    
    const data = await response.json();
    notification.success({
      message: 'Wallet topped up successfully',
      description: `Added ${amount} to your wallet`,
    });
    
    return data.newBalance;
  } catch (error: any) {
    notification.error({
      message: 'Failed to top up wallet',
      description: error.message || 'Something went wrong',
    });
    return rejectWithValue(error.message || 'Failed to top up wallet');
  }
});

const walletSlice = createSlice({
  name: 'wallet',
  initialState,
  reducers: {
    setBalance: (state, action: PayloadAction<number>) => {
      state.balance = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      // Handle fetchWalletBalance
      .addCase(fetchWalletBalance.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchWalletBalance.fulfilled, (state, action) => {
        state.loading = false;
        state.balance = action.payload;
      })
      .addCase(fetchWalletBalance.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload || 'Failed to fetch wallet balance';
      })
      
      // Handle topUpWallet
      .addCase(topUpWallet.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(topUpWallet.fulfilled, (state, action) => {
        state.loading = false;
        state.balance = action.payload;
      })
      .addCase(topUpWallet.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload || 'Failed to top up wallet';
      });
  },
});

export const { setBalance } = walletSlice.actions;
export default walletSlice.reducer; 