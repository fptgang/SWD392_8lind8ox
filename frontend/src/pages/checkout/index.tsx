import React from 'react';
import { useGetIdentity, useCreate } from '@refinedev/core';
import { Card, Form, Input, Button, Radio, Typography, Space, Divider, message, Alert } from 'antd';
import { useNavigate } from 'react-router';
import { useCart } from '../../hooks/useCart';
import { AccountDto } from '../../../generated';
import { formatCurrency } from '../../utils/currency-formatter';

const { Title, Text } = Typography;

interface PromoCodeResponse {
  code: string;
  discountPercentage: number;
  isValid: boolean;
}

const CheckoutPage: React.FC = () => {
  const [form] = Form.useForm();
  const navigate = useNavigate();
  const { cartItems, total, clearCart } = useCart();
  const me = useGetIdentity<AccountDto>();
  const [paymentMethod, setPaymentMethod] = React.useState<'wallet' | 'other'>('wallet');
  const [promoCode, setPromoCode] = React.useState<string>('');
  const [discount, setDiscount] = React.useState<number>(0);
  const [promoError, setPromoError] = React.useState<string>('');

  const { mutate: validatePromoCode } = useCreate();

  const handlePromoCodeValidation = async () => {
    try {
      const response = await validatePromoCode({
        resource: 'promotional-campaigns/validate',
        values: { code: promoCode },
      });

      const promoResponse = response.data as PromoCodeResponse;
      if (promoResponse.isValid) {
        setDiscount(total * (promoResponse.discountPercentage / 100));
        setPromoError('');
      } else {
        setDiscount(0);
        setPromoError('Invalid promotion code');
      }
    } catch (error) {
      setDiscount(0);
      setPromoError('Error validating promotion code');
    }
  };

  const handleSubmit = async (values: any) => {
    try {
      if (paymentMethod === 'wallet' && (me.data?.balance ?? 0) < (total - discount)) {
        message.error('Insufficient wallet balance');
        return;
      }

      const orderData = {
        items: cartItems.map(item => ({
          productId: item.id,
          quantity: item.quantity,
          price: item.price
        })),
        paymentMethod,
        promoCode: promoCode || undefined,
        totalAmount: total - discount
      };

      // Create order API call would go here
      message.success('Order placed successfully!');
      clearCart();
      navigate('/orders');
    } catch (error) {
      message.error('Failed to place order');
    }
  };

  if (cartItems.length === 0) {
    navigate('/cart');
    return null;
  }

  return (
    <div style={{ maxWidth: 800, margin: '0 auto', padding: '24px' }}>
      <Title level={2}>Checkout</Title>

      <Space direction="vertical" size="large" style={{ width: '100%' }}>
        {/* Order Summary */}
        <Card title="Order Summary">
          {cartItems.map((item) => (
            <div key={item.id} style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
              <Text>{item.name} x {item.quantity}</Text>
              <Text>{formatCurrency(item.price * (item.quantity || 1))}</Text>
            </div>
          ))}
          <Divider />
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <Text>Subtotal:</Text>
            <Text>{formatCurrency(total)}</Text>
          </div>
          {discount > 0 && (
            <div style={{ display: 'flex', justifyContent: 'space-between', color: '#52c41a' }}>
              <Text>Discount:</Text>
              <Text>-{formatCurrency(discount)}</Text>
            </div>
          )}
          <Divider />
          <div style={{ display: 'flex', justifyContent: 'space-between' }}>
            <Text strong>Total:</Text>
            <Text strong>{formatCurrency(total - discount)}</Text>
          </div>
        </Card>

        {/* Payment Method */}
        <Card title="Payment Method">
          <Space direction="vertical" style={{ width: '100%' }}>
            <Radio.Group
              value={paymentMethod}
              onChange={(e) => setPaymentMethod(e.target.value)}
            >
              <Space direction="vertical">
                <Radio value="wallet">
                  Wallet Balance ({formatCurrency(me.data?.balance ?? 0)})
                </Radio>
                <Radio value="other">Other Payment Methods</Radio>
              </Space>
            </Radio.Group>

            {paymentMethod === 'wallet' && (me.data?.balance ?? 0) < (total - discount) && (
              <Alert
                type="warning"
                message="Insufficient wallet balance"
                description="Please top up your wallet or choose another payment method."
              />
            )}
          </Space>
        </Card>

        {/* Promotion Code */}
        <Card title="Promotion Code">
          <Space style={{ width: '100%' }}>
            <Input
              placeholder="Enter promotion code"
              value={promoCode}
              onChange={(e) => setPromoCode(e.target.value)}
              style={{ width: '200px' }}
            />
            <Button type="primary" onClick={handlePromoCodeValidation}>
              Apply
            </Button>
          </Space>
          {promoError && <Text type="danger" style={{ display: 'block', marginTop: '8px' }}>{promoError}</Text>}
        </Card>

        {/* Place Order Button */}
        <Button
          type="primary"
          size="large"
          block
          onClick={() => form.submit()}
        >
          Place Order
        </Button>
      </Space>

      <Form form={form} onFinish={handleSubmit} hidden>
        {/* Hidden form for handling submission */}
      </Form>
    </div>
  );
};

export default CheckoutPage;