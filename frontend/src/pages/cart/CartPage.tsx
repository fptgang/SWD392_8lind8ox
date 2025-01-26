import React from 'react';
import { Card, List, Button, InputNumber, Typography, Space, Empty, Row, Col } from 'antd';
import { DeleteOutlined, ShoppingCartOutlined } from '@ant-design/icons';
import { useNavigate } from 'react-router';
import { useCart } from './useCart';

const { Title, Text } = Typography;

const CartPage: React.FC = () => {
  const { cartItems, total, updateQuantity, removeItem } = useCart();
  const navigate = useNavigate();

  if (cartItems.length === 0) {
    return (
      <Card>
        <Empty
          image={<ShoppingCartOutlined style={{ fontSize: 64 }} />}
          description="Your cart is empty"
        >
          <Button type="primary" onClick={() => navigate('/products')}>
            Continue Shopping
          </Button>
        </Empty>
      </Card>
    );
  }

  return (
    <div style={{ maxWidth: 1200, margin: '0 auto', padding: '24px' }}>
      <Title level={2}>Shopping Cart</Title>
      <Row gutter={[24, 24]}>
        <Col xs={24} lg={16}>
          <List
            itemLayout="horizontal"
            dataSource={cartItems}
            renderItem={(item) => (
              <List.Item
                actions={[
                  <Button
                    type="text"
                    danger
                    icon={<DeleteOutlined />}
                    onClick={() => removeItem(item.id)}
                  />
                ]}
              >
                <List.Item.Meta
                  avatar={<img src={item.image} alt={item.name} style={{ width: 80, height: 80, objectFit: 'cover' }} />}
                  title={item.name}
                  description={
                    <Space direction="vertical">
                      <Text type="secondary">${item.price.toFixed(2)}</Text>
                      <InputNumber
                        min={1}
                        value={item.quantity}
                        onChange={(value) => updateQuantity(item.id, value || 1)}
                      />
                    </Space>
                  }
                />
                <div>
                  <Text strong>${(item.price * item.quantity).toFixed(2)}</Text>
                </div>
              </List.Item>
            )}
          />
        </Col>
        <Col xs={24} lg={8}>
          <Card>
            <Space direction="vertical" style={{ width: '100%' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <Text>Subtotal:</Text>
                <Text strong>${total.toFixed(2)}</Text>
              </div>
              <Button type="primary" block onClick={() => navigate('/checkout')}>
                Proceed to Checkout
              </Button>
              <Button block onClick={() => navigate('/products')}>
                Continue Shopping
              </Button>
            </Space>
          </Card>
        </Col>
      </Row>
    </div>
  );
};

export default CartPage;