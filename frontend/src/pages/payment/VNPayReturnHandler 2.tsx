import React, { useEffect, useState } from "react";
import { useNavigate, useLocation } from "react-router";
import { Card, Typography, Result, Spin, Space, Button } from "antd";
import { useGetIdentity } from "@refinedev/core";
import { AccountDto } from "../../../generated";
import { formatCurrency } from "../../utils/currency-formatter";
import { LoadingOutlined, InfoCircleOutlined, CheckCircleOutlined } from "@ant-design/icons";

const { Text, Paragraph } = Typography;

interface VNPayResponse {
  amount: number;
  bankCode: string;
  cardType: string;
  orderInfo: string;
  responseCode: string;
  transactionNo: string;
  transactionStatus: string;
  txnRef: string;
  secureHash: string;
}

export const VNPayReturnHandler: React.FC = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const { data: me } = useGetIdentity<AccountDto>();
  const [isProcessing, setIsProcessing] = useState(true);
  const [paymentResponse, setPaymentResponse] = useState<VNPayResponse | null>(null);

  useEffect(() => {
    // Parse query parameters
    const searchParams = new URLSearchParams(location.search);
    
    const response: VNPayResponse = {
      amount: parseInt(searchParams.get("vnp_Amount") || "0") / 100, // Convert amount from smaller units
      bankCode: searchParams.get("vnp_BankCode") || "",
      cardType: searchParams.get("vnp_CardType") || "",
      orderInfo: searchParams.get("vnp_OrderInfo") || "",
      responseCode: searchParams.get("vnp_ResponseCode") || "",
      transactionNo: searchParams.get("vnp_TransactionNo") || "",
      transactionStatus: searchParams.get("vnp_TransactionStatus") || "",
      txnRef: searchParams.get("vnp_TxnRef") || "",
      secureHash: searchParams.get("vnp_SecureHash") || "",
    };
    
    setPaymentResponse(response);
    
    // Simulate a brief delay for user to see the result
    setTimeout(() => {
      setIsProcessing(false);
    }, 1500);
  }, [location.search]);
  
  // Function to render appropriate results based on response code
  const renderResult = () => {
    if (!paymentResponse) {
      return (
        <Result
          icon={<InfoCircleOutlined />}
          title="Invalid Payment Response"
          subTitle="No payment information was received. Please contact support if you believe this is an error."
        />
      );
    }
    
    const { responseCode, amount } = paymentResponse;
    
    switch (responseCode) {
      case "00":
        return (
          <Result
            status="success"
            icon={<CheckCircleOutlined />}
            title="Payment Successful"
            subTitle={`Your payment of ${formatCurrency(amount)} VND has been processed successfully!`}
            extra={[
              <Paragraph key="info">
                The funds have been added to your wallet balance.
              </Paragraph>
            ]}
          />
        );
        
      case "24":
        return (
          <Result
            icon={<InfoCircleOutlined style={{ color: "#1890ff" }} />}
            title="Payment Pending"
            subTitle={`Your payment of ${formatCurrency(amount)} VND is being processed.`}
            extra={[
              <Paragraph key="info">
                The transaction is currently pending. Your wallet will be updated once the payment is confirmed.
              </Paragraph>
            ]}
          />
        );
        
      case "09":
        return (
          <Result
            icon={<InfoCircleOutlined style={{ color: "#faad14" }} />}
            title="Payment Cancelled"
            subTitle="You've cancelled the payment process."
            extra={[
              <Paragraph key="info">
                No charges have been made to your account.
              </Paragraph>
            ]}
          />
        );
        
      default:
        return (
          <Result
            status="error"
            title="Payment Failed"
            subTitle={`There was an issue processing your payment of ${formatCurrency(amount)} VND.`}
            extra={[
              <Paragraph key="code">
                Error Code: {responseCode}
              </Paragraph>,
              <Paragraph key="info">
                Please try again or contact customer support if the issue persists.
              </Paragraph>
            ]}
          />
        );
    }
  };
  
  // Auto-redirect to wallet after 5 seconds
  useEffect(() => {
    if (!isProcessing) {
      const timer = setTimeout(() => {
        navigate("/account/wallet");
      }, 5000);
      
      return () => clearTimeout(timer);
    }
  }, [isProcessing, navigate]);
  
  return (
    <div style={{ maxWidth: 800, margin: "0 auto", padding: "40px 16px" }}>
      <Card>
        {isProcessing ? (
          <div style={{ textAlign: "center", padding: "40px 0" }}>
            <Spin 
              indicator={<LoadingOutlined style={{ fontSize: 36 }} spin />} 
              tip="Processing your payment..." 
              size="large"
            />
          </div>
        ) : (
          <>
            {renderResult()}
            <div style={{ textAlign: "center", marginTop: 24 }}>
              <Space>
                <Button type="primary" onClick={() => navigate("/account/wallet")}>
                  Return to Wallet
                </Button>
                <Button onClick={() => navigate("/")}>
                  Go to Homepage
                </Button>
              </Space>
              <Paragraph style={{ marginTop: 16 }}>
                <Text type="secondary">You'll be automatically redirected in 5 seconds...</Text>
              </Paragraph>
            </div>
          </>
        )}
      </Card>
    </div>
  );
};

export default VNPayReturnHandler; 