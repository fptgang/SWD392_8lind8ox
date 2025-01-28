import React from 'react';
import { Result, Button } from 'antd';
import { useNavigate } from 'react-router';

export const OrderSuccess: React.FC = () => {
  const navigate = useNavigate();

  return (
    <Result
      status="success"
      title="Order Placed Successfully!"
      subTitle="Thank you for your purchase. Your order has been placed successfully."
      extra={[
        <Button type="primary" key="orders" onClick={() => navigate('/account/orders')}>
          View Orders
        </Button>,
        <Button key="home" onClick={() => navigate('/')}>
          Back to Home
        </Button>,
      ]}
    />
  );
};