import React from 'react';
import { Typography, Table, Button, InputNumber, Space, Empty } from 'antd';
import { DeleteOutlined } from '@ant-design/icons';
import { useCart } from '../../hooks/useCart';
import { useGo } from '@refinedev/core';

const { Title } = Typography;

interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
  image: string;
}

const CartPage: React.FC = () => {
  const { cartItems, updateQuantity, removeItem, total } = useCart();
  const nav = useGo();

  const columns = [
    {
      title: 'Product',
      dataIndex: 'name',
      key: 'name',
      render: (text: string, record: CartItem) => (
        <div className="flex items-center space-x-4">
          <img src={record.image} alt={text} className="w-16 h-16 object-cover rounded" />
          <span>{text}</span>
        </div>
      ),
    },
    {
      title: 'Price',
      dataIndex: 'price',
      key: 'price',
      render: (price: number) => `$${price.toFixed(2)}`,
    },
    {
      title: 'Quantity',
      key: 'quantity',
      render: (_: any, record: CartItem) => (
        <InputNumber
          min={1}
          value={record.quantity}
          onChange={(value) => updateQuantity(record.id, value || 1)}
          className="w-20"
        />
      ),
    },
    {
      title: 'Subtotal',
      key: 'subtotal',
      render: (_: any, record: CartItem) => `$${(record.price * record.quantity).toFixed(2)}`,
    },
    {
      title: 'Action',
      key: 'action',
      render: (_: any, record: CartItem) => (
        <Button
          type="text"
          danger
          icon={<DeleteOutlined />}
          onClick={() => removeItem(record.id)}
        />
      ),
    },
  ];

  if (!cartItems.length) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Empty
          description="Your cart is empty"
          className="my-8"
        />
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
            <Table
              columns={columns}
              dataSource={cartItems}
              pagination={false}
              rowKey="id"
            />
          </div>
        </div>
        <div className="md:col-span-1">
          <div className="bg-white rounded-lg shadow-md p-6 sticky top-4">
            <Title level={4}>Order Summary</Title>
            <div className="space-y-4">
              <div className="flex justify-between py-2 border-b">
                <span>Subtotal</span>
                <span className="font-semibold">${total.toFixed(2)}</span>
              </div>
              <div className="flex justify-between py-2 border-b">
                <span>Shipping</span>
                <span>Free</span>
              </div>
              <div className="flex justify-between py-2 text-lg font-semibold">
                <span>Total</span>
                <span>${total.toFixed(2)}</span>
              </div>
              <div className="space-y-2">
                <Button 
                  type="primary" 
                  size="large" 
                  block 
                  onClick={() => nav({
                    to: '/checkout',
                  })}
                >
                  Proceed to Checkout
                </Button>
                <Button size="large" block href="/products">
                  Continue Shopping
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CartPage;