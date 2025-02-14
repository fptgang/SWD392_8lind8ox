import React from "react";
import { Table, Button, InputNumber } from "antd";
import { DeleteOutlined } from "@ant-design/icons";
import { useCart } from "../../../hooks/useCart";

interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
  image: string;
}

const CartItemsTable: React.FC = () => {
  const { cartItems, updateQuantity, removeItem } = useCart();

  const columns = [
    {
      title: "Product",
      dataIndex: "name",
      key: "name",
      render: (text: string, record: CartItem) => (
        <div className="flex items-center space-x-4">
          <img
            src={record.image}
            alt={text}
            className="w-16 h-16 object-cover rounded"
          />
          <span className="font-medium">{text}</span>
        </div>
      ),
    },
    {
      title: "Price",
      dataIndex: "price",
      key: "price",
      render: (price: number) => (
        <span className="text-gray-700">${price.toFixed(2)}</span>
      ),
    },
    {
      title: "Quantity",
      key: "quantity",
      render: (_: any, record: CartItem) => (
        <InputNumber
          min={1}
          value={record.quantity}
          onChange={(value) => updateQuantity(record.id, value || 1)}
          className="w-20"
          controls
        />
      ),
    },
    {
      title: "Subtotal",
      key: "subtotal",
      render: (_: any, record: CartItem) => (
        <span className="font-medium text-gray-900">
          ${(record.price * record.quantity).toFixed(2)}
        </span>
      ),
    },
    {
      title: "Action",
      key: "action",
      render: (_: any, record: CartItem) => (
        <Button
          type="text"
          danger
          icon={<DeleteOutlined />}
          onClick={() => removeItem(record.id)}
          className="hover:text-red-700"
        />
      ),
    },
  ];

  return (
    <Table
      columns={columns}
      dataSource={cartItems}
      pagination={false}
      rowKey="id"
      className="cart-items-table"
    />
  );
};

export default CartItemsTable;
