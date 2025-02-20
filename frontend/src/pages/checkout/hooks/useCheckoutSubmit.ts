// hooks/useCheckoutSubmit.ts
import { useCreate } from "@refinedev/core";
import { OrderDetailDto, OrderDto, TransactionDto, TransactionDtoPaymentMethodEnum, TransactionDtoTypeEnum } from "../../../../generated";
import { CartItem } from "../../../store/features/cart/cartSlice";


interface UseCheckoutSubmitParams {
  paymentMethod: TransactionDtoPaymentMethodEnum;
  promotionalCampaignId?: number;
  total: number;
  cartItems: CartItem[];
  accountId: number;
  shippingInfoId: number;
  onSuccess: () => void;
  onError: (error: any) => void;
}

export const useCheckoutSubmit = ({
  paymentMethod,
  promotionalCampaignId,
  accountId,
  total,
  cartItems,
  shippingInfoId,
  onSuccess,
  onError,
}: UseCheckoutSubmitParams) => {
  const { mutate: createOrder } = useCreate<OrderDto>();
  const { mutate: createTransaction } = useCreate<TransactionDto>();

  const handleSubmit = async () => {
    try {
      // Create order details from cart items
      const orderDetails: Partial<OrderDetailDto>[] = cartItems.map((item) => ({
        skuId: parseInt(item.id),
        originalPrice: item.price,
        checkoutPrice: item.price,
        promotionalCampaignId,
      }));

      // Create order
      const orderResponse = await createOrder({
        resource: "orders",
        values: {
          accountId,
          shippingInfoId,
          orderDetails,
          originalPrice: total,
          checkoutPrice: total,
        },
      });

      if (orderResponse.data) {
        // Create transaction record
        await createTransaction({
          resource: "transactions",
          values: {
            accountId,
            type: TransactionDtoTypeEnum.Order,
            paymentMethod,
            amount: total,
            orderId: orderResponse.data.orderId,
            success: true,
          },
        });

        onSuccess();
      }
    } catch (error) {
      onError(error);
    }
  };

  return {
    handleSubmit,
  };  
};