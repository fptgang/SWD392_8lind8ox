// components/steps/CartReviewStep.tsx
import React from "react";
import { Button, Typography, Divider, Alert } from "antd";
import CartItemsTable from "../CartItemsTable";
import { CartItem } from "../../../../store/features/cart/cartSlice";
import { StepBaseProps } from "../../types";

const { Title } = Typography;

interface CartReviewStepProps extends StepBaseProps {
  cartItems: CartItem[];
  invalidItemsFound?: boolean;
  onRemoveInvalidItems?: () => void;
}

export const CartReviewStep: React.FC<CartReviewStepProps> = ({
  cartItems,
  onNext,
  invalidItemsFound,
  onRemoveInvalidItems,
}) => {
  return (
    <div className="space-y-6">
      <Title level={4}>Your Shopping Cart</Title>
      
      {invalidItemsFound && (
        <Alert
          type="warning"
          showIcon
          message="Invalid Items Detected"
          description="Some items in your cart are invalid and cannot be processed. Please remove them before continuing."
          className="mb-4"
          action={
            <Button type="primary" danger onClick={onRemoveInvalidItems}>
              Remove Invalid Items
            </Button>
          }
        />
      )}
      
      <CartItemsTable items={cartItems} showOriginalPrice={true} />
      <div className="flex justify-end mt-6">
        <Button 
          type="primary" 
          onClick={onNext} 
          size="large"
          disabled={invalidItemsFound}
        >
          Proceed to Checkout
        </Button>
      </div>
    </div>
  );
};
