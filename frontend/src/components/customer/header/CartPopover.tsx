import React from "react";
import {
  Popover,
  Badge,
  Button,
  InputNumber,
  Typography,
  Divider,
  Empty,
  Tag,
  notification,
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
import type { CartItem as CartItemType } from "../../../store/features/cart/cartSlice";

const { Text, Title } = Typography;
interface CartItemProps {
  item: CartItemType;
  onUpdateQuantity: (skuId: number, quantity: number) => void;
  onRemove: (skuId: number) => void;
}

const CartItem: React.FC<CartItemProps> = ({
  item,
  onUpdateQuantity,
  onRemove,
}) => {
  const handleQuantityChange = (value: number | null) => {
    if (!value) return;

    try {
      onUpdateQuantity(item.skuId, value);
    } catch (error) {
      notification.error({
        message: "Error updating quantity",
        description:
          error instanceof Error ? error.message : "An unknown error occurred",
      });
    }
  };

  const handleRemove = () => {
    try {
      onRemove(item.skuId);
    } catch (error) {
      notification.error({
        message: "Error removing item",
        description:
          error instanceof Error ? error.message : "An unknown error occurred",
      });
    }
  };

  const discount = (item.originalPrice || 0) > (item.price || 0);
  const discountPercentage = discount
    ? Math.round(
        (((item.originalPrice || 0) - (item.price || 0)) /
          (item.originalPrice || 1)) *
          100
      )
    : 0;

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
            src={`${item.imageUrl}`}
            alt={item.name || "Cart Item"}
            className="w-full h-full object-cover"
            onError={(e) => {
              const imgElement = e.target as HTMLImageElement;
              imgElement.src = "/path/to/default/image.png"; // Provide a default image
            }}
          />
        </div>
        <div className="flex-1 min-w-0">
          <Text strong className="block truncate">
            {item.name}
          </Text>
          <div className="flex items-center gap-2">
            <Text type={discount ? "secondary" : undefined} delete={discount}>
              {formatCurrency(item.originalPrice || 0)}
            </Text>
            {discount && (
              <>
                <Text type="success" strong>
                  {formatCurrency(item.price || 0)}
                </Text>
                <Tag color="success">-{discountPercentage}%</Tag>
              </>
            )}
          </div>
          {(item.stock || 0) < 10 && (
            <Tag color="warning" className="mt-1">
              Only {item.stock} left
            </Tag>
          )}
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
              disabled={(item.quantity || 1) <= 1}
            />
            <InputNumber
              min={1}
              max={item.stock}
              value={item.quantity}
              onChange={handleQuantityChange}
              className="w-14"
              controls={false}
            />
            <Button
              size="small"
              icon={<PlusOutlined />}
              onClick={() =>
                handleQuantityChange(
                  Math.min(item.stock || 0, (item.quantity || 1) + 1)
                )
              }
              className="flex items-center justify-center"
              disabled={(item.quantity || 1) >= (item.stock || 0)}
            />
          </div>
          <Button
            type="text"
            danger
            size="small"
            icon={<DeleteOutlined />}
            onClick={handleRemove}
            className="flex items-center justify-center"
          >
            Remove
          </Button>
        </div>
      </div>
    </motion.div>
  );
};
interface CartSummaryProps {
  total: number;
  originalTotal: number;
  itemCount: number;
  voucherDiscount?: number;
}

const CartSummary: React.FC<CartSummaryProps> = ({
  total,
  originalTotal,
  itemCount,
  voucherDiscount = 0,
}) => {
  const hasDiscount = originalTotal > total;
  const finalTotal = total - voucherDiscount;

  return (
    <div className="p-4 rounded-lg">
      <div className="flex justify-between mb-2">
        <Text type="secondary">Subtotal ({itemCount} items)</Text>
        <Text type="secondary" delete={hasDiscount}>
          {formatCurrency(originalTotal)}
        </Text>
      </div>

      {hasDiscount && (
        <div className="flex justify-between mb-2">
          <Text type="success">Item Discount</Text>
          <Text type="success">-{formatCurrency(originalTotal - total)}</Text>
        </div>
      )}

      {voucherDiscount > 0 && (
        <div className="flex justify-between mb-2">
          <Text type="success">Voucher Discount</Text>
          <Text type="success">-{formatCurrency(voucherDiscount)}</Text>
        </div>
      )}

      <Divider className="my-2" />

      <div className="flex justify-between mb-4">
        <Text strong>Total</Text>
        <Text type="success" strong>
          {formatCurrency(finalTotal)}
        </Text>
      </div>

      <Link to="/cart">
        <Button
          type="primary"
          block
          icon={<ArrowRightOutlined />}
          className="h-10"
        >
          View Cart
        </Button>
      </Link>
    </div>
  );
};

export const CartPopover: React.FC = () => {
  const {
    cartItems,
    total,
    originalTotal,
    updateItemQuantity,
    removeFromCart,
    voucher,
    getCartSummary,
  } = useCart();

  const { itemCount, voucherDiscount } = getCartSummary();

  const cartContent = (
    <div className="w-[380px] max-h-[550px]">
      <div className="px-4 py-3 border-b">
        <Title level={5} className="m-0">
          Shopping Cart
        </Title>
        <Text type="secondary">{itemCount} items</Text>
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
                key={item.skuId}
                item={item}
                onUpdateQuantity={updateItemQuantity}
                onRemove={removeFromCart}
              />
            ))
          )}
        </AnimatePresence>
      </div>

      {cartItems.length > 0 && (
        <>
          <Divider className="my-2" />
          <div className="px-4">
            <CartSummary
              total={total}
              originalTotal={originalTotal}
              itemCount={itemCount}
              voucherDiscount={voucherDiscount}
            />
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
      arrow={false}
    >
      <Badge count={itemCount} size="small">
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
