import React from "react";
import { useTranslation } from "@refinedev/core";
import { List } from "@refinedev/antd";
import { Card, Space } from "antd";
import { ShoppingOutlined } from "@ant-design/icons";
import { OrderTable } from "./components/OrderTable";

const CustomerOrderList: React.FC = () => {
  const { translate } = useTranslation();

  return (
    <List>
      <Card
        title={
          <Space>
            <ShoppingOutlined className="text-primary" />
            <span className="font-medium">
              {translate("orders.titles.list", "My Orders")}
            </span>
          </Space>
        }
      >
        <OrderTable />
      </Card>
    </List>
  );
};

export default CustomerOrderList;
