import { configureStore } from '@reduxjs/toolkit';
import cartReducer from './features/cart/cartSlice';
import authReducer from './auth';

export const store = configureStore({
  reducer: {
    cart: cartReducer,
    auth: authReducer
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