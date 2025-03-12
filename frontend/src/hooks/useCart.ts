import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../store";
import {
  addItem,
  removeItem,
  clearCart,
  cleanInvalidItems,
  updateQuantity,
  setShippingInfo,
  setVoucher,
  CartItem,
  ShippingInfo,
  Voucher,
  setLoading,
  setError,
} from "../store/features/cart/cartSlice";
import { ShippingInfoDto, VoucherDto } from "../../generated";
import { useApiContext } from "../contexts/api-context";
import { useCreate, useOne } from "@refinedev/core";

interface PlaceOrderParams {
  shippingInfo: ShippingInfoDto;
  paymentMethod: string;
  voucherCode?: string;
}

export const useCart = () => {
  const dispatch = useDispatch();
  const apiContext = useApiContext();
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
      
      // This will now use the updated addItem reducer that considers slotId
      dispatch(addItem(item));
    } catch (error) {
      console.error("Error adding item to cart:", error);
    }
  };

  /**
   * Update item quantity in cart
   * @param skuId SKU ID of the item
   * @param slotId Slot ID of the item (optional)
   * @param quantity New quantity
   */
  const updateItemQuantity = (skuId: number, quantity: number, slotId?: number) => {
    try {
      const item = cartItems.find(item => 
        item.skuId === skuId && item.slotId === slotId
      );
      
      if (!item) {
        throw new Error("Item not found in cart");
      }

      if (quantity > 0 && quantity <= item.stock) {
        dispatch(updateQuantity({ skuId, slotId, quantity }));
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
   * @param slotId Slot ID of the item to remove (optional)
   */
  const removeFromCart = (skuId: number, slotId?: number) => {
    try {
      if (!skuId) {
        throw new Error("Invalid SKU ID");
      }
      dispatch(removeItem({ skuId, slotId }));
    } catch (error) {
      console.error("Error removing item from cart:", error);
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
   * Clean invalid items from the cart
   */
  const removeInvalidItems = () => {
    try {
      dispatch(cleanInvalidItems());
    } catch (error) {
      console.error("Error cleaning invalid items:", error);
    }
  };

  /**
   * Update shipping information
   * @param info Shipping information DTO
   */
  const updateShippingInfo = (infos: any) => {
    try {
      const info = infos.data as ShippingInfoDto;
      if (!info.address || !info.city || !info.name || !info.phoneNumber) {
        throw new Error("Missing required shipping information");
      }
      
      // Since we've validated the required fields, we can safely create a non-optional object
      const shippingInfo: ShippingInfo = {
        shippingInfoId: info.shippingInfoId || 0,
        address: info.address,
        ward: info.ward || '',
        district: info.district || '',
        city: info.city,
        name: info.name,
        phoneNumber: info.phoneNumber
      };

      dispatch(setShippingInfo(shippingInfo));
    } catch (error) {
      console.error("Error updating shipping info:", error);
    }
  };

  /**
   * Update voucher information
   * @param voucherInfo Voucher information or voucher code
   */
  const updateVoucher = (voucherInfo: VoucherDto | string) => {
    try {
      let voucher: Voucher;
      
      if (typeof voucherInfo === 'string') {
        // If a string is passed, assume it's a voucher code and create a default voucher
        voucher = {
          code: voucherInfo,
          discountRate: 10, // Default discount rate
          limitAmount: 50,  // Default limit amount
        };
      } else {
        // Otherwise use the voucher info directly
        voucher = {
          voucherId: voucherInfo.voucherId,
          code: voucherInfo.code || '',
          discountRate: voucherInfo.discountRate || 0,
          limitAmount: voucherInfo.limitAmount || 0,
          isUsed: voucherInfo.state === 'USED'
        };
      }

      dispatch(setVoucher(voucher));
      return voucher;
    } catch (error) {
      console.error("Error updating voucher:", error);
    }
  };

  /**
   * Place an order with the current cart items
   * @param params Order parameters including shipping and payment info
   */
  const placeOrder = async (params: PlaceOrderParams): Promise<void> => {
    if (cartItems.length === 0) {
      throw new Error("Cart is empty");
    }
    
    if (!params.shippingInfo || !params.paymentMethod) {
      throw new Error("Missing required order information");
    }
    
    dispatch(setLoading(true));
    dispatch(setError(null));
    
    try {
      const { finalTotal, voucherDiscount } = getCartSummary();
      
      // Construct order payload
      const orderPayload = {
        items: cartItems.map(item => ({
          skuId: item.skuId,
          quantity: item.quantity,
          price: item.finalTotal
        })),
        shippingInfo: params.shippingInfo,
        paymentMethod: params.paymentMethod,
        ...(params.voucherCode ? { voucherCode: params.voucherCode } : {}),
        total: finalTotal,
        discount: voucherDiscount
      };
      
      // Post order to API
      await apiContext.post('/orders', orderPayload);
      
      // If order was successful, clear the cart
      if (params.paymentMethod === 'wallet') {
        // For wallet payments, clear cart immediately as payment is already processed
        dispatch(clearCart());
      }
      
      // For external payments, cart will be cleared after successful payment callback
      
      return Promise.resolve();
    } catch (error: any) {
      const errorMessage = error?.response?.data?.message || "Failed to place order";
      dispatch(setError(errorMessage));
      return Promise.reject(new Error(errorMessage));
    } finally {
      dispatch(setLoading(false));
    }
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
    removeInvalidItems,
    updateShippingInfo,
    updateVoucher,
    placeOrder,

    // Utilities
    getCartSummary,
  };
};

export default useCart;
