import React from "react";
import { TransactionDtoPaymentMethodEnum } from "../../../../generated";
import { Alert, Card, Radio, Space } from "antd";

interface CheckoutPaymentMethodProps {
  paymentMethod: TransactionDtoPaymentMethodEnum;
  onPaymentMethodChange: (method: TransactionDtoPaymentMethodEnum) => void;
  walletBalance: number;
  total: number;
  discount: number;
}

export const CheckoutPaymentMethod: React.FC<CheckoutPaymentMethodProps> = ({
  paymentMethod,
  onPaymentMethodChange,
  walletBalance,
  total,
  discount,
}) => (
  <Card title="Payment Method" className="shadow-sm">
    <Space direction="vertical" className="w-full">
      <Radio.Group
        value={paymentMethod}
        onChange={(e) => onPaymentMethodChange(e.target.value)}
      >
        <Space direction="vertical">
          <Radio value="PAYPAL">PayPal</Radio>
          <Radio value="VNPAY">VNPay</Radio>
        </Space>
      </Radio.Group>

      {walletBalance < total - discount && (
        <Alert
          type="warning"
          message="Insufficient balance"
          description="Please ensure you have sufficient funds for this transaction."
          className="mt-4"
        />
      )}
    </Space>
  </Card>
);
