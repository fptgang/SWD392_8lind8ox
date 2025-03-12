import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import { notification } from 'antd';
import { OrderDto, ShippingInfoDto } from '../../../../generated';
import { RootState } from '../../index';
import { clearCart } from '../cart/cartSlice';

interface OrderItem {
  skuId: number;
  quantity: number;
  price: number;
  finalTotal: number;
}

interface CreateOrderPayload {
  shippingInfo: ShippingInfoDto;
  voucherCode?: string;
  paymentMethod: string;
}

interface OrderResponse {
  id: number;
  subTotal: number;
  finalTotal: number;
  createdAt: string;
  status: string;
}

interface PaymentUrlResponse {
  paymentUrl: string;
}

interface OrderState {
  currentOrder: OrderResponse | null;
  paymentUrl: string | null;
  loading: boolean;
  error: string | null;
}

const initialState: OrderState = {
  currentOrder: null,
  paymentUrl: null,
  loading: false,
  error: null,
};

// Create async thunk for order creation
export const createOrder = createAsyncThunk<
  { order: OrderResponse; paymentUrl?: string },
  CreateOrderPayload,
  { state: RootState; rejectValue: string }
>('order/create', async (payload, { getState, dispatch, rejectWithValue }) => {
  try {
    const state = getState();
    const { items } = state.cart;
    
    // Calculate totals from cart state
    const originalTotal = items.reduce(
      (sum, item) => sum + (item.subTotal * item.quantity), 
      0
    );
    
    const checkoutTotal = items.reduce(
      (sum, item) => sum + (item.finalTotal * item.quantity), 
      0
    );
    
    const voucherDiscount = state.cart.voucher 
      ? Math.min(
          checkoutTotal * (state.cart.voucher.discountRate / 100), 
          state.cart.voucher.limitAmount
        ) 
      : 0;
    
    const finalTotal = checkoutTotal - voucherDiscount;
    
    // Create order items from cart items
    const orderItems: OrderItem[] = items.map(item => ({
      skuId: item.skuId,
      quantity: item.quantity,
      price: item.subTotal,
      finalTotal: item.finalTotal,
    }));
    
    // Construct order payload
    const orderDto: Partial<OrderDto> = {
      orderDetails: orderItems,
      shippingInfo: payload.shippingInfo,
      voucher: payload.voucherCode ? { code: payload.voucherCode } : undefined,
      subTotal: originalTotal,
      finalTotal: finalTotal,
    };
    
    // Mock API call for createOrder - replace with actual API call
    const response = await fetch('/api/orders', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(orderDto),
    });
    
    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.message || 'Failed to create order');
    }
    
    const orderData: OrderResponse = await response.json();
    
    // If payment method is not wallet, get payment URL
    let paymentUrl: string | undefined;
    if (payload.paymentMethod !== 'WALLET') {
      // Mock API call for payment URL - replace with actual API call
      const paymentResponse = await fetch(`/api/orders/${orderData.id}/payment-url`, {
        method: 'POST',
      });
      
      if (!paymentResponse.ok) {
        throw new Error('Failed to get payment URL');
      }
      
      const paymentData: PaymentUrlResponse = await paymentResponse.json();
      paymentUrl = paymentData.paymentUrl;
    } else {
      // For wallet payments, clear cart immediately
      dispatch(clearCart());
    }
    
    return {
      order: orderData,
      paymentUrl,
    };
  } catch (error: any) {
    notification.error({
      message: 'Failed to create order',
      description: error.message || 'Something went wrong',
    });
    return rejectWithValue(error.message || 'Failed to create order');
  }
});

const orderSlice = createSlice({
  name: 'order',
  initialState,
  reducers: {
    resetOrder: (state) => {
      state.currentOrder = null;
      state.paymentUrl = null;
      state.loading = false;
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(createOrder.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(createOrder.fulfilled, (state, action) => {
        state.loading = false;
        state.currentOrder = action.payload.order;
        state.paymentUrl = action.payload.paymentUrl || null;
      })
      .addCase(createOrder.rejected, (state, action) => {
        state.loading = false;
        state.error = action.payload || 'Failed to create order';
      });
  },
});

export const { resetOrder } = orderSlice.actions;
export default orderSlice.reducer; 