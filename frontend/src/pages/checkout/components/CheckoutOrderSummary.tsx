// components/CheckoutOrderSummary.tsx
import React from "react";
import { Card, Typography, Divider } from "antd";
import { formatCurrency } from "../../../utils/currency-formatter";
import { CartItem } from "../../../store/features/cart/cartSlice";

const { Text } = Typography;

interface CheckoutOrderSummaryProps {
  cartItems: CartItem[];
  total: number;
  discount: number;
}

export const CheckoutOrderSummary: React.FC<CheckoutOrderSummaryProps> = ({
  cartItems,
  total,
  discount,
}) => (
  <Card title="Order Summary" className="shadow-sm">
    {cartItems.map((item) => (
      <div key={item.id} className="flex justify-between mb-2">
        <Text>
          {item.name} x {item.quantity}
        </Text>
        <Text>{formatCurrency(item.price * (item.quantity || 1))}</Text>
      </div>
    ))}
    <Divider className="my-4" />
    <div className="flex justify-between">
      <Text>Subtotal:</Text>
      <Text>{formatCurrency(total)}</Text>
    </div>
    {discount > 0 && (
      <div className="flex justify-between text-green-500">
        <Text>Discount:</Text>
        <Text>-{formatCurrency(discount)}</Text>
      </div>
    )}
    <Divider className="my-4" />
    <div className="flex justify-between">
      <Text strong>Total:</Text>
      <Text strong>{formatCurrency(total - discount)}</Text>
    </div>
  </Card>
);
