import React from "react";
import { useStepsForm, SaveButton } from "@refinedev/antd";
import { Steps, Typography, Empty, Button, Form, notification } from "antd";
import { useCart } from "../../hooks/useCart";
import CartItemsTable from "./components/CartItemsTable";
import OrderSummary from "./components/OrderSummary";
import { VoucherStep } from "./components/steps/VoucherStep";
import { ShippingStep } from "./components/steps/ShippingStep";
import { OrderConfirmationStep } from "./components/steps/OrderConfirmationStep";
import { ShippingInfoDto, VoucherDto } from "../../../generated";
import { CartReviewStep } from "./components/steps/CartReviewStep";

const { Title } = Typography;
const { Step } = Steps;

interface CheckoutFormData {
  voucherCode?: string;
  shippingInfo: ShippingInfoDto;
}

const CartPage: React.FC = () => {
  const { cartItems, updateVoucher, updateShippingInfo, getCartSummary } =
    useCart();

  const [form] = Form.useForm<CheckoutFormData>();

  const {
    current,
    gotoStep,
    stepsProps,
    formProps,
    saveButtonProps,
    onFinish,
  } = useStepsForm<CheckoutFormData>({
    form,
    action: "create",
    resource: "orders",
    redirect: false,
    onMutationSuccess: () => {
      notification.success({
        message: "Order placed successfully",
        description: "Your order has been placed and is being processed",
      });
    },
    onMutationError: () => {
      notification.error({
        message: "Error placing order",
        description: "There was an error processing your order",
      });
    },
  });

  const cartSummary = getCartSummary();

  const handleStepSubmit = async (step: number) => {
    try {
      await form.validateFields();
      gotoStep(step);
    } catch (error) {
      // Form validation error
    }
  };

  const handleVoucherUpdate = async (voucher: VoucherDto) => {
    try {
      await updateVoucher(voucher);
      notification.success({
        message: "Voucher applied successfully",
      });
    } catch (error) {
      notification.error({
        message: "Error applying voucher",
      });
    }
  };

  const handleShippingUpdate = async (values: ShippingInfoDto) => {
    try {
      await updateShippingInfo(values);
    } catch (error) {
      notification.error({
        message: "Error updating shipping information",
      });
    }
  };

  if (cartItems.length === 0) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Empty
          description={
            <span className="text-gray-600">Your cart is empty</span>
          }
          className="my-8"
        />
        <div className="text-center">
          <Button
            type="primary"
            size="large"
            href="/products"
            className="min-w-[200px]"
          >
            Continue Shopping
          </Button>
        </div>
      </div>
    );
  }

  const steps = [
    {
      title: "Cart Review",
      content: (
        <CartReviewStep
          cartItems={cartItems}
          onNext={() => handleStepSubmit(current + 1)}
        />
      ),
    },
    {
      title: "Voucher",
      content: (
        <VoucherStep
          form={form}
          onVoucherUpdate={handleVoucherUpdate}
          onPrevious={() => gotoStep(current - 1)}
          onNext={() => handleStepSubmit(current + 1)}
        />
      ),
    },
    {
      title: "Shipping",
      content: (
        <ShippingStep
          form={form}
          onShippingUpdate={handleShippingUpdate}
          onPrevious={() => gotoStep(current - 1)}
          onNext={() => handleStepSubmit(current + 1)}
        />
      ),
    },
    {
      title: "Confirm Order",
      content: (
        <OrderConfirmationStep
          cartSummary={cartSummary}
          onPrevious={() => gotoStep(current - 1)}
          saveButtonProps={saveButtonProps}
        />
      ),
    },
  ];

  return (
    <div className="container mx-auto px-4 py-8">
      <Title level={2} className="mb-8">
        Checkout Process
      </Title>

      <Steps {...stepsProps} className="mb-8">
        {steps.map((step) => (
          <Step key={step.title} title={step.title} />
        ))}
      </Steps>

      <Form
        {...formProps}
        layout="vertical"
        className="max-w-4xl mx-auto"
        onFinish={onFinish}
      >
        {steps[current].content}
      </Form>
    </div>
  );
};

export default CartPage;
