import React from "react";
import { Typography, Button } from "antd";
import { useGo } from "@refinedev/core";
import { useCart } from "../../../hooks/useCart";

const { Title } = Typography;

const OrderSummary: React.FC = () => {
  const { total } = useCart();
  const go = useGo();

  return (
    <div className="bg-white rounded-lg shadow-md p-6 sticky top-4">
      <Title level={4}>Order Summary</Title>
      <div className="space-y-4">
        <div className="flex justify-between py-2 border-b">
          <span className="text-gray-600">Subtotal</span>
          <span className="font-semibold">${total.toFixed(2)}</span>
        </div>
        <div className="flex justify-between py-2 border-b">
          <span className="text-gray-600">Shipping</span>
          <span className="text-green-600">Free</span>
        </div>
        <div className="flex justify-between py-2 text-lg font-semibold">
          <span>Total</span>
          <span className="text-primary">${total.toFixed(2)}</span>
        </div>
        <div className="space-y-2">
          <Button
            type="primary"
            size="large"
            block
            onClick={() =>
              go({
                to: "/checkout",
              })
            }
            className="font-medium"
          >
            Proceed to Checkout
          </Button>
          <Button size="large" block href="/products" className="font-medium">
            Continue Shopping
          </Button>
        </div>
      </div>
    </div>
  );
};

export default OrderSummary;
