import React, { useState } from "react";
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
  Badge,
  Space,
  Tag
} from "antd";
import { DeleteOutlined, ShoppingCartOutlined, MinusOutlined, PlusOutlined } from "@ant-design/icons";
import { useNavigate } from "react-router";
import { useAppDispatch, useAppSelector } from "../../hooks/useRedux";
import { updateQuantity, removeItem, cleanInvalidItems } from "../../store/features/cart/cartSlice";

const { Title, Text } = Typography;

const CartPage: React.FC = () => {
  // Redux state and dispatch
  const dispatch = useAppDispatch();
  const navigate = useNavigate();
  const { items: cartItems, total, originalTotal } = useAppSelector(state => state.cart);
  
  // Local state for disabled items
  const [disabledItems, setDisabledItems] = useState<Record<number, boolean>>({});

  // Calculate cart summary
  const getCartSummary = () => {
    // Filter out disabled items for calculation
    const activeItems = cartItems.filter(item => !disabledItems[item.skuId]);
    
    const itemCount = activeItems.reduce((sum, item) => sum + item.quantity, 0);
    const subtotal = activeItems.reduce((sum, item) => sum + (item.checkoutPrice * item.quantity), 0);
    const originalSubtotal = activeItems.reduce((sum, item) => sum + (item.originalPrice * item.quantity), 0);
    const savings = originalSubtotal - subtotal;

    return {
      itemCount,
      subtotal,
      savings,
      finalTotal: subtotal,
    };
  };

  // Update item quantity
  const handleQuantityChange = (skuId: number, quantity: number) => {
    if (quantity > 0) {
      dispatch(updateQuantity({ skuId, quantity }));
    } else {
      // Show confirmation before removal
      handleRemoveItem(skuId);
    }
  };

  // Remove item from cart
  const handleRemoveItem = (skuId: number) => {
    dispatch(removeItem(skuId));
    // Also remove from disabled items if present
    if (disabledItems[skuId]) {
      const newDisabled = { ...disabledItems };
      delete newDisabled[skuId];
      setDisabledItems(newDisabled);
    }
  };

  // Toggle item disabled state
  const handleToggleItemDisabled = (skuId: number) => {
    setDisabledItems(prev => ({
      ...prev,
      [skuId]: !prev[skuId]
    }));
  };

  // Handle proceed to checkout
  const handleProceedToCheckout = () => {
    // Check if we have any items to checkout
    const activeItems = cartItems.filter(item => !disabledItems[item.skuId]);
    
    if (activeItems.length === 0) {
      notification.warning({
        message: "No items for checkout",
        description: "Please enable at least one item for checkout"
      });
      return;
    }
    
    // Store disabled items in session storage to remember the user's selection
    // This way the checkout page can know which items to include
    sessionStorage.setItem('disabledCartItems', JSON.stringify(disabledItems));
    
    // Navigate to checkout page
    navigate("/checkout");
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
  const hasInvalidItems = cartItems.some(item => !item.skuId || typeof item.skuId !== 'number');

  return (
    <div className="container mx-auto px-4 py-8">
      <Title level={2} className="mb-6">Shopping Cart</Title>

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
              renderItem={item => {
                const isDisabled = disabledItems[item.skuId] || false;
                
                return (
                  <List.Item
                    key={item.skuId}
                    className={`${isDisabled ? 'opacity-60' : ''} rounded-lg p-2 mb-2 transition-all`}
                    actions={[
                      <Button 
                        key="delete" 
                        danger 
                        icon={<DeleteOutlined />} 
                        onClick={() => handleRemoveItem(item.skuId)}
                      />
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
                          src={item.imageUrl || 'https://placehold.co/80'} 
                          alt={item.name} 
                          style={{ width: 80, height: 80, objectFit: 'cover' }}
                          className="rounded-md"
                        />
                      </div>
                      
                      {/* Product Details */}
                      <div className="flex-grow">
                        <div className="flex justify-between">
                          <Title level={5} className="mb-1">{item.name}</Title>
                        </div>
                        
                        {/* Price info */}
                        <div className="mb-2">
                          {item.originalPrice > item.checkoutPrice ? (
                            <Space>
                              <Text delete className="text-gray-500">
                                ${item.originalPrice.toFixed(2)}
                              </Text>
                              <Text type="danger" strong>
                                ${item.checkoutPrice.toFixed(2)}
                              </Text>
                              <Tag color="red">
                                {Math.round((1 - item.checkoutPrice / item.originalPrice) * 100)}% OFF
                              </Tag>
                            </Space>
                          ) : (
                            <Text>${item.checkoutPrice.toFixed(2)}</Text>
                          )}
                        </div>
                        
                        {/* Stock info */}
                        <div className="mb-2">
                          <Text type="secondary">
                            In stock: {item.stock}
                          </Text>
                        </div>
                        
                        {/* Quantity controls */}
                        <div className="flex items-center">
                          <Text className="mr-2">Quantity:</Text>
                          <div className="flex items-center">
                            <Button
                              icon={<MinusOutlined />}
                              onClick={() => handleQuantityChange(item.skuId, item.quantity - 1)}
                              disabled={isDisabled}
                            />
                            <InputNumber
                              min={1}
                              max={item.stock}
                              value={item.quantity}
                              onChange={(value) => handleQuantityChange(item.skuId, value as number)}
                              disabled={isDisabled}
                              className="mx-2"
                              style={{ width: 60 }}
                            />
                            <Button
                              icon={<PlusOutlined />}
                              onClick={() => handleQuantityChange(item.skuId, item.quantity + 1)}
                              disabled={isDisabled || item.quantity >= item.stock}
                            />
                          </div>
                        </div>
                      </div>
                      
                      {/* Item Total */}
                      <div className="ml-4 text-right flex-shrink-0">
                        <Text strong className="text-lg">
                          ${(item.checkoutPrice * item.quantity).toFixed(2)}
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
                <Text>${summary.subtotal.toFixed(2)}</Text>
              </div>
              
              {summary.savings > 0 && (
                <div className="flex justify-between text-green-600">
                  <Text type="success">Savings:</Text>
                  <Text type="success">-${summary.savings.toFixed(2)}</Text>
                </div>
              )}
              
              <Divider />
              
              <div className="flex justify-between">
                <Text strong className="text-lg">Total:</Text>
                <Text strong className="text-lg">${summary.finalTotal.toFixed(2)}</Text>
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
              {Object.keys(disabledItems).length > 0 && (
                <div className="mt-4 p-3 bg-gray-50 rounded-md">
                  <Text type="secondary">
                    {Object.keys(disabledItems).length} item(s) excluded from checkout
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
