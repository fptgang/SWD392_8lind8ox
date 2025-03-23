import React from "react";
import { BaseRecord, useMany } from "@refinedev/core";
import {
  useTable,
  List,
  EditButton,
  ShowButton,
  DeleteButton,
  DateField,
} from "@refinedev/antd";
import { Table, Space, Tooltip, Typography, Badge, Input, Tag } from "antd";
import {
  ShoppingCartOutlined,
  UserOutlined,
  DollarOutlined,
  ClockCircleOutlined,
  CheckCircleOutlined,
  EditOutlined,
  DeleteOutlined,
} from "@ant-design/icons";
import { AccountDto, OrderDto, OrderStatus } from "../../../generated";

const { Text } = Typography;

const STATUS_COLOR_MAP: Record<
  OrderStatus,
  "success" | "warning" | "error" | "default" | "processing"
> = {
  CREATED: "default",
  PREPARING: "processing",
  COMPLETED: "success",
  PAYMENT_EXPIRED: "error",
  PAYMENT_FAILED: "error",
  CANCELED: "error",
  READY_FOR_PICKUP: "processing",
  SHIPPING: "processing",
  DELIVERED: "processing",
  RECEIVED: "processing",
};

export const OrdersList: React.FC = () => {
  const { tableProps, searchFormProps, setFilters } = useTable<OrderDto>({
    syncWithLocation: true,
    sorters: {
      initial: [
        {
          field: "createdAt",
          order: "desc",
        },
      ],
    },
    filters: {
      initial: [
        {
          field: "status",
          operator: "eq",
          value: undefined,
        },
      ],
    },
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
    }).format(amount);
  };

  const getStatusBadge = (status: keyof typeof STATUS_COLOR_MAP) => {
    return (
      <Badge
        status={STATUS_COLOR_MAP[status] || "default"}
        text={status?.charAt(0) + status?.slice(1).toLowerCase()}
      />
    );
  };

  return (
    <List>
      <div className="mb-6">
        <Input.Search
          placeholder="Search orders..."
          className="max-w-md"
          allowClear
          onSearch={(value) => {
            setFilters([
              ...(tableProps.filters?.filter(
                (filter) => filter.field !== "search"
              ) || []),
              {
                field: "search",
                operator: "contains",
                value: value || undefined,
              },
            ]);
          }}
        />
      </div>
      <Table
        {...tableProps}
        rowKey="orderId"
        className="overflow-x-auto"
        scroll={{ x: true }}
      >
        <Table.Column
          dataIndex="orderId"
          title={
            <Tooltip title="Unique order identifier">
              <Space>
                <ShoppingCartOutlined />
                <span>Order ID</span>
              </Space>
            </Tooltip>
          }
          sorter
          className="font-medium"
        />

        <Table.Column
          dataIndex="account"
          title={
            <Tooltip title="Ordering account">
              <Space>
                <UserOutlined />
                <span>Account</span>
              </Space>
            </Tooltip>
          }
          render={(value: AccountDto) => {
            return (
              <Text>
                {value.firstName} {value.lastName}
              </Text>
            );
          }}
        />

        <Table.Column
          dataIndex="latestStatus"
          title="Status"
          filters={[
            {
              text: "Created",
              value: "CREATED",
            },
            {
              text: "Preparing",
              value: "PREPARING",
            },
            {
              text: "Payment Failed",
              value: "PAYMENT_FAILED",
            },
            {
              text: "Payment Expired",
              value: "PAYMENT_EXPIRED",
            },
            {
              text: "Canceled",
              value: "CANCELED",
            },
            {
              text: "Ready for Pickup",
              value: "READY_FOR_PICKUP",
            },
            {
              text: "Shipping",
              value: "SHIPPING",
            },
            {
              text: "Delivered",
              value: "DELIVERED",
            },
            {
              text: "Received",
              value: "RECEIVED",
            },
            {
              text: "Completed",
              value: "COMPLETED",
            },
          ]}
          render={(value: keyof typeof STATUS_COLOR_MAP) =>
            getStatusBadge(value)
          }
          filterMultiple={false}
        />

        <Table.Column
          dataIndex="subTotal"
          title={
            <Tooltip title="Total order amount before applying discounts">
              <Space>
                <DollarOutlined />
                <span>Sub Total</span>
              </Space>
            </Tooltip>
          }
          render={(value: number) => (
            <Text strong className="text-green-600">
              {formatCurrency(value)}
            </Text>
          )}
          sorter
        />
        <Table.Column
          dataIndex="finalTotal"
          title={
            <Tooltip title="Total order amount after applying discounts">
              <Space>
                <DollarOutlined />
                <span>Final Total</span>
              </Space>
            </Tooltip>
          }
          render={(value: number) => (
            <Text strong className="text-green-600">
              {formatCurrency(value)}
            </Text>
          )}
          sorter
        />
        <Table.Column
          dataIndex="createdAt"
          title={
            <Space>
              <ClockCircleOutlined />
              <span>Created</span>
            </Space>
          }
          render={(value: string) => (
            <DateField value={value} format="MMMM DD, YYYY" />
          )}
          sorter
        />

        <Table.Column
          dataIndex="updatedAt"
          title={
            <Space>
              <CheckCircleOutlined />
              <span>Updated</span>
            </Space>
          }
          render={(value: string) => (
            <DateField value={value} format="MMMM DD, YYYY" />
          )}
          sorter
        />

        <Table.Column
          title="Actions"
          fixed="right"
          render={(_, record: BaseRecord) => (
            <Space size="middle">
              <Tooltip title="View Details">
                <ShowButton
                  hideText
                  size="small"
                  recordItemId={record.orderId}
                  className="text-green-600 hover:text-green-700"
                />
              </Tooltip>
            </Space>
          )}
        />
      </Table>
    </List>
  );
};
