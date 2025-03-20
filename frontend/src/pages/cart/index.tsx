import React, { useState, useEffect } from "react";
import {
  Typography,
  Empty,
  Button,
  Card,
  List,
  InputNumber,
  Checkbox,
  Divider,
  Row,
  Col,
  notification,
  Space,
  Tag,
  Badge,
} from "antd";
import {
  DeleteOutlined,
  ShoppingCartOutlined,
  MinusOutlined,
  PlusOutlined,
} from "@ant-design/icons";
import { useNavigate } from "react-router";
import { Link } from "react-router";
import { useAppDispatch, useAppSelector } from "../../hooks/useRedux";
import {
  updateQuantity,
  removeItem,
  cleanInvalidItems,
  CartItem,
} from "../../store/features/cart/cartSlice";

const { Title, Text } = Typography;

// Format number with thousands separator and fixed decimal places
const formatCurrency = (amount: number, decimals = 2) => {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals,
  }).format(amount);
};

const CartPage: React.FC = () => {
  // Redux state and dispatch
  const dispatch = useAppDispatch();
  const navigate = useNavigate();
  const {
    items: cartItems,
    total,
    originalTotal,
  } = useAppSelector((state) => state.cart);

  // Local state for disabled items
  const [disabledItems, setDisabledItems] = useState<Record<number, boolean>>(
    {}
  );

  // Count of disabled items for display
  const [disabledItemsCount, setDisabledItemsCount] = useState<number>(0);

  // Update disabled items count whenever disabledItems changes
  useEffect(() => {
    const count = Object.values(disabledItems).filter(
      (value) => value === true
    ).length;
    setDisabledItemsCount(count);
  }, [disabledItems]);

  // Calculate cart summary
  const getCartSummary = () => {
    // Filter out disabled items for calculation
    const activeItems = cartItems.filter((item) => !disabledItems[item.skuId]);

    const itemCount = activeItems.reduce((sum, item) => sum + item.quantity, 0);
    const subtotal = activeItems.reduce(
      (sum, item) => sum + item.finalTotal * item.quantity,
      0
    );
    const originalSubtotal = activeItems.reduce(
      (sum, item) => sum + item.subTotal * item.quantity,
      0
    );
    const savings = originalSubtotal - subtotal;

    return {
      itemCount,
      subtotal,
      savings,
      finalTotal: subtotal,
    };
  };

  // Update item quantity - only allow integer values
  const handleQuantityChange = (
    skuId: number,
    quantity: number,
    slotId?: number
  ) => {
    // Ensure quantity is an integer
    const intQuantity = Math.floor(quantity);

    if (intQuantity > 0) {
      dispatch(updateQuantity({ skuId, slotId, quantity: intQuantity }));
    } else {
      // Show confirmation before removal
      handleRemoveItem(skuId, slotId);
    }
  };

  // Remove item from cart
  const handleRemoveItem = (skuId: number, slotId?: number) => {
    try {
      // Correctly pass the object with skuId and optionally slotId
      dispatch(removeItem({ skuId, slotId }));

      // Also remove from disabled items if present
      if (disabledItems[skuId]) {
        const newDisabled = { ...disabledItems };
        delete newDisabled[skuId];
        setDisabledItems(newDisabled);
      }

      notification.success({
        message: "Item removed",
        description: "The item has been removed from your cart",
        duration: 2,
      });
    } catch (error) {
      console.error("Error removing item:", error);
      notification.error({
        message: "Failed to remove item",
        description: "Please try again later",
      });
    }
  };

  // Toggle item disabled state
  const handleToggleItemDisabled = (skuId: number) => {
    setDisabledItems((prev) => {
      const newState = { ...prev };
      newState[skuId] = !prev[skuId];

      // Remove false values to keep the state clean
      if (!newState[skuId]) {
        delete newState[skuId];
      }

      return newState;
    });
  };

  // Handle proceed to checkout
  const handleProceedToCheckout = () => {
    // Check if we have any items to checkout
    const activeItems = cartItems.filter((item) => !disabledItems[item.skuId]);

    if (activeItems.length === 0) {
      notification.warning({
        message: "No items for checkout",
        description: "Please enable at least one item for checkout",
      });
      return;
    }

    // Store disabled items in session storage to remember the user's selection
    sessionStorage.setItem("disabledCartItems", JSON.stringify(disabledItems));

    // Navigate to checkout page
    navigate("/checkout");
  };

  // Navigate to the product detail page
  const navigateToProductDetail = (item: CartItem | undefined) => {
    if (!item) {
      notification.error({
        message: "Navigation error",
        description: "Could not navigate to product details",
      });
      return;
    }

    try {
      if (item.blindBoxId) {
        // Navigate to product/blindbox detail
        navigate(`/products/${item.blindBoxId}`);
      } else if (item.setId) {
        // Navigate to set detail
        navigate(`/case/${item.setId}`);
      } else {
        notification.warning({
          message: "Invalid item",
          description: "Could not determine the item's product page",
        });
      }
    } catch (error) {
      console.error("Navigation error:", error);
      notification.error({
        message: "Navigation error",
        description: "Failed to navigate to product details",
      });
    }
  };

  // Render empty cart message if cart is empty
  if (cartItems.length === 0) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Empty
          description={
            <span className="text-gray-600">Your cart is empty</span>
          }
          className="my-8"
        />
        <div className="text-center">
          <Button
            type="primary"
            onClick={() => navigate("/products")}
            size="large"
            icon={<ShoppingCartOutlined />}
          >
            Shop Now
          </Button>
        </div>
      </div>
    );
  }

  // Get cart summary
  const summary = getCartSummary();
  const hasInvalidItems = cartItems.some(
    (item) => !item.skuId || typeof item.skuId !== "number"
  );

  return (
    <div className="container mx-auto px-4 py-8">
      <Title level={2} className="mb-6">
        Shopping Cart
      </Title>

      {hasInvalidItems && (
        <Card className="mb-4 bg-amber-50 border-amber-200">
          <div className="flex items-center justify-between">
            <div>
              <Text strong className="text-amber-800">
                Some items in your cart are invalid and cannot be processed.
              </Text>
            </div>
            <Button
              type="primary"
              danger
              onClick={() => dispatch(cleanInvalidItems())}
            >
              Remove Invalid Items
            </Button>
          </div>
        </Card>
      )}

      <Row gutter={24}>
        {/* Cart Items List - Left Side */}
        <Col xs={24} lg={16}>
          <Card title={`Cart Items (${cartItems.length})`} className="mb-4">
            <List
              itemLayout="horizontal"
              dataSource={cartItems}
              renderItem={(item) => {
                const isDisabled = Boolean(disabledItems[item.skuId]);

                return (
                  <List.Item
                    key={`${item.skuId}-${item.slotId || "0"}`}
                    className={`${
                      isDisabled ? "opacity-60" : ""
                    } rounded-lg p-2 mb-2 transition-all`}
                    actions={[
                      <Button
                        key="delete"
                        danger
                        icon={<DeleteOutlined />}
                        onClick={() =>
                          handleRemoveItem(item.skuId, item.slotId)
                        }
                      />,
                    ]}
                  >
                    <div className="flex items-start w-full">
                      {/* Checkbox for disabling item */}
                      <Checkbox
                        checked={!isDisabled}
                        onChange={() => handleToggleItemDisabled(item.skuId)}
                        className="mt-2 mr-4"
                      />

                      {/* Product Image */}
                      <div className="mr-4 flex-shrink-0">
                        <img
                          src={item.imageUrl || "https://placehold.co/80"}
                          alt={item.name}
                          style={{ width: 80, height: 80, objectFit: "cover" }}
                          className="rounded-md cursor-pointer"
                          onClick={() => navigateToProductDetail(item)}
                          role="button"
                          aria-label={`View ${item.name} details`}
                          tabIndex={0}
                          onKeyDown={(e) => {
                            if (e.key === "Enter")
                              navigateToProductDetail(item);
                          }}
                        />
                      </div>

                      {/* Product Details */}
                      <div className="flex-grow">
                        <div className="flex justify-between">
                          <Title
                            level={5}
                            className="mb-1 cursor-pointer hover:text-blue-600 transition-colors"
                            onClick={() => navigateToProductDetail(item)}
                          >
                            {item.name}

                            {/* Add slot position badge if applicable */}
                            {item.slotId && (
                              <Badge
                                count={`Slot #${item.slotId}`}
                                style={{
                                  backgroundColor: "#1677ff",
                                  marginLeft: "8px",
                                }}
                              />
                            )}
                          </Title>
                        </div>

                        {/* Price info */}
                        <div className="mb-2">
                          {item.subTotal > item.finalTotal ? (
                            <Space>
                              <Text delete className="text-gray-500">
                                {formatCurrency(item.subTotal)}
                              </Text>
                              <Text type="danger" strong>
                                {formatCurrency(item.finalTotal)}
                              </Text>
                              <Tag color="red">
                                {Math.round(
                                  (1 - item.finalTotal / item.subTotal) * 100
                                )}
                                % OFF
                              </Tag>
                            </Space>
                          ) : (
                            <Text>{formatCurrency(item.finalTotal)}</Text>
                          )}
                        </div>

                        {/* Stock info */}
                        <div className="mb-2">
                          <Text type="secondary">In stock: {item.stock}</Text>
                        </div>

                        {/* Quantity controls - not shown for slot items */}
                        {!item.slotId && (
                          <div className="flex items-center">
                            <Text className="mr-2">Quantity:</Text>
                            <div className="flex items-center">
                              <Button
                                icon={<MinusOutlined />}
                                onClick={() =>
                                  handleQuantityChange(
                                    item.skuId,
                                    item.quantity - 1
                                  )
                                }
                                disabled={isDisabled}
                                aria-label="Decrease quantity"
                              />
                              <InputNumber
                                min={1}
                                max={item.stock}
                                value={item.quantity}
                                onChange={(value) =>
                                  handleQuantityChange(
                                    item.skuId,
                                    value as number
                                  )
                                }
                                precision={0} // Only allow integer values
                                disabled={isDisabled}
                                className="mx-2"
                                style={{ width: 60 }}
                                aria-label="Item quantity"
                              />
                              <Button
                                icon={<PlusOutlined />}
                                onClick={() =>
                                  handleQuantityChange(
                                    item.skuId,
                                    item.quantity + 1
                                  )
                                }
                                disabled={
                                  isDisabled || item.quantity >= item.stock
                                }
                                aria-label="Increase quantity"
                              />
                            </div>
                          </div>
                        )}
                      </div>

                      {/* Item Total */}
                      <div className="ml-4 text-right flex-shrink-0">
                        <Text strong className="text-lg">
                          {formatCurrency(item.finalTotal * item.quantity)}
                        </Text>
                      </div>
                    </div>
                  </List.Item>
                );
              }}
            />
          </Card>
        </Col>

        {/* Order Summary - Right Side */}
        <Col xs={24} lg={8}>
          <Card title="Order Summary" className="sticky top-4">
            <div className="space-y-4">
              <div className="flex justify-between">
                <Text>Subtotal ({summary.itemCount} items):</Text>
                <Text>{formatCurrency(summary.subtotal)}</Text>
              </div>

              {summary.savings > 0 && (
                <div className="flex justify-between text-green-600">
                  <Text type="success">Savings:</Text>
                  <Text type="success">-{formatCurrency(summary.savings)}</Text>
                </div>
              )}

              <Divider />

              <div className="flex justify-between">
                <Text strong className="text-lg">
                  Total:
                </Text>
                <Text strong className="text-lg">
                  {formatCurrency(summary.finalTotal)}
                </Text>
              </div>

              <div>
                <Button
                  type="primary"
                  size="large"
                  block
                  onClick={handleProceedToCheckout}
                  className="mt-4"
                  disabled={summary.itemCount === 0}
                >
                  Confirm and Checkout
                </Button>

                <Button
                  type="link"
                  block
                  onClick={() => navigate("/products")}
                  className="mt-2"
                >
                  Continue Shopping
                </Button>
              </div>

              {/* Disabled items summary */}
              {disabledItemsCount > 0 && (
                <div className="mt-4 p-3 bg-gray-50 rounded-md">
                  <Text type="secondary">
                    {disabledItemsCount} item(s) excluded from checkout
                  </Text>
                </div>
              )}
            </div>
          </Card>
        </Col>
      </Row>
    </div>
  );
};

export default CartPage;
