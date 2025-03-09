import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { ShippingInfoDto } from '../../../../generated';

// Define the checkout step types
export enum CheckoutStep {
  CART_REVIEW = 0,
  VOUCHER = 1,
  SHIPPING_INFO = 2,
  PAYMENT_METHOD = 3,
  ORDER_CONFIRMATION = 4,
}

// Define the checkout form data type
export interface CheckoutFormData {
  voucherCode?: string;
  shippingInfo?: ShippingInfoDto;
  paymentMethod?: string;
}

// Define the checkout state
interface CheckoutState {
  currentStep: CheckoutStep;
  formData: CheckoutFormData;
  invalidItemsFound: boolean;
  loading: boolean;
  error: string | null;
}

// Initial state
const initialState: CheckoutState = {
  currentStep: CheckoutStep.CART_REVIEW,
  formData: {},
  invalidItemsFound: false,
  loading: false,
  error: null,
};

// Create the checkout slice
const checkoutSlice = createSlice({
  name: 'checkout',
  initialState,
  reducers: {
    setCurrentStep: (state, action: PayloadAction<CheckoutStep>) => {
      state.currentStep = action.payload;
    },
    
    updateFormData: (state, action: PayloadAction<Partial<CheckoutFormData>>) => {
      state.formData = {
        ...state.formData,
        ...action.payload,
      };
    },
    
    setInvalidItemsFound: (state, action: PayloadAction<boolean>) => {
      state.invalidItemsFound = action.payload;
    },
    
    setLoading: (state, action: PayloadAction<boolean>) => {
      state.loading = action.payload;
    },
    
    setError: (state, action: PayloadAction<string | null>) => {
      state.error = action.payload;
    },
    
    resetCheckout: (state) => {
      state.currentStep = CheckoutStep.CART_REVIEW;
      state.formData = {};
      state.loading = false;
      state.error = null;
    },
  },
});

// Export actions
export const { 
  setCurrentStep, 
  updateFormData, 
  setInvalidItemsFound, 
  setLoading, 
  setError,
  resetCheckout
} = checkoutSlice.actions;

// Export reducer
export default checkoutSlice.reducer; 