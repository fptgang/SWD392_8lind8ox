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
      <div className="bg-white rounded-lg shadow-md p-6">
        <Table
          columns={columns}
          dataSource={cartItems}
          pagination={false}
          rowKey="id"
        />
        <div className="flex justify-end mt-6">
          <div className="text-right">
            <div className="text-lg font-semibold mb-2">
              Total: ${total.toFixed(2)}
            </div>
            <Space>
              <Button size="large" href="/products">
                Continue Shopping
              </Button>
              <Button type="primary" size="large" onClick={() => nav({
                to: '/checkout',
              })}>
                Proceed to Checkout
              </Button>
            </Space>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CartPage;