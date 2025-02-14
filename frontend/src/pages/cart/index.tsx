import React from "react";
import { Typography, Empty, Button } from "antd";
import { useCart } from "../../hooks/useCart";
import CartItemsTable from "./components/CartItemsTable";
import OrderSummary from "./components/OrderSummary";

const { Title } = Typography;

const CartPage: React.FC = () => {
  const { cartItems } = useCart();

  if (!cartItems.length) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Empty description="Your cart is empty" className="my-8" />
        <div className="text-center">
          <Button type="primary" size="large" href="/products">
            Continue Shopping
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <Title level={2}>Shopping Cart</Title>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="md:col-span-2">
          <div className="bg-white rounded-lg shadow-md p-6">
            <CartItemsTable />
          </div>
        </div>
        <div className="md:col-span-1">
          <OrderSummary />
        </div>
      </div>
    </div>
  );
};

export default CartPage;
