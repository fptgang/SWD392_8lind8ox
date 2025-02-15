import React from "react";
import { useGetIdentity, useCreate, HttpError } from "@refinedev/core";
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
} from "antd";
import { useNavigate } from "react-router";
import { useCart } from "../../hooks/useCart";
import {
  AccountDto,
  OrderDto,
  TransactionDto,
  PromotionalCampaignDto,
  TransactionDtoPaymentMethodEnum,
} from "../../../generated";
import { formatCurrency } from "../../utils/currency-formatter";
import { CheckoutOrderSummary } from "./components/CheckoutOrderSummary";
import { CheckoutPaymentMethod } from "./components/CheckoutPaymentMethod";
import { CheckoutPromoCode } from "./components/CheckoutPromoCode";
import { useCheckoutSubmit } from "./hooks/useCheckoutSubmit";

const { Title } = Typography;

const CheckoutPage: React.FC = () => {
  const [form] = Form.useForm();
  const navigate = useNavigate();
  const { cartItems, total, clearCart } = useCart();
  const { data: identity } = useGetIdentity<AccountDto>();
  const [paymentMethod, setPaymentMethod] =
    React.useState<TransactionDtoPaymentMethodEnum>(
      TransactionDtoPaymentMethodEnum.Paypal
    );
  const [promotionalCampaignId, setPromotionalCampaignId] =
    React.useState<number>();
  const [discount, setDiscount] = React.useState<number>(0);

  const { mutate: validatePromoCode } = useCreate();
  const { handleSubmit, isLoading } = useCheckoutSubmit({
    paymentMethod,
    promotionalCampaignId,
    total,
    discount,
    cartItems,
    onSuccess: () => {
      clearCart();
      message.success("Order placed successfully!");
      navigate("/orders");
    },
    onError: (error: HttpError) => {
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
      const campaign = response.data as PromotionalCampaignDto;
      if (campaign?.campaignId) {
        setPromotionalCampaignId(campaign.campaignId);
        setDiscount(total * (campaign.discountRate || 0));
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  };

  return (
    <div className="max-w-4xl mx-auto p-6">
      <Title level={2}>Checkout</Title>

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
          onClick={handleSubmit}
          loading={isLoading}
          className="mt-4"
        >
          Place Order
        </Button>
      </Space>

      <Form form={form} hidden />
    </div>
  );
};

export default CheckoutPage;
