import React, { useState } from "react";
import { useTable } from "@refinedev/antd";
import { useTranslation } from "@refinedev/core";
import { Table, Space, Typography } from "antd";
import {
  ShoppingOutlined,
  DollarOutlined,
  ClockCircleOutlined,
} from "@ant-design/icons";
import { OrderDto } from "../../../../../generated";
import { formatCurrency } from "../../../../utils/currency-formatter";
import { OrderStatusBadge } from "./OrderStatusBadge";
import { OrderDetailsModal } from "./OrderDetailsModal";

const { Text } = Typography;

export const OrderTable: React.FC = () => {
  const [selectedOrder, setSelectedOrder] = useState<OrderDto | null>(null);
  const { translate } = useTranslation();

  const { tableProps } = useTable<OrderDto>({
    resource: "orders",
    syncWithLocation: true,
    sorters: {
      initial: [{ field: "createdAt", order: "desc" }],
    },
  });

  const handleRowClick = (record: OrderDto) => {
    setSelectedOrder(record);
  };

  return (
    <>
      <Table
        {...tableProps}
        rowKey="orderId"
        className="overflow-x-auto"
        onRow={(record) => ({
          onClick: () => handleRowClick(record),
          style: { cursor: "pointer" },
        })}
      >
        <Table.Column
          dataIndex="orderId"
          title={
            <Space>
              <ShoppingOutlined />
              <span>{translate("orders.fields.orderId", "Order ID")}</span>
            </Space>
          }
          render={(value: number) => (
            <Text copyable className="font-medium">
              #{value}
            </Text>
          )}
          sorter
        />

        <Table.Column
          dataIndex="orderStatusHistories"
          title={translate("orders.fields.status", "Status")}
          render={(histories) => <OrderStatusBadge histories={histories} />}
          filterMultiple={false}
        />

        <Table.Column
          dataIndex="totalPrice"
          title={
            <Space>
              <DollarOutlined />
              <span>{translate("orders.fields.total", "Total")}</span>
            </Space>
          }
          render={(value: number) => (
            <Text className="font-medium">{formatCurrency(value)}</Text>
          )}
          sorter
        />

        <Table.Column
          dataIndex="createdAt"
          title={
            <Space>
              <ClockCircleOutlined />
              <span>{translate("orders.fields.orderDate", "Order Date")}</span>
            </Space>
          }
          render={(value: string) => (
            <Text>{new Date(value).toLocaleString()}</Text>
          )}
          sorter
        />
      </Table>

      <OrderDetailsModal
        order={selectedOrder}
        onClose={() => setSelectedOrder(null)}
      />
    </>
  );
};
