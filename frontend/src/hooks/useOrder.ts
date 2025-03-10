import { useCreate, useCustomMutation, BaseRecord, HttpError, CreateResponse, CustomResponse } from "@refinedev/core";
import { OrderDto, ShippingInfoDto, VoucherDto } from "../../generated";
import { useCart } from "./useCart";
import { notification } from "antd";

interface CreateOrderPayload {
  shippingInfo: ShippingInfoDto;
  voucherCode?: string;
  paymentMethod: string;
}

interface OrderResponse extends BaseRecord {
  id: number;
  // Add other fields as needed
}

interface PaymentUrlResponse {
  paymentUrl: string;
}

interface CreateOrderResult {
  success: boolean;
  data?: OrderResponse;
  paymentUrl?: string;
  error?: string;
}

interface CartItem {
  skuId: number;
  quantity: number;
  price: number;
  discountRate?: number;
}

type CreateOrderMutation = (params: { resource: string; values: Partial<OrderDto>; successNotification: boolean }) => Promise<CreateResponse<OrderResponse>>;
type GetPaymentUrlMutation = (params: { url: string; method: string; values: any }) => Promise<CustomResponse<PaymentUrlResponse>>;

export const useOrder = () => {
  const { mutate: createOrderMutation } = useCreate<OrderDto, HttpError, OrderResponse>();
  const { mutate: getPaymentUrlMutation } = useCustomMutation<PaymentUrlResponse>();
  const { cartItems, getCartSummary, emptyCart } = useCart();

  const calculateItemCheckoutPrice = (item: CartItem): number => {
    const discount = item.discountRate || 0;
    return item.price * item.quantity * (1 - discount);
  };

  const handleCreateOrder = async (payload: CreateOrderPayload): Promise<CreateOrderResult> => {
    try {
      const summary = getCartSummary();
      
      const orderDto: Partial<OrderDto> = {
        orderDetails: cartItems.map(item => ({
          skuId: item.skuId,
          quantity: item.quantity,
          price: item.price,
          finalTotal: calculateItemCheckoutPrice(item),
        })),
        shippingInfo: payload.shippingInfo,
        voucher: payload.voucherCode ? { code: payload.voucherCode } : undefined,
        subTotal: summary.subtotal,
        finalTotal: summary.finalTotal,
      };

      const createOrderResponse = await (createOrderMutation as CreateOrderMutation)({
        resource: "orders",
        values: orderDto,
        successNotification: false,
      });

      if (!createOrderResponse?.data) {
        throw new Error("Failed to create order");
      }

      const orderId = createOrderResponse.data.id;

      // If payment method is not wallet, we need to redirect to payment gateway
      if (payload.paymentMethod !== "wallet") {
        // Use custom endpoint for payment gateway URL
        const paymentResponse = await (getPaymentUrlMutation as GetPaymentUrlMutation)({
          url: `orders/${orderId}/payment-url`,
          method: "post",
          values: {},
        });

        if (!paymentResponse?.data?.paymentUrl) {
          throw new Error("Failed to get payment URL");
        }
        
        return {
          success: true,
          data: createOrderResponse.data,
          paymentUrl: paymentResponse.data.paymentUrl,
        };
      }

      // Clear cart after successful order
      emptyCart();

      return {
        success: true,
        data: createOrderResponse.data,
      };
    } catch (error: any) {
      notification.error({
        message: "Failed to create order",
        description: error.message || "Something went wrong",
      });

      return {
        success: false,
        error: error.message,
      };
    }
  };

  return {
    createOrder: handleCreateOrder,
  };
}; 