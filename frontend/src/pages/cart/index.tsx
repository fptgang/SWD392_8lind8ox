import React, { useEffect, useState } from "react";
import { useStepsForm } from "@refinedev/antd";
import { Steps, Typography, Empty, Button, Form, notification, Alert } from "antd";
import { useCart } from "../../hooks/useCart";
import { useOrder } from "../../hooks/useOrder";
import CartItemsTable from "./components/CartItemsTable";
import OrderSummary from "./components/OrderSummary";
import { ShippingInfoDto, VoucherDto } from "./types";
import { CartReviewStep } from "./components/steps/CartReviewStep";
import { ShippingStep } from "./components/steps/ShippingStep";
import { OrderConfirmationStep } from "./components/steps/OrderConfirmationStep";
import { useLocation, useNavigate } from "react-router";
import { HttpError } from "@refinedev/core";
import { VoucherStep } from "./components/steps/VoucherStep";
import { PaymentMethodStep } from "./components/steps/PaymentMethodStep";
// Mock import for useWallet since it's not in the attached files
// In a real app, this would be a properly implemented hook
const useWallet = () => ({
  balance: 1000,
  topUp: async (amount: number) => Promise.resolve(),
  loading: false,
  error: null,
  refresh: () => Promise.resolve(),
});

const { Title } = Typography;
const { Step } = Steps;

interface CheckoutFormData {
  voucherCode?: string;
  shippingInfo: ShippingInfoDto;
  paymentMethod: string;
}

interface OrderPayload {
  shippingInfo: ShippingInfoDto;
  paymentMethod: string;
  voucherCode?: string;
}

// Mock type definition for ShippingInfoDto if not available
// This should match the type from generated file
interface MockShippingInfoDto {
  shippingInfoId?: number;
  name: string;
  phoneNumber: string;
  address: string;
  city: string;
  district: string;
  ward: string;
}

const CartPage: React.FC = () => {
  const { 
    cartItems, 
    updateVoucher, 
    updateShippingInfo, 
    getCartSummary, 
    emptyCart,
    removeInvalidItems,
    shippingInfo,
  } = useCart();
  
  const { createOrder } = useOrder();

  const { 
    balance: walletBalance = 0, 
    topUp: walletTopUp 
  } = useWallet();

  const location = useLocation();
  const navigate = useNavigate();
  const [form] = Form.useForm<CheckoutFormData>();
  const [invalidItemsFound, setInvalidItemsFound] = useState(false);
  const [currentStep, setCurrentStep] = useState<number>(0);

  // Check for invalid items
  useEffect(() => {
    const hasInvalidItems = cartItems.some(item => !item.skuId || typeof item.skuId !== 'number');
    setInvalidItemsFound(hasInvalidItems);
  }, [cartItems]);
  
  // Set shipping info in the form if available
  useEffect(() => {
    if (shippingInfo) {
      form.setFieldsValue({
        shippingInfo: {
          name: shippingInfo.name,
          phoneNumber: shippingInfo.phoneNumber,
          address: shippingInfo.address,
          city: shippingInfo.city,
          district: shippingInfo.district,
          ward: shippingInfo.ward,
        }
      });
    }
  }, [form, shippingInfo]);

  // Check if we should go directly to the shipping step
  useEffect(() => {
    // If we have the addShippingInfo query param, go to step 2 (shipping info)
    if (location.search.includes('addShippingInfo=true') && cartItems.length > 0) {
      setCurrentStep(2);
    }
  }, [location.search, cartItems]);

  const {
    formProps,
    stepsProps,
    submit,
    formLoading,
  } = useStepsForm({
    form,
  });

  const gotoStep = (step: number) => {
    setCurrentStep(step);
  };

  const handleVoucherUpdate = async (code: string) => {
    try {
      await updateVoucher({
        code: code,
        discountRate: 0,
        limitAmount: 0
      });
      
      notification.success({
        message: "Voucher applied successfully",
      });
    } catch (error) {
      notification.error({
        message: "Error applying voucher",
      });
    }
  };

  const handleShippingUpdate = async (values: ShippingInfoDto) => {
    try {
      // Ensure all required fields are present
      if (!values.name || !values.phoneNumber || !values.address || !values.city || !values.district || !values.ward) {
        throw new Error("All shipping information fields are required");
      }

      // Create shipping info object with all required fields
      const shippingInfo: ShippingInfoDto = {
        name: values.name,
        phoneNumber: values.phoneNumber,
        address: values.address,
        city: values.city,
        district: values.district,
        ward: values.ward,
        shippingInfoId: values.shippingInfoId,
      };

      await updateShippingInfo(shippingInfo);
      
      // If we came here from checkout, go back to checkout
      if (location.search.includes('addShippingInfo=true')) {
        navigate('/checkout');
        return;
      }
      
      // If in normal flow, proceed to payment method
      gotoStep(3);
    } catch (error: any) {
      notification.error({
        message: "Error updating shipping information",
        description: error.message || "Please check your shipping information and try again",
      });
    }
  };

  const handleWalletTopup = async (amount: number) => {
    try {
      await walletTopUp(amount);
      notification.success({
        message: "Wallet topped up successfully",
      });
    } catch (error) {
      notification.error({
        message: "Failed to top up wallet",
      });
    }
  };
  
  const handlePlaceOrder = async () => {
    try { 
      const values = form.getFieldsValue();
      const orderPayload = {
        shippingInfo: values.shippingInfo,
        voucherCode: values.voucherCode,
        paymentMethod: values.paymentMethod,
      };
      
      const result = await createOrder(orderPayload);
      
      if (result.success) {
        if (result.paymentUrl) {
          // Redirect to external payment gateway
          window.location.assign(result.paymentUrl);
        } else {
          // Order placed successfully with wallet
          notification.success({
            message: "Order placed successfully",
          });
          emptyCart();
          navigate("/account/orders");
        }
      } else {
        notification.error({
          message: "Failed to place order",
          description: result.error,
        });
      }
    } catch (error: any) {
      notification.error({
        message: "Failed to place order",
        description: error.message || "Something went wrong",
      });
    }
  };

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
          >
            Shop Now
          </Button>
        </div>
      </div>
    );
  }

  const renderCurrentStep = () => {
    if (cartItems.length === 0) {
      return <Empty description="Your cart is empty" />;
    }

    const summary = getCartSummary();

    switch (currentStep) {
      case 0:
        return (
          <CartReviewStep
            cartItems={cartItems}
            onNext={() => gotoStep(1)}
            invalidItemsFound={invalidItemsFound}
            onRemoveInvalidItems={removeInvalidItems}
          />
        );
      case 1:
        return (
          <VoucherStep
            form={form}
            onVoucherUpdate={handleVoucherUpdate}
            onNext={() => gotoStep(2)}
            onPrevious={() => gotoStep(0)}
          />
        );
      case 2:
        return (
          <ShippingStep
            form={form}
            onShippingUpdate={handleShippingUpdate}
            onNext={() => gotoStep(3)}
            onPrevious={() => gotoStep(1)}
          />
        );
      case 3:
        return (
          <PaymentMethodStep
            form={form}
            walletBalance={walletBalance}
            cartTotal={summary.finalTotal}
            onWalletTopup={handleWalletTopup}
            onNext={() => gotoStep(4)}
            onPrevious={() => gotoStep(2)}
          />
        );
      case 4:
        const formValues = form.getFieldsValue();
        return (
          <OrderConfirmationStep
            cartItems={cartItems}
            summary={summary}
            shippingInfo={formValues.shippingInfo}
            paymentMethod={formValues.paymentMethod}
            onPlaceOrder={handlePlaceOrder}
            onContinueShopping={() => {
              emptyCart();
              navigate("/products");
            }}
            onPrevious={() => gotoStep(3)}
          />
        );
      default:
        return null;
    }
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <Title level={2} className="mb-6">Shopping Cart</Title>

      {invalidItemsFound && !location.search.includes('addShippingInfo=true') && (
        <Alert
          type="warning"
          showIcon
          message="Invalid Items Detected"
          description="Some items in your cart are invalid and cannot be processed. Please review your cart and remove them before continuing."
          className="mb-4"
          action={
            <Button type="primary" danger onClick={removeInvalidItems}>
              Remove Invalid Items
            </Button>
          }
        />
      )}

      <Steps current={currentStep} className="mb-8" responsive>
        <Step title="Cart Review" />
        <Step title="Voucher" />
        <Step title="Shipping Info" />
        <Step title="Payment Method" />
        <Step title="Order Confirmation" />
      </Steps>

      <Form {...formProps} layout="vertical">
        {renderCurrentStep()}
      </Form>
    </div>
  );
};

export default CartPage;
