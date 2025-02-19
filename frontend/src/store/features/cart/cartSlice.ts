import { createSlice, PayloadAction } from "@reduxjs/toolkit";

// Type definitions based on DTOs
export interface CartItem {
  skuId: number;
  name: string;
  price: number;
  quantity: number;
  originalPrice: number;
  checkoutPrice: number;
  stock: number;
  imageUrl: string;
  blindBoxId?: number;
  promotionalCampaignId?: number;
}

export interface ShippingInfo {
  shippingInfoId?: number;
  address: string;
  ward: string;
  district: string;
  city: string;
  name: string;
  phoneNumber: string;
}

export interface Voucher {
  voucherId?: number;
  code: string;
  discountRate: number;
  limitAmount: number;
  isUsed?: boolean;
}

interface CartState {
  items: CartItem[];
  total: number;
  originalTotal: number;
  loading: boolean;
  error: string | null;
  accountId: number | null;
  voucher?: Voucher;
  shippingInfo?: ShippingInfo;
}

const CART_STORAGE_KEY = "cart";

const loadCartFromStorage = (): CartItem[] => {
  try {
    const storedCart = localStorage.getItem(CART_STORAGE_KEY);
    return storedCart ? JSON.parse(storedCart) : [];
  } catch (error) {
    console.error("Error loading cart from storage:", error);
    return [];
  }
};

const calculateTotals = (items: CartItem[]) => {
  return items.reduce(
    (acc, item) => ({
      total: acc.total + item.checkoutPrice * item.quantity,
      originalTotal: acc.originalTotal + item.originalPrice * item.quantity,
    }),
    { total: 0, originalTotal: 0 }
  );
};

const saveCartToStorage = (items: CartItem[]) => {
  try {
    localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(items));
  } catch (error) {
    console.error("Error saving cart to storage:", error);
  }
};

const initialState: CartState = {
  items: loadCartFromStorage(),
  ...calculateTotals(loadCartFromStorage()),
  loading: false,
  error: null,
  accountId: null,
};

const cartSlice = createSlice({
  name: "cart",
  initialState,
  reducers: {
    addItem: (state, action: PayloadAction<Omit<CartItem, "quantity">>) => {
      const existingItemIndex = state.items.findIndex(
        (item) => item.skuId === action.payload.skuId
      );

      if (existingItemIndex > -1) {
        const item = state.items[existingItemIndex];
        if (item.quantity < item.stock) {
          item.quantity += 1;
        }
      } else {
        state.items.push({ ...action.payload, quantity: 1 });
      }

      const totals = calculateTotals(state.items);
      state.total = totals.total;
      state.originalTotal = totals.originalTotal;
      saveCartToStorage(state.items);
    },

    updateQuantity: (
      state,
      action: PayloadAction<{ skuId: number; quantity: number }>
    ) => {
      const { skuId, quantity } = action.payload;
      if (quantity < 1) return;

      const itemIndex = state.items.findIndex((item) => item.skuId === skuId);
      if (itemIndex > -1) {
        const item = state.items[itemIndex];
        if (quantity <= item.stock) {
          item.quantity = quantity;
          const totals = calculateTotals(state.items);
          state.total = totals.total;
          state.originalTotal = totals.originalTotal;
          saveCartToStorage(state.items);
        }
      }
    },

    removeItem: (state, action: PayloadAction<number>) => {
      state.items = state.items.filter((item) => item.skuId !== action.payload);
      const totals = calculateTotals(state.items);
      state.total = totals.total;
      state.originalTotal = totals.originalTotal;
      saveCartToStorage(state.items);
    },

    clearCart: (state) => {
      state.items = [];
      state.total = 0;
      state.originalTotal = 0;
      state.voucher = undefined;
      state.shippingInfo = undefined;
      localStorage.removeItem(CART_STORAGE_KEY);
    },

    setVoucher: (state, action: PayloadAction<Voucher | undefined>) => {
      state.voucher = action.payload;
    },

    setShippingInfo: (state, action: PayloadAction<ShippingInfo>) => {
      state.shippingInfo = action.payload;
    },

    setAccountId: (state, action: PayloadAction<number | null>) => {
      state.accountId = action.payload;
    },

    setLoading: (state, action: PayloadAction<boolean>) => {
      state.loading = action.payload;
    },

    setError: (state, action: PayloadAction<string | null>) => {
      state.error = action.payload;
    },
  },
});

export const {
  addItem,
  updateQuantity,
  removeItem,
  clearCart,
  setVoucher,
  setShippingInfo,
  setAccountId,
  setLoading,
  setError,
} = cartSlice.actions;

export default cartSlice.reducer;
