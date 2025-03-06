import React, { useState } from "react";
import { Button, Form, Radio, Typography, Space, Card, Divider, InputNumber, Alert } from "antd";
import { FormInstance } from "antd/lib/form";
import { StepBaseProps } from "../../types";
import { WalletOutlined, CreditCardOutlined, BankOutlined } from "@ant-design/icons";

const { Title, Text } = Typography;

export interface PaymentMethodStepProps extends StepBaseProps {
  form: FormInstance;
  walletBalance?: number;
  cartTotal: number;
  onWalletTopup?: (amount: number) => Promise<void>;
}

export const PaymentMethodStep: React.FC<PaymentMethodStepProps> = ({
  form,
  onNext,
  onPrevious,
  walletBalance = 0,
  cartTotal,
  onWalletTopup,
}) => {
  const [selectedPaymentMethod, setSelectedPaymentMethod] = useState<string>("wallet");
  const [topupAmount, setTopupAmount] = useState<number | null>(0);
  const [isProcessing, setIsProcessing] = useState<boolean>(false);
  
  const handlePaymentMethodChange = (e: any) => {
    setSelectedPaymentMethod(e.target.value);
    form.setFieldsValue({ paymentMethod: e.target.value });
  };
  
  const handleTopupChange = (value: number | null) => {
    setTopupAmount(value);
  };
  
  const handleTopup = async () => {
    if (!topupAmount || topupAmount <= 0) return;
    
    setIsProcessing(true);
    try {
      if (onWalletTopup) {
        await onWalletTopup(topupAmount);
      }
    } finally {
      setIsProcessing(false);
    }
  };
  
  const handleContinue = () => {
    form.setFieldsValue({ paymentMethod: selectedPaymentMethod });
    onNext?.();
  };
  
  const insufficientFunds = selectedPaymentMethod === "wallet" && walletBalance < cartTotal;
  
  return (
    <div className="space-y-6">
      <Title level={4}>Payment Method</Title>
      <Text className="text-gray-600 block mb-4">
        Please select your preferred payment method.
      </Text>
      
      <Form.Item 
        name="paymentMethod" 
        initialValue="wallet"
        rules={[{ required: true, message: "Please select a payment method" }]}
      >
        <Radio.Group onChange={handlePaymentMethodChange} value={selectedPaymentMethod} className="w-full">
          <Space direction="vertical" className="w-full">
            <Card 
              className={`w-full cursor-pointer ${selectedPaymentMethod === 'wallet' ? 'border-primary' : ''}`}
              onClick={() => handlePaymentMethodChange({ target: { value: 'wallet' } })}
              hoverable
            >
              <Radio value="wallet">
                <Space>
                  <WalletOutlined className="text-lg" />
                  <span className="font-medium">Wallet</span>
                </Space>
              </Radio>
              <div className="ml-6 mt-2">
                <Text className="block">Current Balance: ${walletBalance.toFixed(2)}</Text>
                {insufficientFunds && (
                  <Alert 
                    message={`Insufficient funds. You need $${(cartTotal - walletBalance).toFixed(2)} more.`}
                    type="warning"
                    className="mt-2"
                    showIcon
                  />
                )}
              </div>
            </Card>
            
            <Card 
              className={`w-full cursor-pointer ${selectedPaymentMethod === 'creditCard' ? 'border-primary' : ''}`}
              onClick={() => handlePaymentMethodChange({ target: { value: 'creditCard' } })}
              hoverable
            >
              <Radio value="creditCard">
                <Space>
                  <CreditCardOutlined className="text-lg" />
                  <span className="font-medium">Credit Card</span>
                </Space>
              </Radio>
            </Card>
            
            <Card 
              className={`w-full cursor-pointer ${selectedPaymentMethod === 'bankTransfer' ? 'border-primary' : ''}`}
              onClick={() => handlePaymentMethodChange({ target: { value: 'bankTransfer' } })}
              hoverable
            >
              <Radio value="bankTransfer">
                <Space>
                  <BankOutlined className="text-lg" />
                  <span className="font-medium">Bank Transfer</span>
                </Space>
              </Radio>
            </Card>
          </Space>
        </Radio.Group>
      </Form.Item>
      
      {selectedPaymentMethod === 'wallet' && insufficientFunds && (
        <div className="bg-gray-50 p-4 rounded-lg">
          <Title level={5}>Add Funds to Wallet</Title>
          <div className="flex items-end gap-4 mt-2">
            <Form.Item label="Amount to Add" className="mb-0 flex-grow">
              <InputNumber
                min={1}
                className="w-full"
                value={topupAmount}
                onChange={handleTopupChange}
                formatter={value => `$ ${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                parser={value => Number(value!.replace(/\$\s?|(,*)/g, ''))}
              />
            </Form.Item>
            <Button 
              type="primary" 
              onClick={handleTopup} 
              loading={isProcessing}
              disabled={!topupAmount || topupAmount <= 0}
            >
              Add Funds
            </Button>
          </div>
        </div>
      )}
      
      <Divider />
      
      <Space className="flex justify-between">
        <Button onClick={onPrevious}>Back to Shipping</Button>
        <Button 
          type="primary" 
          onClick={handleContinue}
          disabled={insufficientFunds}
        >
          Continue to Review
        </Button>
      </Space>
    </div>
  );
}; 