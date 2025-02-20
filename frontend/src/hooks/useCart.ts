import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../store";
import {
  addItem,
  removeItem,
  clearCart,
  updateQuantity,
  setShippingInfo,
  setVoucher,
  CartItem,
  ShippingInfo,
  Voucher,
} from "../store/features/cart/cartSlice";
import { ShippingInfoDto, VoucherDto } from "../../generated";

export const useCart = () => {
  const dispatch = useDispatch();
  const {
    items: cartItems,
    total,
    originalTotal,
    loading,
    error,
    voucher,
    shippingInfo,
    accountId,
  } = useSelector((state: RootState) => state.cart);

  /**
   * Add item to cart
   * @param item Cart item without quantity
   */
  const addToCart = (item: Omit<CartItem, "quantity">) => {
    try {
      if (!item.skuId || !item.price || !item.stock) {
        throw new Error("Invalid item data");
      }
      dispatch(addItem(item));
    } catch (error) {
      console.error("Error adding item to cart:", error);
    }
  };

  /**
   * Update item quantity in cart
   * @param skuId SKU ID of the item
   * @param quantity New quantity
   */
  const updateItemQuantity = (skuId: number, quantity: number) => {
    try {
      const item = cartItems.find((item) => item.skuId === skuId);
      if (!item) {
        throw new Error("Item not found in cart");
      }

      if (quantity > 0 && quantity <= item.stock) {
        dispatch(updateQuantity({ skuId, quantity }));
      } else {
        throw new Error("Invalid quantity");
      }
    } catch (error) {
      console.error("Error updating quantity:", error);
    }
  };

  /**
   * Remove item from cart
   * @param skuId SKU ID of the item to remove
   */
  const removeFromCart = (skuId: number) => {
    try {
      if (!skuId) {
        throw new Error("Invalid SKU ID");
      }
      dispatch(removeItem(skuId));
    } catch (error) {
      console.error("Error removing item from cart:", error);
    }
  };

  /**
   * Clear entire cart
   */
  const emptyCart = () => {
    try {
      dispatch(clearCart());
    } catch (error) {
      console.error("Error clearing cart:", error);
    }
  };

  /**
   * Update shipping information
   * @param info Shipping information DTO
   */
  const updateShippingInfo = (info: ShippingInfoDto) => {
    try {
      if (!info.address || !info.city || !info.name || !info.phoneNumber) {
        throw new Error("Missing required shipping information");
      }

      const shippingInfo: ShippingInfo = {
        address: info.address,
        ward: info.ward || "",
        district: info.district || "",
        city: info.city,
        name: info.name,
        phoneNumber: info.phoneNumber,
      };

      dispatch(setShippingInfo(shippingInfo));
    } catch (error) {
      console.error("Error updating shipping info:", error);
    }
  };

  /**
   * Update voucher information
   * @param voucherInfo Voucher DTO
   */
  const updateVoucher = (voucherInfo: VoucherDto | undefined) => {
    try {
      if (voucherInfo) {
        const voucher: Voucher = {
          code: voucherInfo.code || "",
          discountRate: voucherInfo.discountRate || 0,
          limitAmount: voucherInfo.limitAmount || 0,
          isUsed: voucherInfo.isUsed,
        };
        dispatch(setVoucher(voucher));
      } else {
        dispatch(setVoucher(undefined));
      }
    } catch (error) {
      console.error("Error updating voucher:", error);
    }
  };

  /**
   * Calculate cart summary
   */
  const getCartSummary = () => {
    const itemCount = cartItems.reduce((sum, item) => sum + item.quantity, 0);
    const savings = originalTotal - total;
    const voucherDiscount = voucher
      ? Math.min(total * (voucher.discountRate / 100), voucher.limitAmount)
      : 0;
    const finalTotal = total - voucherDiscount;

    return {
      itemCount,
      subtotal: total,
      savings,
      voucherDiscount,
      finalTotal,
    };
  };

  return {
    // State
    cartItems,
    total,
    originalTotal,
    loading,
    error,
    voucher,
    shippingInfo,
    accountId,

    // Actions
    addToCart,
    updateItemQuantity,
    removeFromCart,
    emptyCart,
    updateShippingInfo,
    updateVoucher,

    // Utilities
    getCartSummary,
  };
};

export default useCart;
