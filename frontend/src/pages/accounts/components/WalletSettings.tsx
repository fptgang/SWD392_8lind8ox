import React from "react";
import { Card, Typography, Statistic, Button, Space, List } from "antd";
import { WalletOutlined, ReloadOutlined } from "@ant-design/icons";
import { useGetIdentity } from "@refinedev/core";
import { AccountDto } from "../../../../generated";
import { formatCurrency } from "../../../utils/currency-formatter";

const { Title } = Typography;

export const WalletSettings: React.FC = () => {
  // Mock data - replace with actual API calls
  const {data:me} = useGetIdentity<AccountDto>();
  const transactions = [
    {
      id: 1,
      type: "deposit",
      amount: 500,
      date: "2024-01-15",
      status: "completed",
    },
    {
      id: 2,
      type: "withdrawal",
      amount: 200,
      date: "2024-01-14",
      status: "completed",
    },
  ];

  return (
    <div>
      <Title level={4}>Wallet</Title>
      <Space direction="vertical" size="large" style={{ width: "100%" }}>
        <Card>
          <Statistic
            title="Current Balance"
            value={formatCurrency(me?.balance || 0)}
            prefix={<WalletOutlined />}
            precision={2}
            suffix="USD"
          />
          <Space style={{ marginTop: 16 }}>
            <Button type="primary">Add Funds</Button>
            <Button>Withdraw</Button>
            <Button icon={<ReloadOutlined />}>Refresh</Button>
          </Space>
        </Card>

        <Card title="Recent Transactions">
          <List
            dataSource={transactions}
            renderItem={(item) => (
              <List.Item
                key={item.id}
                extra={[
                  <Typography.Text
                    type={item.type === "deposit" ? "success" : "danger"}
                    key="amount"
                  >
                    {item.type === "deposit" ? "+" : "-"}${item.amount}
                  </Typography.Text>,
                ]}
              >
                <List.Item.Meta
                  title={`${item.type.charAt(0).toUpperCase() + item.type.slice(1)}`}
                  description={item.date}
                />
              </List.Item>
            )}
          />
        </Card>
      </Space>
    </div>
  );
};

export default WalletSettings;