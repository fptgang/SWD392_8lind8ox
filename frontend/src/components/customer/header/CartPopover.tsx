import React from "react";
import {
  Popover,
  Badge,
  Button,
  InputNumber,
  theme,
  Typography,
  Divider,
  Empty,
} from "antd";
import {
  ShoppingCartOutlined,
  MinusOutlined,
  PlusOutlined,
  DeleteOutlined,
  ArrowRightOutlined,
} from "@ant-design/icons";
import { Link } from "react-router";
import { motion, AnimatePresence } from "framer-motion";
import { formatCurrency } from "../../../utils/currency-formatter";
import { useCart } from "../../../hooks/useCart";

const { Text, Title } = Typography;

const CartItem: React.FC<{
  item: any;
  onUpdateQuantity: (id: string, quantity: number) => void;
  onRemove: (id: string) => void;
}> = ({ item, onUpdateQuantity, onRemove }) => {
  const handleQuantityChange = (value: number | null) => {
    if (value) {
      onUpdateQuantity(item.id, value);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10 }}
      className="py-3 border-b border-gray-100"
    >
      <div className="flex items-center gap-3">
        <div className="w-16 h-16 rounded-lg overflow-hidden">
          <img
            src={item.image}
            alt={item.name}
            className="w-full h-full object-cover"
          />
        </div>
        <div className="flex-1 min-w-0">
          <Text strong className="block truncate">
            {item.name}
          </Text>
          <Text type="secondary" className="text-sm">
            {formatCurrency(item.price)}
          </Text>
        </div>
        <div className="flex flex-col items-end gap-2">
          <div className="flex items-center gap-1">
            <Button
              size="small"
              icon={<MinusOutlined />}
              onClick={() =>
                handleQuantityChange(Math.max(1, (item.quantity || 1) - 1))
              }
              className="flex items-center justify-center"
            />
            <InputNumber
              min={1}
              max={99}
              value={item.quantity || 1}
              onChange={handleQuantityChange}
              className="w-14"
              controls={false}
            />
            <Button
              size="small"
              icon={<PlusOutlined />}
              onClick={() => handleQuantityChange((item.quantity || 1) + 1)}
              className="flex items-center justify-center"
            />
          </div>
          <Button
            type="text"
            danger
            size="small"
            icon={<DeleteOutlined />}
            onClick={() => onRemove(item.id)}
            className="flex items-center justify-center"
          >
            Remove
          </Button>
        </div>
      </div>
    </motion.div>
  );
};

const CartSummary: React.FC<{
  items: any[];
}> = ({ items }) => {
  const total = items.reduce(
    (sum, item) => sum + item.price * (item.quantity || 1),
    0
  );

  return (
    <div className="p-4  rounded-lg">
      <div className="flex justify-between mb-2">
        <Text>Subtotal</Text>
        <Text strong>{formatCurrency(total)}</Text>
      </div>
      <Link to="/cart">
        <Button type="primary" block icon={<ArrowRightOutlined />}>
          View Cart
        </Button>
      </Link>
    </div>
  );
};

export const CartPopover: React.FC = () => {
  const { cartItems, updateQuantity, removeItem } = useCart();

  const cartContent = (
    <div className="w-[380px] max-h-[550px]">
      <div className="px-4 py-3 border-b ">
        <Title level={5} className="m-0">
          Shopping Cart
        </Title>
        <Text type="secondary">{cartItems.length} items</Text>
      </div>

      <div className="max-h-[320px] overflow-y-auto px-4">
        <AnimatePresence>
          {cartItems.length === 0 ? (
            <Empty
              image={Empty.PRESENTED_IMAGE_SIMPLE}
              description="Your cart is empty"
              className="py-8"
            />
          ) : (
            cartItems.map((item) => (
              <CartItem
                key={item.id}
                item={item}
                onUpdateQuantity={updateQuantity}
                onRemove={removeItem}
              />
            ))
          )}
        </AnimatePresence>
      </div>

      {cartItems.length > 0 && (
        <>
          <Divider className="my-2" />
          <div className="px-4">
            <CartSummary items={cartItems} />
          </div>
        </>
      )}
    </div>
  );

  return (
    <Popover
      placement="bottomRight"
      trigger="click"
      content={cartContent}
      overlayClassName="cart-popover"
    >
      <Badge count={cartItems.length} size="small">
        <Button
          type="text"
          icon={<ShoppingCartOutlined className="text-xl" />}
          className="flex items-center justify-center h-10 w-10"
        />
      </Badge>
    </Popover>
  );
};

export default CartPopover;
