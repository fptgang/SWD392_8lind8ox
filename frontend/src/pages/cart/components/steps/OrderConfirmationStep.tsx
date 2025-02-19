// components/steps/OrderConfirmationStep.tsx
import React from "react";
import { Button, Typography, Descriptions, Space } from "antd";
import { SaveButtonProps } from "@refinedev/antd";
import { CartSummary, StepBaseProps } from "../../types";
import OrderSummary from "../OrderSummary";

const { Title } = Typography;

interface OrderConfirmationStepProps extends StepBaseProps {
  cartSummary: CartSummary;
  saveButtonProps: SaveButtonProps;
}

export const OrderConfirmationStep: React.FC<OrderConfirmationStepProps> = ({
  cartSummary,
  saveButtonProps,
  onPrevious,
}) => {
  const { itemCount, subtotal, savings, voucherDiscount, finalTotal } =
    cartSummary;

  return (
    <div className="space-y-6">
      <Title level={4}>Order Summary</Title>

      <OrderSummary
        subtotal={subtotal}
        total={finalTotal}
        discount={savings}
        voucherDiscount={voucherDiscount}
        itemCount={itemCount}
      />

      <div className="mt-8 bg-gray-50 p-4 rounded-lg">
        <Descriptions title="Important Notes" column={1}>
          <Descriptions.Item label="Delivery Time">
            3-5 business days
          </Descriptions.Item>
          <Descriptions.Item label="Return Policy">
            7 days return policy for unopened items
          </Descriptions.Item>
          <Descriptions.Item label="Payment">
            Secure payment processing
          </Descriptions.Item>
        </Descriptions>
      </div>

      <Space className="flex justify-between mt-8">
        <Button onClick={onPrevious}>Back to Shipping</Button>
        <Button type="primary" {...saveButtonProps} className="min-w-[150px]">
          Place Order
        </Button>
      </Space>
    </div>
  );
};
