import { useDispatch, useSelector } from "react-redux";
import {
  addItem,
  updateQuantity,
  removeItem,
  clearCart,
} from "../store/features/cart/cartSlice";
import { RootState } from "../store";

export const useCart = () => {
  const dispatch = useDispatch();
  const {
    items: cartItems,
    total,
    loading,
    error,
  } = useSelector((state: RootState) => state.cart);

  const addToCart = (item: {
    id: string;
    name: string;
    price: number;
    image: string;
  }) => {
    dispatch(addItem(item));
  };

  const updateItemQuantity = (id: string, quantity: number) => {
    dispatch(updateQuantity({ id, quantity }));
  };

  const removeFromCart = (id: string) => {
    dispatch(removeItem(id));
  };

  const emptyCart = () => {
    dispatch(clearCart());
  };

  return {
    cartItems,
    total,
    loading,
    error,
    addItem: addToCart,
    updateQuantity: updateItemQuantity,
    removeItem: removeFromCart,
    clearCart: emptyCart,
  };
};
