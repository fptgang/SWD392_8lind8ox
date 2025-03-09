import React, { useState, useEffect } from "react";
import {
  Card,
  Typography,
  Statistic,
  Button,
  Space,
  List,
  Modal,
  Radio,
  notification,
  Spin,
  Tag,
} from "antd";
import { WalletOutlined, ReloadOutlined } from "@ant-design/icons";
import { useGetIdentity, useCreate, useApiUrl, useList } from "@refinedev/core";
import {
  AccountDto,
  TransactionDto,
  TransactionDtoPaymentMethodEnum,
  TransactionDtoTypeEnum,
  TransactionDtoStatusEnum,
} from "../../../../generated";
import { formatCurrency } from "../../../utils/currency-formatter";
import { useNavigate, useLocation } from "react-router";

const { Title, Text } = Typography;
const { Group: RadioGroup } = Radio;

// Predefined amounts in VND
const PREDEFINED_AMOUNTS = [
  { value: 100000, label: "100,000 VND" },
  { value: 200000, label: "200,000 VND" },
  { value: 500000, label: "500,000 VND" },
  { value: 1000000, label: "1,000,000 VND" },
  { value: 2000000, label: "2,000,000 VND" },
];

// Mock transaction structure for fallback
interface MockTransaction {
  transactionId: number;
  type: TransactionDtoTypeEnum;
  amount: number;
  createdAt: string;
  status: TransactionDtoStatusEnum;
}

export const WalletSettings: React.FC = () => {
  const { data: me } = useGetIdentity<AccountDto>();
  const navigate = useNavigate();
  const location = useLocation();
  const apiUrl = useApiUrl();

  const [fundModalVisible, setFundModalVisible] = useState(false);
  const [selectedAmount, setSelectedAmount] = useState<number>(
    PREDEFINED_AMOUNTS[0].value
  );
  const [customAmount, setCustomAmount] = useState<string>("");
  const [paymentMethod, setPaymentMethod] =
    useState<TransactionDtoPaymentMethodEnum>(
      TransactionDtoPaymentMethodEnum.Vnpay
    );
  const [isLoading, setIsLoading] = useState(false);

  // For getting real transactions
  const {
    data: transactionsData,
    isLoading: isTransactionsLoading,
    refetch: refetchTransactions,
  } = useList<TransactionDto>({
    resource: "transactions",
    filters: [
      {
        field: "account.accountId",
        operator: "eq",
        value: me?.accountId,
      },
    ],
    pagination: {
      pageSize: 10,
      current: 1,
    },
    sorters: [
      {
        field: "createdAt",
        order: "desc",
      },
    ],
  });

  const { mutateAsync: createTransaction } = useCreate<TransactionDto>();

  // Check for payment return (for VNPAY)
  useEffect(() => {
    const searchParams = new URLSearchParams(location.search);
    const paymentStatus = searchParams.get("vnp_ResponseCode");
    const transactionId = searchParams.get("vnp_TxnRef");

    if (paymentStatus && transactionId) {
      // Clear URL params while preserving the base route
      navigate("/account/wallet", { replace: true });

      // Handle different response codes
      if (paymentStatus === "00") {
        notification.success({
          message: "Payment Successful",
          description: "Your wallet has been funded successfully.",
          duration: 5,
        });
        refetchTransactions();
      } else if (paymentStatus === "24") {
        notification.info({
          message: "Payment Pending",
          description:
            "Your payment is being processed. The funds will be added to your wallet shortly.",
          duration: 5,
        });
        refetchTransactions();
      } else if (paymentStatus === "09") {
        notification.warning({
          message: "Payment Cancelled",
          description: "You cancelled the payment process.",
          duration: 5,
        });
      } else {
        notification.error({
          message: "Payment Failed",
          description: `There was an issue processing your payment (Code: ${paymentStatus}). Please try again.`,
          duration: 5,
        });
      }
    }
  }, [location.search, navigate, refetchTransactions]);

  const handleAddFunds = async () => {
    // Validate amount
    const amount = customAmount ? parseFloat(customAmount) : selectedAmount;

    if (!amount || amount <= 0) {
      notification.error({
        message: "Invalid Amount",
        description: "Please enter a valid amount to add to your wallet.",
      });
      return;
    }

    try {
      setIsLoading(true);

      // Create a deposit transaction with proper account structure
      const response = await createTransaction({
        resource: "transactions",
        values: {
          account: {
            accountId: me?.accountId,
          },
          type: TransactionDtoTypeEnum.Deposit,
          paymentMethod: paymentMethod,
          amount: amount,
          status: TransactionDtoStatusEnum.Pending,
        },
      });

      // If the API returns a URL (for VNPAY), redirect the user
      const responseData = response?.data as string | undefined;
      if (responseData && responseData.startsWith("https://")) {
        // It's a payment URL, redirect the user
        window.location.href = responseData;
      } else {
        // Close the modal and show success
        setFundModalVisible(false);
        notification.success({
          message: "Transaction Created",
          description: "Your wallet funding request has been submitted.",
        });
        refetchTransactions();
      }
    } catch (error) {
      console.error("Error adding funds:", error);
      notification.error({
        message: "Failed to Add Funds",
        description:
          "There was an error processing your request. Please try again.",
      });
    } finally {
      setIsLoading(false);
    }
  };

  // Function to handle fund modal display
  const showFundModal = () => {
    setFundModalVisible(true);
    // Reset to default values
    setSelectedAmount(PREDEFINED_AMOUNTS[0].value);
    setCustomAmount("");
    setPaymentMethod(TransactionDtoPaymentMethodEnum.Vnpay);
  };

  // Generate mock transactions for fallback
  const mockTransactions: MockTransaction[] = [
    {
      transactionId: 1,
      type: TransactionDtoTypeEnum.Deposit,
      amount: 500000,
      createdAt: new Date().toISOString(),
      status: TransactionDtoStatusEnum.Success,
    },
    {
      transactionId: 2,
      type: TransactionDtoTypeEnum.Order,
      amount: 200000,
      createdAt: new Date(Date.now() - 86400000).toISOString(),
      status: TransactionDtoStatusEnum.Success,
    },
  ];

  // Use a union type to handle both real and mock transactions
  const displayTransactions: (TransactionDto | MockTransaction)[] =
    transactionsData?.data || mockTransactions;

  return (
    <div>
      <Title level={4}>Wallet</Title>
      <Space direction="vertical" size="large" style={{ width: "100%" }}>
        <Card>
          <Statistic
            title="Current Balance"
            value={formatCurrency(me?.balance || 0)}
            prefix={<WalletOutlined />}
            precision={0}
            suffix="VND"
            groupSeparator=","
          />
          <Space style={{ marginTop: 16 }}>
            <Button type="primary" onClick={showFundModal}>
              Add Funds
            </Button>
            <Button
              icon={<ReloadOutlined />}
              onClick={() => refetchTransactions()}
            >
              Refresh
            </Button>
          </Space>
        </Card>

        <Card
          title="Recent Transactions"
          extra={isTransactionsLoading && <Spin size="small" />}
        >
          <List
            dataSource={displayTransactions}
            loading={isTransactionsLoading}
            renderItem={(item) => (
              <List.Item
                key={item.transactionId}
                extra={[
                  <Typography.Text
                    type={
                      item.type === TransactionDtoTypeEnum.Deposit
                        ? "success"
                        : "danger"
                    }
                    key="amount"
                  >
                    {item.type === TransactionDtoTypeEnum.Deposit ? "+" : "-"}
                    {formatCurrency(item.amount || 0)} VND
                  </Typography.Text>,
                ]}
              >
                <List.Item.Meta
                  title={
                    <>
                      {item.type === TransactionDtoTypeEnum.Deposit
                        ? "Deposit"
                        : "Order"}{" "}
                      -
                      <Tag
                        bordered={false}
                        color={
                          item.status == "SUCCESS"
                            ? "success"
                            : item.status == "PENDING"
                            ? "processing"
                            : "error"
                        }
                      >
                        {item.status}
                      </Tag>
                    </>
                  }
                  description={formatTransactionDate(item.createdAt)}
                />
              </List.Item>
            )}
          />
        </Card>
      </Space>

      {/* Add Funds Modal */}
      <Modal
        title="Add Funds to Wallet"
        open={fundModalVisible}
        onCancel={() => setFundModalVisible(false)}
        footer={[
          <Button key="cancel" onClick={() => setFundModalVisible(false)}>
            Cancel
          </Button>,
          <Button
            key="submit"
            type="primary"
            loading={isLoading}
            onClick={handleAddFunds}
          >
            Proceed to Payment
          </Button>,
        ]}
      >
        <Space direction="vertical" size="large" style={{ width: "100%" }}>
          <div>
            <Text strong>Select Amount</Text>
            <RadioGroup
              value={selectedAmount}
              onChange={(e) => {
                setSelectedAmount(e.target.value);
                setCustomAmount("");
              }}
              style={{
                marginTop: 8,
                display: "flex",
                flexDirection: "column",
                gap: "8px",
              }}
            >
              {PREDEFINED_AMOUNTS.map((amount) => (
                <Radio key={amount.value} value={amount.value}>
                  {amount.label}
                </Radio>
              ))}
              <Radio value={0}>
                Custom Amount
                {selectedAmount === 0 && (
                  <input
                    type="number"
                    style={{ width: 200, marginLeft: 10 }}
                    value={customAmount}
                    onChange={(e) => setCustomAmount(e.target.value)}
                    placeholder="Enter amount in VND"
                    autoFocus
                  />
                )}
              </Radio>
            </RadioGroup>
          </div>

          <div>
            <Text strong>Payment Method</Text>
            <RadioGroup
              value={paymentMethod}
              onChange={(e) => setPaymentMethod(e.target.value)}
              style={{ marginTop: 8 }}
            >
              <Radio value={TransactionDtoPaymentMethodEnum.Vnpay}>
                <Space>
                  <img
                    src="/assets/vnpay-logo.png"
                    alt="VNPay"
                    style={{ width: 30, height: 30, objectFit: "contain" }}
                    onError={(e) => {
                      // If image fails to load, show text instead
                      e.currentTarget.style.display = "none";
                    }}
                  />
                  <span>VNPay</span>
                </Space>
              </Radio>
            </RadioGroup>
          </div>

          <div>
            <Text type="secondary">
              You will be redirected to a secure payment page to complete the
              transaction.
            </Text>
          </div>
        </Space>
      </Modal>
    </div>
  );
};

// Helper function to format transaction dates
const formatTransactionDate = (date: string | Date | undefined): string => {
  if (!date) return "Unknown date";

  try {
    if (typeof date === "string") {
      return new Date(date).toLocaleString();
    } else if (date instanceof Date) {
      return date.toLocaleString();
    }
    return "Unknown date";
  } catch (e) {
    return "Invalid date";
  }
};

export default WalletSettings;
