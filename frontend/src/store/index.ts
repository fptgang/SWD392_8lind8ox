import { configureStore } from '@reduxjs/toolkit';
import cartReducer from './features/cart/cartSlice';
import authReducer from './auth';
import checkoutReducer from './features/checkout/checkoutSlice';
import orderReducer from './features/order/orderSlice';
import walletReducer from './features/wallet/walletSlice';
import setReducer from './features/set/setSlice';

export const store = configureStore({
  reducer: {
    cart: cartReducer,
    auth: authReducer,
    checkout: checkoutReducer,
    order: orderReducer,
    wallet: walletReducer,
    set: setReducer
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: ['auth/setAuthenticatedAccount'],
        ignoredPaths: [
          'auth.account.verifiedAt',
          'auth.account.createdAt',
          'auth.account.updatedAt'
        ],
      },
    }),
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;