// components/cart/OrderSummary.tsx
import React from "react";
import { Typography, Button, Divider, Tooltip } from "antd";
import { useGo } from "@refinedev/core";
import {
  ShoppingCartOutlined,
  QuestionCircleOutlined,
} from "@ant-design/icons";

const { Title, Text } = Typography;

interface OrderSummaryProps {
  subtotal: number;
  total: number;
  discount?: number;
  voucherDiscount?: number;
  itemCount: number;
  showCheckoutButton?: boolean;
}

const OrderSummary: React.FC<OrderSummaryProps> = ({
  subtotal,
  total,
  discount = 0,
  voucherDiscount = 0,
  itemCount,
  showCheckoutButton = true,
}) => {
  const go = useGo();

  const handleCheckout = () => {
    go({
      to: "/checkout",
    });
  };

  return (
    <div className="bg-white rounded-lg shadow-md p-6 sticky top-4">
      <div className="flex items-center justify-between mb-4">
        <Title level={4} className="!mb-0">
          Order Summary
        </Title>
        <Text className="text-gray-500">
          {itemCount} {itemCount === 1 ? "item" : "items"}
        </Text>
      </div>

      <div className="space-y-4">
        <div className="flex justify-between py-2">
          <span className="text-gray-600">Subtotal</span>
          <span className="font-medium">${subtotal.toFixed(2)}</span>
        </div>

        {discount > 0 && (
          <div className="flex justify-between py-2 text-green-600">
            <span className="flex items-center">
              Discount
              <Tooltip title="Promotional discount applied">
                <QuestionCircleOutlined className="ml-1 text-gray-400" />
              </Tooltip>
            </span>
            <span>-${discount.toFixed(2)}</span>
          </div>
        )}

        {voucherDiscount > 0 && (
          <div className="flex justify-between py-2 text-green-600">
            <span className="flex items-center">
              Voucher Discount
              <Tooltip title="Voucher discount applied">
                <QuestionCircleOutlined className="ml-1 text-gray-400" />
              </Tooltip>
            </span>
            <span>-${voucherDiscount.toFixed(2)}</span>
          </div>
        )}

        <div className="flex justify-between py-2">
          <span className="text-gray-600">Shipping</span>
          <span className="text-green-600 font-medium">Free</span>
        </div>

        <Divider className="!my-2" />

        <div className="flex justify-between py-2">
          <span className="text-lg font-semibold">Total</span>
          <span className="text-lg font-semibold text-primary">
            ${total.toFixed(2)}
          </span>
        </div>

        {showCheckoutButton && (
          <div className="space-y-3 pt-4">
            <Button
              type="primary"
              size="large"
              block
              icon={<ShoppingCartOutlined />}
              onClick={handleCheckout}
              className="font-medium h-12"
            >
              Proceed to Checkout
            </Button>
            <Button
              size="large"
              block
              href="/products"
              className="font-medium h-12"
            >
              Continue Shopping
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

export default OrderSummary;
