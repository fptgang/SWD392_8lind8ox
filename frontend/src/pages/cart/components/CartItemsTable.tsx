// components/cart/CartItemsTable.tsx
import React from "react";
import { Table, Button, InputNumber, notification, Space, Tag, Tooltip } from "antd";
import { DeleteOutlined, ShoppingOutlined, WarningOutlined } from "@ant-design/icons";
import { useCart } from "../../../hooks/useCart";
import { CartItem } from "../../../store/features/cart/cartSlice";

interface CartItemsTableProps {
  items?: CartItem[];
  showOriginalPrice?: boolean;
}

const CartItemsTable: React.FC<CartItemsTableProps> = ({
  items,
  showOriginalPrice = false,
}) => {
  const { cartItems: storeCartItems, updateItemQuantity, removeFromCart } = useCart();
  
  // Use provided items or fallback to store items
  const cartItems = items || storeCartItems;

  const handleQuantityChange = async (skuId: number, quantity: number) => {
    try {
      await updateItemQuantity(skuId, quantity);
    } catch (error) {
      notification.error({
        message: "Failed to update quantity",
        description: "Please try again later",
      });
    }
  };

  const handleRemoveItem = async (skuId: number) => {
    try {
      await removeFromCart(skuId);
      notification.success({
        message: "Item removed successfully",
      });
    } catch (error) {
      notification.error({
        message: "Failed to remove item",
        description: "Please try again later",
      });
    }
  };

  const columns = [
    {
      title: "Product",
      dataIndex: "name",
      key: "name",
      render: (text: string, record: CartItem) => (
        <div className="flex items-center space-x-4">
          {record.imageUrl ? (
            <img
              src={record.imageUrl}
              alt={text}
              className="w-16 h-16 object-cover rounded-lg border border-gray-200"
            />
          ) : (
            <div className="w-16 h-16 bg-gray-100 rounded-lg flex items-center justify-center">
              <ShoppingOutlined className="text-gray-400 text-2xl" />
            </div>
          )}
          <div className="flex flex-col">
            <span className="font-medium text-gray-800">{text}</span>
            {showOriginalPrice &&
              record.originalPrice !== record.checkoutPrice && (
                <span className="text-sm line-through text-gray-500">
                  ${record.originalPrice.toFixed(2)}
                </span>
              )}
            {!record.skuId && (
              <Tooltip title="This item is invalid and cannot be processed. Please remove it.">
                <Tag color="error" className="mt-1">
                  <WarningOutlined /> Invalid Item
                </Tag>
              </Tooltip>
            )}
          </div>
        </div>
      ),
    },
    {
      title: "Price",
      dataIndex: "checkoutPrice",
      key: "price",
      render: (price: number) => (
        <span className="font-medium">
          ${price.toFixed(2)}
        </span>
      ),
    },
    {
      title: "Quantity",
      key: "quantity",
      render: (_: any, record: CartItem) => (
        <Space>
          <InputNumber
            min={1}
            max={record.stock}
            value={record.quantity}
            onChange={(value) => record.skuId && handleQuantityChange(record.skuId, value || 1)}
            className="w-20"
            disabled={!record.skuId}
            controls
            addonAfter={
              record.stock > 0 && (
                <span className="text-xs text-gray-500">
                  Max: {record.stock}
                </span>
              )
            }
          />
        </Space>
      ),
    },
    {
      title: "Subtotal",
      key: "subtotal",
      render: (_: any, record: CartItem) => (
        <span className="font-medium text-gray-900">
          ${(record.checkoutPrice * record.quantity).toFixed(2)}
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
          onClick={() => {
            // Handle removal for both cases
            if (record.skuId) {
              handleRemoveItem(record.skuId);
            } else {
              // If no skuId, use another unique identifier or remove differently
              notification.info({
                message: "Removing invalid item",
              });
              // Find item index and remove it directly if needed
              const index = cartItems.findIndex(item => 
                item.name === record.name && 
                item.checkoutPrice === record.checkoutPrice
              );
              if (index >= 0) {
                removeFromCart(index);
              }
            }
          }}
          className="hover:text-red-700 transition-colors"
          aria-label="Remove item"
        />
      ),
    },
  ];

  return (
    <Table
      columns={columns}
      dataSource={cartItems}
      pagination={false}
      rowKey="skuId"
      className="cart-items-table"
      rowClassName={(record) => !record.skuId ? 'bg-red-50' : ''}
      locale={{
        emptyText: (
          <div className="py-8">
            <ShoppingOutlined className="text-4xl text-gray-300 mb-4" />
            <p className="text-gray-500">No items in cart</p>
          </div>
        ),
      }}
    />
  );
};

export default CartItemsTable;
