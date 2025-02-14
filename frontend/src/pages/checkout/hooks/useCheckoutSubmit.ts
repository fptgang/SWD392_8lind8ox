// hooks/useCheckoutSubmit.ts
import { useCreate, HttpError } from "@refinedev/core";

import { CartItem } from "../../../store/features/cart/cartSlice";
import {
  OrderDetailDto,
  OrderDto,
  OrderDtoStatusEnum,
  TransactionDto,
  TransactionDtoPaymentMethodEnum,
  TransactionDtoTypeEnum,
} from "../../../../generated";

interface UseCheckoutSubmitParams {
  paymentMethod: TransactionDtoPaymentMethodEnum;
  promotionalCampaignId?: number;
  total: number;
  discount: number;
  cartItems: CartItem[];
  onSuccess: () => void;
  onError: (error: HttpError) => void;
}

export const useCheckoutSubmit = ({
  paymentMethod,
  promotionalCampaignId,
  total,
  discount,
  cartItems,
  onSuccess,
  onError,
}: UseCheckoutSubmitParams) => {
  const { mutate, isLoading } = useCreate();

  const handleSubmit = async () => {
    try {
      // 1. Create order
      const orderDetails: Partial<OrderDetailDto>[] = cartItems.map((item) => ({
        skuId: parseInt(item.id),
        originalPrice: item.price,
        checkoutPrice: item.price * (item.quantity || 1),
        promotionalCampaignId: promotionalCampaignId,
      }));

      const orderData: Partial<OrderDto> = {
        status: OrderDtoStatusEnum.Pending,
        totalPrice: total - discount,
        orderDetails: orderDetails,
      };

      const orderResponse = await mutate({
        resource: "orders",
        values: orderData,
      });

      if (orderResponse.data) {
        // 2. Create transaction
        const transactionData: Partial<TransactionDto> = {
          type: TransactionDtoTypeEnum.Order,
          paymentMethod: paymentMethod,
          amount: total - discount,
          orderId: orderResponse.data.orderId,
        };

        await mutate({
          resource: "transactions",
          values: transactionData,
        });

        onSuccess();
      }
    } catch (error) {
      onError(error as HttpError);
    }
  };

  return {
    handleSubmit,
    isLoading,
  };
};
