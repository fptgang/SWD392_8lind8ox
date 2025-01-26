import React, { useState } from 'react';
import { Steps, Form, Input, Button, Card, Space, Typography, Divider, Radio, Row, Col, message } from 'antd';
import { useNavigate } from 'react-router';
import { useCart } from '../../hooks/useCart';

const { Title, Text } = Typography;

interface ShippingInfo {
  fullName: string;
  address: string;
  city: string;
  country: string;
  postalCode: string;
  phone: string;
}

interface PaymentInfo {
  method: 'cod' | 'card';
}

const CheckoutPage: React.FC = () => {
  const [currentStep, setCurrentStep] = useState(0);
  const [shippingForm] = Form.useForm<ShippingInfo>();
  const [paymentForm] = Form.useForm<PaymentInfo>();
  const { cartItems, total } = useCart();
  const navigate = useNavigate();

  const shippingCost = 10; // Fixed shipping cost for demonstration
  const totalWithShipping = total + shippingCost;

  const steps = [
    {
      title: 'Shipping',
      content: (
        <Form
          form={shippingForm}
          layout="vertical"
          requiredMark="optional"
        >
          <Row gutter={16}>
            <Col span={24}>
              <Form.Item
                name="fullName"
                label="Full Name"
                rules={[{ required: true, message: 'Please enter your full name' }]}
              >
                <Input />
              </Form.Item>
            </Col>
            <Col span={24}>
              <Form.Item
                name="address"
                label="Address"
                rules={[{ required: true, message: 'Please enter your address' }]}
              >
                <Input.TextArea rows={2} />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="city"
                label="City"
                rules={[{ required: true, message: 'Please enter your city' }]}
              >
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="country"
                label="Country"
                rules={[{ required: true, message: 'Please enter your country' }]}
              >
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="postalCode"
                label="Postal Code"
                rules={[{ required: true, message: 'Please enter your postal code' }]}
              >
                <Input />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="phone"
                label="Phone Number"
                rules={[{ required: true, message: 'Please enter your phone number' }]}
              >
                <Input />
              </Form.Item>
            </Col>
          </Row>
        </Form>
      ),
    },
    {
      title: 'Payment',
      content: (
        <Form
          form={paymentForm}
          layout="vertical"
          requiredMark="optional"
        >
          <Form.Item
            name="method"
            label="Payment Method"
            rules={[{ required: true, message: 'Please select a payment method' }]}
          >
            <Radio.Group>
              <Space direction="vertical">
                <Radio value="cod">Cash on Delivery</Radio>
                <Radio value="card">Credit/Debit Card</Radio>
              </Space>
            </Radio.Group>
          </Form.Item>
        </Form>
      ),
    },
    {
      title: 'Review',
      content: (
        <div>
          <Card className="mb-4">
            <Title level={5}>Order Summary</Title>
            {cartItems.map((item) => (
              <div key={item.id} className="flex justify-between items-center mb-2">
                <div>
                  <Text>{item.name}</Text>
                  <Text type="secondary"> x{item.quantity}</Text>
                </div>
                <Text>${(item.price * (item.quantity || 1)).toFixed(2)}</Text>
              </div>
            ))}
            <Divider />
            <div className="flex justify-between mb-2">
              <Text>Subtotal:</Text>
              <Text>${total.toFixed(2)}</Text>
            </div>
            <div className="flex justify-between mb-2">
              <Text>Shipping:</Text>
              <Text>${shippingCost.toFixed(2)}</Text>
            </div>
            <Divider />
            <div className="flex justify-between">
              <Text strong>Total:</Text>
              <Text strong>${totalWithShipping.toFixed(2)}</Text>
            </div>
          </Card>
        </div>
      ),
    },
  ];

  const next = async () => {
    try {
      if (currentStep === 0) {
        await shippingForm.validateFields();
      } else if (currentStep === 1) {
        await paymentForm.validateFields();
      }
      setCurrentStep(currentStep + 1);
    } catch (error) {
      console.error('Validation failed:', error);
    }
  };

  const prev = () => {
    setCurrentStep(currentStep - 1);
  };

  const handlePlaceOrder = async () => {
    try {
      const shippingData = await shippingForm.validateFields();
      const paymentData = await paymentForm.validateFields();

      // Here you would typically send the order to your backend
      console.log('Order placed:', {
        shipping: shippingData,
        payment: paymentData,
        items: cartItems,
        total: totalWithShipping,
      });

      message.success('Order placed successfully!');
      navigate('/orders');
    } catch (error) {
      console.error('Order placement failed:', error);
      message.error('Failed to place order. Please try again.');
    }
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <Card>
        <Title level={2}>Checkout</Title>
        <Steps current={currentStep} items={steps.map(s => ({ title: s.title }))} className="mb-8" />
        <div className="mb-8">{steps[currentStep].content}</div>
        <div className="flex justify-end">
          {currentStep > 0 && (
            <Button style={{ marginRight: 8 }} onClick={prev}>
              Previous
            </Button>
          )}
          {currentStep < steps.length - 1 && (
            <Button type="primary" onClick={next}>
              Next
            </Button>
          )}
          {currentStep === steps.length - 1 && (
            <Button type="primary" onClick={handlePlaceOrder}>
              Place Order
            </Button>
          )}
        </div>
      </Card>
    </div>
  );
};

export default CheckoutPage;