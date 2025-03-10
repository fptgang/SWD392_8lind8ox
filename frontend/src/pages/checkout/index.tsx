import React, { useEffect, useState } from "react";
import {
  Typography, 
  Empty, 
  Button, 
  Card,
  Form,
  notification, 
  Alert,
  Divider,
  Radio,
  Space,
  Modal,
  Row,
  Col,
  List,
  Spin,
  Tag,
  InputNumber,
  Tooltip
} from "antd";
import { useNavigate, Link } from "react-router";
import { useAppDispatch, useAppSelector } from "../../hooks/useRedux";
import { fetchWalletBalance } from "../../store/features/wallet/walletSlice";
import { clearCart } from "../../store/features/cart/cartSlice";
import { ShippingInfoDto, CartDto, CartItemDto, VoucherDto } from "../../../generated";
import { useForm } from "antd/lib/form/Form";
import { useList, useCreate, useCustomMutation } from "@refinedev/core";
import { 
  PlusOutlined, 
  CheckCircleFilled, 
  EditOutlined, 
  BankOutlined, 
  WalletOutlined, 
  CreditCardOutlined,
  TagOutlined,
  CheckOutlined
} from "@ant-design/icons";
import AddressForm from "./components/AddressForm";

const { Title, Text, Paragraph } = Typography;

interface OrderResponse {
  id: number;
  paymentRedirectUrl?: string;
  status: string;
}

const CheckoutPage: React.FC = () => {
  // Get dispatch and navigate
  const dispatch = useAppDispatch();
  const navigate = useNavigate();
  
  // Get redux state
  const { items: cartItems, total, originalTotal } = useAppSelector(state => state.cart);
  const { balance: walletBalance } = useAppSelector(state => state.wallet);

  // Local state
  const [addressModalVisible, setAddressModalVisible] = useState(false);
  const [voucherModalVisible, setVoucherModalVisible] = useState(false);
  const [selectedAddressId, setSelectedAddressId] = useState<number | null>(null);
  const [selectedVoucherId, setSelectedVoucherId] = useState<number | null>(null);
  const [selectedVoucherCode, setSelectedVoucherCode] = useState<string>("");
  const [selectedVoucherDiscount, setSelectedVoucherDiscount] = useState<number>(0);
  const [paymentMethod, setPaymentMethod] = useState<string>("VNPAY");
  const [createNewAddress, setCreateNewAddress] = useState(false);
  const [orderProcessing, setOrderProcessing] = useState(false);
  const [walletTopupVisible, setWalletTopupVisible] = useState(false);
  const [topupAmount, setTopupAmount] = useState<number>(0);
  const [topupProcessing, setTopupProcessing] = useState(false);
  
  // Form instance
  const [form] = useForm();
  
  // Load disabled items from storage
  const [disabledItemsMap, setDisabledItemsMap] = useState<Record<number, boolean>>({});
  useEffect(() => {
    try {
      const storedDisabledItems = sessionStorage.getItem('disabledCartItems');
      if (storedDisabledItems) {
        setDisabledItemsMap(JSON.parse(storedDisabledItems));
      }
    } catch (error) {
      console.error("Error loading disabled items:", error);
    }
  }, []);
  
  // Calculate active cart items (excluding disabled ones)
  const activeCartItems = cartItems.filter(item => !disabledItemsMap[item.skuId]);
  
  // Fetch shipping addresses
  const { 
    data: shippingAddressesData, 
    isLoading: loadingAddresses,
    refetch: refetchAddresses
  } = useList<ShippingInfoDto>({
    resource: "shipping-info"
  });
  
  // Fetch available vouchers
  const {
    data: vouchersData,
    isLoading: loadingVouchers,
    refetch: refetchVouchers
  } = useList<VoucherDto>({
    resource: "vouchers",
    filters: [
      {
        field: "state",
        operator: "eq",
        value: "ACTIVE"
      }
    ]
  });
  
  const shippingAddresses = shippingAddressesData?.data || [];
  const availableVouchers = vouchersData?.data || [];
  
  // Create new shipping address function
  const { mutateAsync: createShippingAddress } = useCreate<ShippingInfoDto>();
  
  // Create order using custom mutation
  const { mutateAsync: placeOrder } = useCreate<OrderResponse>();
  
  // Wallet top-up mutation
  const { mutateAsync: topUpWallet } = useCustomMutation();
  
  // Fetch wallet balance on component mount
  useEffect(() => {
    dispatch(fetchWalletBalance());
  }, [dispatch]);
  
  // Calculate cart summary
  const getCartSummary = () => {
    // Filter out disabled items
    const itemCount = activeCartItems.reduce((sum, item) => sum + item.quantity, 0);
    const subtotal = activeCartItems.reduce((sum, item) => sum + (item.finalTotal * item.quantity), 0);
    const originalSubtotal = activeCartItems.reduce((sum, item) => sum + (item.subTotal * item.quantity), 0);
    const savings = originalSubtotal - subtotal;
    
    // Calculate voucher discount
    let voucherDiscount = 0;
    if (selectedVoucherId && selectedVoucherDiscount) {
      voucherDiscount = Math.min(subtotal * (selectedVoucherDiscount / 100), subtotal);
    }
    
    const finalTotal = subtotal - voucherDiscount;

    return {
      itemCount,
      subtotal,
      savings,
      voucherDiscount,
      finalTotal,
    };
  };
  
  // Handle address creation
  const handleCreateAddress = async (values: ShippingInfoDto) => {
    try {
      const response = await createShippingAddress({
        resource: "shipping-info",
        values
      });
      
      if (response?.data) {
        notification.success({
          message: "Address added successfully"
        });
        await refetchAddresses();
        // Type check to ensure shippingInfoId is a number before setting
        const shippingInfoId = response.data.shippingInfoId;
        if (typeof shippingInfoId === 'number') {
          setSelectedAddressId(shippingInfoId);
        }
        setCreateNewAddress(false);
        setAddressModalVisible(false);
      }
    } catch (error: any) {
      notification.error({
        message: "Failed to add address",
        description: error.message || "An error occurred while adding the address"
      });
    }
  };
  
  // Handle address selection
  const handleSelectAddress = (addressId: number) => {
    setSelectedAddressId(addressId);
  };
  
  // Handle voucher selection
  const handleSelectVoucher = (voucher: VoucherDto) => {
    if (voucher.voucherId && voucher.code && voucher.discountRate) {
      setSelectedVoucherId(voucher.voucherId);
      setSelectedVoucherCode(voucher.code);
      setSelectedVoucherDiscount(voucher.discountRate);
      notification.success({
        message: "Voucher Applied",
        description: `Voucher "${voucher.code}" applied with ${voucher.discountRate}% discount`
      });
      setVoucherModalVisible(false);
    }
  };
  
  // Handle removing voucher
  const handleRemoveVoucher = () => {
    setSelectedVoucherId(null);
    setSelectedVoucherCode("");
    setSelectedVoucherDiscount(0);
    notification.info({
      message: "Voucher Removed"
    });
  };
  
  // Handle payment method change
  const handlePaymentMethodChange = (e: any) => {
    setPaymentMethod(e.target.value);
  };
  
  // Handle wallet top-up
  const handleWalletTopup = async () => {
    if (topupAmount <= 0) {
      notification.error({
        message: "Invalid amount",
        description: "Please enter an amount greater than 0"
      });
      return;
    }
    
    setTopupProcessing(true);
    
    try {
      await topUpWallet({
        url: "wallet/topup",
        method: "post",
        values: {
          amount: topupAmount
        }
      });
      
      notification.success({
        message: "Wallet topped up successfully",
        description: `Added $${topupAmount.toFixed(2)} to your wallet`
      });
      
      // Refresh wallet balance
      dispatch(fetchWalletBalance());
      setWalletTopupVisible(false);
      setTopupAmount(0);
    } catch (error: any) {
      notification.error({
        message: "Failed to top up wallet",
        description: error.message || "An error occurred while topping up your wallet"
      });
    } finally {
      setTopupProcessing(false);
    }
  };
  
  // Handle place order
  const handlePlaceOrder = async () => {
    // Validate if an address is selected
    if (!selectedAddressId) {
      notification.error({
        message: "Shipping address required",
        description: "Please select a shipping address to continue"
      });
      return;
    }
    
    // Check if there are items in the cart
    if (activeCartItems.length === 0) {
      notification.error({
        message: "Cart is empty",
        description: "Please add items to your cart before placing an order"
      });
      return;
    }
    
    setOrderProcessing(true);
    
    try {
      // Create order payload according to the generated CartDto format
      const orderItems: CartItemDto[] = activeCartItems.map(item => ({
        skuId: item.skuId,
        quantity: item.quantity
      }));
      
      const cartPayload: CartDto = {
        items: orderItems,
        shippingInfoId: selectedAddressId,
        voucherId: selectedVoucherId || undefined,
        paymentMethod: paymentMethod as any // Type casting since enum is expected
      };
      
      // Place order using the custom mutation
      const response = await placeOrder({
        resource: "orders",
        values: cartPayload
      });
      
      // Check if it's an external payment (has a payment URL)
      if (response.data?.paymentRedirectUrl) {
        // Redirect to external payment gateway
        window.location.assign(response.data.paymentRedirectUrl);
        notification.info({
          message: "Redirecting to payment gateway",
          description: "Please complete your payment to finalize the order."
        });
      } else {
        // Order placed successfully with wallet
        notification.success({
          message: "Order placed successfully",
          description: "Your order has been placed and will be processed shortly."
        });
        
        dispatch(clearCart());
        // Clear the disabled items from session storage
        sessionStorage.removeItem('disabledCartItems');
        // navigate("/account/orders");
      }
    } catch (error: any) {
      const errorMessage = error?.response?.data?.message || error.message || "Something went wrong while placing your order. Please try again.";
      notification.error({
        message: "Failed to place order",
        description: errorMessage
      });
    } finally {
      setOrderProcessing(false);
    }
  };

  // Render empty cart message if cart is empty
  if (activeCartItems.length === 0) {
    return (
      <div className="container mx-auto px-4 py-8">
        <Empty
          description={
            <span className="text-gray-600">
              {cartItems.length > 0 
                ? "All items are disabled for checkout. Please enable at least one item."
                : "Your cart is empty"
              }
            </span>
          }
          className="my-8"
        />
        <div className="text-center">
          <Button
            type="primary"
            onClick={() => navigate("/cart")}
            size="large"
          >
            Return to Cart
          </Button>
        </div>
      </div>
    );
  }

  const summary = getCartSummary();

  return (
    <div className="container mx-auto px-4 py-8">
      <Title level={2} className="mb-6">Checkout</Title>

      <Row gutter={24}>
        {/* Left Column - Order Items & Payment */}
        <Col xs={24} lg={16}>
          {/* Order Items */}
          <Card title="Order Items" className="mb-4">
            <List
              dataSource={activeCartItems}
              renderItem={item => (
                <List.Item
                  key={item.skuId}
                  extra={
                    <div className="text-right">
                      <Text strong>${(item.finalTotal * item.quantity).toFixed(2)}</Text>
                      <br />
                      <Text type="secondary">{item.quantity} x ${item.finalTotal.toFixed(2)}</Text>
                    </div>
                  }
                >
                  <List.Item.Meta
                    avatar={
                      <img 
                        src={item.skuImageUrl || item.imageUrl || 'https://placehold.co/60'} 
                        alt={item.name} 
                        style={{ width: 60, height: 60, objectFit: 'cover' }}
                        className="rounded-md"
                      />
                    }
                    title={
                      <div>
                        <div>{item.name}</div>
                        {item.skuName && <div className="text-xs text-gray-500">Variant: {item.skuName}</div>}
                      </div>
                    }
                    description={
                      item.subTotal > item.finalTotal ? (
                        <Space>
                          <Text delete className="text-gray-500">
                            ${item.subTotal.toFixed(2)}
                          </Text>
                          <Tag color="red">
                            {Math.round((1 - item.finalTotal / item.subTotal) * 100)}% OFF
                          </Tag>
                        </Space>
                      ) : (
                        <Text>${item.finalTotal.toFixed(2)}</Text>
                      )
                    }
                  />
                </List.Item>
              )}
            />

            <div className="mt-4 text-right">
              <Link to="/cart" className="text-blue-500">Edit Cart</Link>
            </div>
          </Card>

          {/* Voucher Section */}
          <Card title="Voucher" className="mb-4">
            {selectedVoucherId ? (
              <div className="flex items-center justify-between">
                <div>
                  <div className="flex items-center">
                    <Tag color="green" className="mr-2">
                      <CheckOutlined /> Applied
                    </Tag>
                    <Text strong>{selectedVoucherCode}</Text>
                  </div>
                  <Text type="success">
                    {selectedVoucherDiscount}% discount saved ${summary.voucherDiscount.toFixed(2)}
                  </Text>
                </div>
                <Button 
                  danger 
                  onClick={handleRemoveVoucher}
                >
                  Remove
                </Button>
              </div>
            ) : (
              <div className="flex items-center justify-between">
                <Text className="text-gray-500">No voucher applied</Text>
                <Button 
                  type="primary" 
                  icon={<TagOutlined />}
                  onClick={() => setVoucherModalVisible(true)}
                >
                  Select Voucher
                </Button>
              </div>
            )}
          </Card>

          {/* Shipping Address */}
          <Card title="Shipping Address" className="mb-4">
            {loadingAddresses ? (
              <div className="flex justify-center items-center p-6">
                <Spin tip="Loading addresses..." />
              </div>
            ) : shippingAddresses.length > 0 ? (
              <div>
                <List
                  dataSource={shippingAddresses}
                  renderItem={(address: ShippingInfoDto) => (
                    <List.Item
                      className={`cursor-pointer rounded-lg transition-all hover:bg-gray-50 ${selectedAddressId === address.shippingInfoId ? 'bg-blue-50 border-blue-200' : ''}`}
                      onClick={() => handleSelectAddress(address.shippingInfoId as number)}
                      actions={[
                        <Button 
                          key="edit"
                          type="text" 
                          icon={<EditOutlined />} 
                          onClick={(e) => {
                            e.stopPropagation();
                            // Implement edit functionality here
                          }}
                        />
                      ]}
                    >
                      <div className="flex items-center w-full">
                        <div className="mr-3">
                          {selectedAddressId === address.shippingInfoId && (
                            <CheckCircleFilled className="text-blue-500 text-lg" />
                          )}
                        </div>
                        <div>
                          <div className="font-medium">{address.name}</div>
                          <div>{address.phoneNumber}</div>
                          <div className="text-gray-500">
                            {address.address}, {address.ward}, {address.district}, {address.city}
                          </div>
                        </div>
                      </div>
                    </List.Item>
                  )}
                />
                <div className="mt-4">
                  <Button 
                    icon={<PlusOutlined />} 
                    onClick={() => {
                      setCreateNewAddress(true);
                      setAddressModalVisible(true);
                    }}
                  >
                    Add New Address
                  </Button>
                </div>
              </div>
            ) : (
              <div className="text-center py-6">
                <Paragraph className="mb-4">You don't have any saved addresses.</Paragraph>
                <Button 
                  type="primary" 
                  icon={<PlusOutlined />}
                  onClick={() => {
                    setCreateNewAddress(true);
                    setAddressModalVisible(true);
                  }}
                >
                  Add New Address
                </Button>
              </div>
            )}
          </Card>

          {/* Payment Method */}
          <Card title="Payment Method" className="mb-4">
            <Radio.Group onChange={handlePaymentMethodChange} value={paymentMethod}>
              <Space direction="vertical" className="w-full">
                <Radio value="VNPAY" className="p-3 border rounded-lg w-full">
                  <div className="flex items-center">
                    <BankOutlined className="mr-2 text-lg" />
                    <div>
                      <div>VNPAY</div>
                      <div className="text-xs text-gray-500">Pay via VNPAY gateway</div>
                    </div>
                  </div>
                </Radio>
                
                <Radio value="PAYPAL" className="p-3 border rounded-lg w-full">
                  <div className="flex items-center">
                    <CreditCardOutlined className="mr-2 text-lg" />
                    <div>
                      <div>PayPal / Credit Card</div>
                      <div className="text-xs text-gray-500">Pay with international cards via PayPal</div>
                    </div>
                  </div>
                </Radio>
                
                <Radio 
                  value="WALLET" 
                  className="p-3 border rounded-lg w-full"
                  disabled={walletBalance < summary.finalTotal}
                >
                  <div className="flex items-center justify-between w-full">
                    <div className="flex items-center">
                      <WalletOutlined className="mr-2 text-lg" />
                      <div>
                        <div>Wallet</div>
                        <div className="text-xs text-gray-500">
                          Available balance: ${walletBalance.toFixed(2)}
                          {walletBalance < summary.finalTotal && (
                            <span className="text-red-500 ml-2">Insufficient balance</span>
                          )}
                        </div>
                      </div>
                    </div>
                    <Button 
                      type="link"
                      onClick={(e) => {
                        e.stopPropagation(); // Prevent radio selection
                        setWalletTopupVisible(true);
                      }}
                    >
                      Top up
                    </Button>
                  </div>
                </Radio>
              </Space>
            </Radio.Group>
          </Card>
        </Col>
        
        {/* Right Column - Order Summary */}
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
              
              {summary.voucherDiscount > 0 && (
                <div className="flex justify-between text-green-600">
                  <Text type="success">Voucher Discount:</Text>
                  <Text type="success">-${summary.voucherDiscount.toFixed(2)}</Text>
                </div>
              )}
              
              <Divider />
              
              <div className="flex justify-between">
                <Text strong className="text-lg">Total:</Text>
                <Text strong className="text-lg">${summary.finalTotal.toFixed(2)}</Text>
              </div>
              
              <div className="pt-4">
                <Button 
                  type="primary" 
                  size="large" 
                  block
                  onClick={handlePlaceOrder}
                  loading={orderProcessing}
                  disabled={!selectedAddressId}
                >
                  Place Order
                </Button>
                
                <Button 
                  type="link" 
                  block 
                  onClick={() => navigate("/cart")}
                  className="mt-2"
                >
                  Return to Cart
                </Button>
              </div>
              
              {!selectedAddressId && (
                <Alert
                  type="warning"
                  message="Shipping Address Required"
                  description="Please select a shipping address to continue."
                  className="mt-4"
                />
              )}
            </div>
          </Card>
        </Col>
      </Row>
      
      {/* Address Modal */}
      <Modal
        title={createNewAddress ? "Add New Address" : "Select Address"}
        open={addressModalVisible}
        onCancel={() => setAddressModalVisible(false)}
        footer={null}
        width={600}
      >
        {createNewAddress ? (
          <AddressForm onSubmit={handleCreateAddress} onCancel={() => setAddressModalVisible(false)} />
        ) : (
          <div>
            {/* Address selection would go here, but we're handling it in the main UI */}
            <Button onClick={() => setAddressModalVisible(false)}>Close</Button>
          </div>
        )}
      </Modal>
      
      {/* Voucher Modal */}
      <Modal
        title="Select Voucher"
        open={voucherModalVisible}
        onCancel={() => setVoucherModalVisible(false)}
        footer={[
          <Button key="cancel" onClick={() => setVoucherModalVisible(false)}>
            Cancel
          </Button>
        ]}
        width={600}
      >
        {loadingVouchers ? (
          <div className="flex justify-center items-center p-6">
            <Spin tip="Loading vouchers..." />
          </div>
        ) : availableVouchers.length > 0 ? (
          <List
            dataSource={availableVouchers}
            renderItem={(voucher: VoucherDto) => {
              // Calculate potential discount
              const discountAmount = voucher.discountRate ? 
                Math.min(summary.subtotal * (voucher.discountRate / 100), voucher.limitAmount || summary.subtotal) : 
                0;
                
              return (
                <List.Item
                  className={`cursor-pointer rounded-lg transition-all hover:bg-gray-50 ${selectedVoucherId === voucher.voucherId ? 'bg-green-50 border-green-200' : ''}`}
                  onClick={() => handleSelectVoucher(voucher)}
                  actions={[
                    <Button 
                      key="select"
                      type="primary"
                      size="small"
                      onClick={(e) => {
                        e.stopPropagation();
                        handleSelectVoucher(voucher);
                      }}
                    >
                      Select
                    </Button>
                  ]}
                >
                  <div className="flex items-start w-full">
                    <div className="mr-4 flex-shrink-0 bg-blue-100 rounded-md p-2 text-blue-600">
                      <TagOutlined style={{ fontSize: '24px' }} />
                    </div>
                    <div className="flex-grow">
                      <div className="flex justify-between">
                        <div>
                          <Title level={5} className="mb-0">{voucher.code}</Title>
                          <Text type="secondary">
                            {voucher.description || `${voucher.discountRate}% discount up to $${voucher.limitAmount?.toFixed(2) || 'unlimited'}`}
                          </Text>
                        </div>
                        <div className="text-right">
                          <Text type="success" strong>${discountAmount.toFixed(2)}</Text>
                          <div>
                            <Text type="secondary">Potential savings</Text>
                          </div>
                        </div>
                      </div>
                      
                      {voucher.expiresAt && (
                        <div className="mt-2">
                          <Text type="secondary">
                            Expires: {new Date(voucher.expiresAt).toLocaleDateString()}
                          </Text>
                        </div>
                      )}
                    </div>
                  </div>
                </List.Item>
              );
            }}
          />
        ) : (
          <Empty description="No vouchers available at the moment" />
        )}
      </Modal>
      
      {/* Wallet Top-up Modal */}
      <Modal
        title="Top Up Wallet"
        open={walletTopupVisible}
        onCancel={() => setWalletTopupVisible(false)}
        footer={[
          <Button key="cancel" onClick={() => setWalletTopupVisible(false)}>
            Cancel
          </Button>,
          <Button 
            key="submit" 
            type="primary" 
            loading={topupProcessing}
            onClick={handleWalletTopup}
            disabled={topupAmount <= 0}
          >
            Top Up
          </Button>
        ]}
      >
        <div className="py-4">
          <div className="mb-4">
            <Text>Current Balance: ${walletBalance.toFixed(2)}</Text>
          </div>
          <div className="mb-4">
            <Text>Enter Amount:</Text>
            <InputNumber
              className="w-full mt-2"
              min={1}
              step={10}
              formatter={value => `$ ${value}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
              parser={value => parseFloat(value!.replace(/\$\s?|(,*)/g, ''))}
              value={topupAmount}
              onChange={(value) => setTopupAmount(value || 0)}
            />
          </div>
          {summary.finalTotal > walletBalance && (
            <Alert
              type="info"
              message={`To complete your order with wallet, you need to top up at least $${(summary.finalTotal - walletBalance).toFixed(2)}`}
              className="mt-2"
            />
          )}
        </div>
      </Modal>
    </div>
  );
};

export default CheckoutPage;
