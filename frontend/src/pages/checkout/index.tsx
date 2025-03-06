import React, { useEffect, useState } from "react";
import { useGetIdentity, useCreate, HttpError, useOne } from "@refinedev/core";
import {
  Card,
  Form,
  Input,
  Button,
  Radio,
  Typography,
  Space,
  Divider,
  message,
  Alert,
  Spin,
} from "antd";
import { useNavigate } from "react-router";
import { useCart } from "../../hooks/useCart";
import {
  AccountDto,
  OrderDto,
  TransactionDto,
  PromotionalCampaignDto,
  TransactionDtoPaymentMethodEnum,
  ShippingInfoDto,
} from "../../../generated";
import { formatCurrency } from "../../utils/currency-formatter";
import { CheckoutPaymentMethod } from "./components/CheckoutPaymentMethod";
import { CheckoutPromoCode } from "./components/CheckoutPromoCode";
import { useCheckoutSubmit } from "./hooks/useCheckoutSubmit";
import { CheckoutOrderSummary } from "./components/CheckoutOrderSummary";

const { Title, Text } = Typography;

const CheckoutPage: React.FC = () => {
  const [form] = Form.useForm();
  const navigate = useNavigate();
  const { cartItems, total, removeInvalidItems } = useCart();
  const { data: identity } = useGetIdentity<AccountDto>();
  const [paymentMethod, setPaymentMethod] =
    React.useState<TransactionDtoPaymentMethodEnum>(
      TransactionDtoPaymentMethodEnum.Paypal
    );
  const [promotionalCampaignId, setPromotionalCampaignId] =
    React.useState<number>();
  const [discount, setDiscount] = React.useState<number>(0);
  const [invalidItems, setInvalidItems] = useState<boolean>(false);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);
  const [shippingInfo, setShippingInfo] = useState<ShippingInfoDto | null>(null);
  const me = useGetIdentity<AccountDto>();
  const { mutateAsync: validatePromoCode } = useCreate();
  
  // Get shipping info for the current user
  const { data: shippingInfoData, isLoading: isLoadingShippingInfo } = useOne<ShippingInfoDto[]>({
    resource: "shipping-infos",
    queryOptions: {
      enabled: !!me.data?.accountId,
    },
    meta: {
      // Use the API filter to get only this user's shipping infos
      filter: [
        {
          field: "account.accountId",
          operator: "eq",
          value: me.data?.accountId,
        },
      ],
    },
  });
  
  // Use the first shipping info if available
  useEffect(() => {
    if (shippingInfoData?.data && Array.isArray(shippingInfoData.data) && shippingInfoData.data.length > 0) {
      setShippingInfo(shippingInfoData.data[0]);
    }
  }, [shippingInfoData]);
  
  // Validate cart items
  useEffect(() => {
    // Check if any cart items have null or invalid skuIds
    const hasInvalidItems = cartItems.some(item => !item.skuId || typeof item.skuId !== 'number');
    setInvalidItems(hasInvalidItems);
  }, [cartItems]);
  
  // Create a checkout submit handler
  const { handleSubmit } = useCheckoutSubmit({
    paymentMethod,
    promotionalCampaignId,
    total: total - discount, // Apply discount to total
    accountId: me.data?.accountId || 0,
    shippingInfoId: shippingInfo?.shippingInfoId || 0,
    cartItems,
    onSuccess: () => {
      setIsSubmitting(false);
      message.success("Order placed successfully!");
      navigate("/orders");
    },
    onError: (error: HttpError) => {
      setIsSubmitting(false);
      message.error(error?.message || "Failed to place order");
    },
  });

  // Redirect if cart is empty
  React.useEffect(() => {
    if (cartItems.length === 0) {
      navigate("/cart");
    }
  }, [cartItems, navigate]);

  if (cartItems.length === 0) {
    return null;
  }

  const handlePromoValidate = async (code: string) => {
    try {
      const response = await validatePromoCode({
        resource: "promotional-campaigns",
        values: { promoCode: code },
      });
      
      if (response && response.data) {
        const campaign = response.data as PromotionalCampaignDto;
        if (campaign?.campaignId) {
          setPromotionalCampaignId(campaign.campaignId);
          setDiscount(total * (campaign.discountRate || 0));
          return true;
        }
      }
      return false;
    } catch (error) {
      return false;
    }
  };

  const handlePlaceOrder = async () => {
    if (invalidItems) {
      message.error("Please remove invalid items before placing your order");
      return;
    }
    
    if (!shippingInfo?.shippingInfoId) {
      message.error("Shipping information is required");
      return;
    }
    
    setIsSubmitting(true);
    
    try {
      await handleSubmit();
    } catch (error) {
      setIsSubmitting(false);
      message.error("Failed to place order");
    }
  };

  // Loading state while fetching shipping info
  if (isLoadingShippingInfo) {
    return (
      <div className="flex justify-center items-center min-h-[60vh]">
        <Spin size="large" tip="Loading shipping information..." />
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto p-6">
      <Title level={2}>Checkout</Title>
      
      {invalidItems && (
        <Alert
          type="error"
          showIcon
          className="mb-4"
          message="Invalid Items Detected"
          description={
            <div>
              <Text>Some items in your cart are invalid and cannot be processed.</Text>
              <div className="mt-2 space-x-4">
                <Button 
                  onClick={removeInvalidItems}
                  type="primary"
                >
                  Remove Invalid Items
                </Button>
                <Button 
                  type="link" 
                  onClick={() => navigate("/cart")}
                  className="p-0"
                >
                  Return to cart
                </Button>
              </div>
            </div>
          }
        />
      )}

      <Space direction="vertical" size="large" className="w-full">
        <CheckoutOrderSummary
          cartItems={cartItems}
          total={total}
          discount={discount}
        />

        <CheckoutPaymentMethod
          paymentMethod={paymentMethod}
          onPaymentMethodChange={setPaymentMethod}
          walletBalance={identity?.balance ?? 0}
          total={total}
          discount={discount}
        />

        <CheckoutPromoCode
          onValidate={handlePromoValidate}
          setDiscount={setDiscount}
        />

        <Button
          type="primary"
          size="large"
          block
          onClick={handlePlaceOrder}
          loading={isSubmitting}
          disabled={invalidItems || !shippingInfo?.shippingInfoId}
          className="mt-4"
        >
          Place Order
        </Button>
        
        {!shippingInfo?.shippingInfoId && (
          <Alert
            type="warning"
            showIcon
            message="Shipping Information Required"
            description={
              <div>
                <p>You need to add shipping information before placing an order.</p>
                <Button 
                  type="primary" 
                  onClick={() => navigate("/cart?addShippingInfo=true")}
                  className="mt-2"
                >
                  Add Shipping Information
                </Button>
              </div>
            }
            className="mt-4"
          />
        )}
      </Space>

      <Form form={form} hidden />
    </div>
  );
};

export default CheckoutPage;
