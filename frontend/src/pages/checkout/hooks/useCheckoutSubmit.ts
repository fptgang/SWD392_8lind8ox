// hooks/useCheckoutSubmit.ts
import { useCreate } from "@refinedev/core";
import { OrderDetailDto, OrderDto, ShippingInfoDto, TransactionDto, TransactionDtoPaymentMethodEnum, TransactionDtoTypeEnum } from "../../../../generated";
import { CartItem } from "../../../store/features/cart/cartSlice";
import { useCart } from "../../../hooks/useCart";

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
  const { mutateAsync: createOrder } = useCreate<OrderDto>();
  const { mutateAsync: createTransaction } = useCreate<TransactionDto>();
  const { mutateAsync: createShippingInfo } = useCreate<ShippingInfoDto>();
  const { shippingInfo } = useCart();

  const handleSubmit = async () => {
    try {
      // Validate cart items first
      if (!cartItems || cartItems.length === 0) {
        throw new Error("Cart is empty");
      }

      // Check if all items have valid skuId
      const invalidItems = cartItems.filter(item => !item.skuId || typeof item.skuId !== 'number');
      if (invalidItems.length > 0) {
        throw new Error("Some items in your cart are invalid. Please remove them and try again.");
      }

      // Ensure we have a valid shipping info ID
      let finalShippingInfoId = shippingInfoId;
      
      // If no shipping info ID is provided but we have shipping info in the cart,
      // create a new shipping info entry
      if (!finalShippingInfoId && shippingInfo) {
        try {
          const shippingResponse = await createShippingInfo({
            resource: "shipping-infos",
            values: {
              address: shippingInfo.address,
              city: shippingInfo.city,
              district: shippingInfo.district,
              ward: shippingInfo.ward,
              name: shippingInfo.name,
              phoneNumber: shippingInfo.phoneNumber,
              accountId: accountId
            },
          });
          
          if (shippingResponse && shippingResponse.data) {
            finalShippingInfoId = shippingResponse.data.shippingInfoId || 0;
          }
        } catch (error) {
          console.error("Error creating shipping info:", error);
          throw new Error("Failed to create shipping information");
        }
      }
      
      if (!finalShippingInfoId) {
        throw new Error("Shipping information is required");
      }

      // Create order details from cart items with valid skuIds according to API spec
      const orderDetails: Partial<OrderDetailDto>[] = cartItems.map((item) => ({
        // The skuId needs to be properly referenced according to API spec
        // We'll include it directly rather than as a StockKeepingUnitDto object
        skuId: item.skuId, 
        quantity: item.quantity || 1,
        originalPrice: item.originalPrice || item.price,
        checkoutPrice: item.checkoutPrice || item.price,
        // Include promotional campaign if applicable
        promotionalCampaignId: promotionalCampaignId,
      }));

      // Create order according to OrderDto structure
      const orderResponse = await createOrder({
        resource: "orders",
        values: {
          // Use accountId directly rather than as AccountDto object
          accountId,
          // Use shippingInfoId directly rather than as ShippingInfoDto object
          shippingInfoId: finalShippingInfoId,
          orderDetails,
          originalPrice: total,
          checkoutPrice: total,
        },
      });

      // After successful order creation, create the transaction
      if (orderResponse && orderResponse.data) {
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
      console.error("Error in checkout submission:", error);
      onError(error);
    }
  };

  return {
    handleSubmit,
  };  
};