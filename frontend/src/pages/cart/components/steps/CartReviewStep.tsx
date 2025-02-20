// components/steps/CartReviewStep.tsx
import React from "react";
import { Button, Typography } from "antd";
import CartItemsTable from "../CartItemsTable";
import { CartItem } from "../../../../store/features/cart/cartSlice";
import { StepBaseProps } from "../../../../types";

const { Title } = Typography;

interface CartReviewStepProps extends StepBaseProps {
  cartItems: CartItem[];
}

export const CartReviewStep: React.FC<CartReviewStepProps> = ({
  cartItems,
  onNext,
}) => {
  return (
    <div className="space-y-6">
      <Title level={4}>Review Cart Items</Title>
      <CartItemsTable items={cartItems} showOriginalPrice={true} />
      <div className="flex justify-end mt-4">
        <Button type="primary" onClick={onNext}>
          Proceed to Voucher
        </Button>
      </div>
    </div>
  );
};
