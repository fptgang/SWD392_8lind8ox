// components/steps/OrderConfirmationStep.tsx
import React, { useState } from "react";
import { Button, Typography, Descriptions, Space, Alert, Spin, Result, Divider } from "antd";
import { CartItem } from "../../../../store/features/cart/cartSlice";
import OrderSummary from "../OrderSummary";
import { CheckCircleOutlined, WalletOutlined, CreditCardOutlined, BankOutlined } from "@ant-design/icons";
import { ShippingInfoDto, StepBaseProps } from "../../types";

const { Title, Text, Paragraph } = Typography;

interface OrderConfirmationStepProps extends StepBaseProps {
  cartItems: CartItem[];
  summary: {
    itemCount: number;
    subtotal: number;
    savings: number;
    voucherDiscount: number;
    finalTotal: number;
  };
  shippingInfo?: ShippingInfoDto;
  paymentMethod?: string;
  onPlaceOrder?: () => Promise<void>;
  onContinueShopping?: () => void;
}

export const OrderConfirmationStep: React.FC<OrderConfirmationStepProps> = ({
  cartItems,
  summary,
  shippingInfo,
  paymentMethod = "wallet",
  onPlaceOrder,
  onContinueShopping,
  onPrevious,
}) => {
  const { itemCount, subtotal, savings, voucherDiscount, finalTotal } = summary;
  const [orderPlaced, setOrderPlaced] = useState<boolean>(false);
  const [isProcessing, setIsProcessing] = useState<boolean>(false);
  const [orderError, setOrderError] = useState<string | null>(null);
  const [paymentLink, setPaymentLink] = useState<string | null>(null);
  
  const renderPaymentMethodIcon = () => {
    switch (paymentMethod) {
      case "wallet":
        return <WalletOutlined className="text-lg" />;
      case "creditCard":
        return <CreditCardOutlined className="text-lg" />;
      case "bankTransfer":
        return <BankOutlined className="text-lg" />;
      default:
        return null;
    }
  };
  
  const handlePlaceOrder = async () => {
    if (!onPlaceOrder) return;
    
    setIsProcessing(true);
    setOrderError(null);
    
    try {
      await onPlaceOrder();
      setOrderPlaced(true);
      
      // If external payment provider, we might get a payment link back
      if (paymentMethod !== "wallet") {
        setPaymentLink("https://payment-provider.example.com/pay/123456");
      }
    } catch (error: any) {
      setOrderError(error.message || "Failed to place order. Please try again.");
    } finally {
      setIsProcessing(false);
    }
  };
  
  // Show success result after order placement
  if (orderPlaced) {
    return (
      <Result
        status="success"
        title="Order Successfully Placed!"
        subTitle={
          <div>
            <p>Thank you for your purchase. Your order has been confirmed.</p>
            {paymentLink ? (
              <div className="mt-4">
                <Alert
                  message="Complete your payment"
                  description={
                    <div>
                      <p>Please click the button below to complete your payment with our external provider.</p>
                      <Button 
                        type="primary" 
                        href={paymentLink}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="mt-2"
                      >
                        Proceed to Payment
                      </Button>
                    </div>
                  }
                  type="info"
                  showIcon
                />
              </div>
            ) : (
              <p>Your payment has been processed successfully.</p>
            )}
          </div>
        }
        extra={[
          <Button 
            type="primary" 
            key="shopping" 
            onClick={onContinueShopping}
            size="large"
          >
            Continue Shopping
          </Button>
        ]}
      />
    );
  }
  
  if (isProcessing) {
    return (
      <div className="text-center py-12">
        <Spin size="large" />
        <Title level={4} className="mt-4">Processing Your Order</Title>
        <Text className="text-gray-600">
          Please wait while we process your order...
        </Text>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <Title level={4}>Order Confirmation</Title>
      
      {orderError && (
        <Alert
          message="Order Error"
          description={orderError}
          type="error"
          showIcon
          className="mb-6"
        />
      )}
      
      <Alert
        message="Please review your order details before finalizing"
        description="Once you place your order, it will be processed according to our terms and conditions."
        type="info"
        showIcon
        className="mb-6"
      />
      
      {/* Order Summary */}
      <div className="bg-gray-50 p-4 rounded-lg">
        <Title level={5}>Order Summary</Title>
        <OrderSummary
          subtotal={subtotal}
          total={finalTotal}
          discount={savings}
          voucherDiscount={voucherDiscount}
          itemCount={itemCount}
          showCheckoutButton={false}
        />
      </div>
      
      {/* Shipping Information */}
      {shippingInfo && (
        <div className="bg-gray-50 p-4 rounded-lg">
          <Title level={5}>Shipping Information</Title>
          <Descriptions column={1}>
            <Descriptions.Item label="Name">{shippingInfo.name}</Descriptions.Item>
            <Descriptions.Item label="Phone">{shippingInfo.phoneNumber}</Descriptions.Item>
            <Descriptions.Item label="Address">{shippingInfo.address}</Descriptions.Item>
            <Descriptions.Item label="City">{shippingInfo.city}</Descriptions.Item>
            <Descriptions.Item label="District">{shippingInfo.district}</Descriptions.Item>
            <Descriptions.Item label="Ward">{shippingInfo.ward}</Descriptions.Item>
          </Descriptions>
        </div>
      )}
      
      {/* Payment Method */}
      <div className="bg-gray-50 p-4 rounded-lg">
        <Title level={5}>Payment Method</Title>
        <div className="flex items-center gap-2">
          {renderPaymentMethodIcon()}
          <Text>
            {paymentMethod === "wallet" ? "Wallet" : 
             paymentMethod === "creditCard" ? "Credit Card" : 
             paymentMethod === "bankTransfer" ? "Bank Transfer" : "Unknown Method"}
          </Text>
        </div>
      </div>

      <div className="mt-6 p-4 border border-gray-200 rounded-lg bg-gray-50">
        <Title level={5}>By placing this order, you agree to:</Title>
        <ul className="list-disc pl-5 mt-2">
          <li>Our Terms and Conditions</li>
          <li>Privacy Policy</li>
          <li>Refund Policy</li>
        </ul>
      </div>

      <Divider />

      <Space className="flex justify-between mt-8">
        <Button onClick={onPrevious}>Back to Payment</Button>
        <Button 
          type="primary" 
          onClick={handlePlaceOrder}
          className="min-w-[150px]"
          size="large"
          loading={isProcessing}
        >
          Place Order
        </Button>
      </Space>
    </div>
  );
};
