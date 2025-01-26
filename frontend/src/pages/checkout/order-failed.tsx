import React from 'react';
import { Result, Button } from 'antd';
import { useNavigate } from 'react-router';

export const OrderFailed: React.FC = () => {
  const navigate = useNavigate();

  return (
    <Result
      status="error"
      title="Order Failed"
      subTitle="Sorry, there was an error processing your order. Please try again."
      extra={[
        <Button type="primary" key="retry" onClick={() => navigate('/checkout')}>
          Try Again
        </Button>,
        <Button key="cart" onClick={() => navigate('/cart')}>
          Back to Cart
        </Button>,
      ]}
    />
  );
};