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
import { AccountDto, OrderDto } from "../../../generated";

const { Text } = Typography;

const STATUS_COLOR_MAP: Record<
  string,
  "success" | "warning" | "error" | "default" | "processing"
> = {
  COMPLETED: "success",
  PENDING: "warning",
  CANCELED: "error",
};

export const OrdersList: React.FC = () => {
  const { tableProps, searchFormProps } = useTable<OrderDto>({
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

  const { data: accountData, isLoading: accountIsLoading } =
    useMany<AccountDto>({
      resource: "accounts",
      ids:
        tableProps?.dataSource
          ?.map((item) => item?.accountId)
          .filter((id): id is number => id !== undefined) ?? [],
      queryOptions: {
        enabled: !!tableProps?.dataSource,
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
        text={status.charAt(0) + status.slice(1).toLowerCase()}
      />
    );
  };

  return (
    <List>
      <div className="mb-6">
        <Input.Search
          placeholder="Search orders..."
          className="max-w-md"
          {...(searchFormProps.onFinish && {
            onSearch: searchFormProps.onFinish,
          })}
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
          dataIndex="accountId"
          title={
            <Tooltip title="Ordering account">
              <Space>
                <UserOutlined />
                <span>Account</span>
              </Space>
            </Tooltip>
          }
          render={(value: string) => {
            if (accountIsLoading)
              return <Text type="secondary">Loading...</Text>;
            const account = accountData?.data?.find(
              (item) => item?.accountId === value
            );
            return account ? (
              <Text>
                {account.firstName} {account.lastName}
              </Text>
            ) : (
              <Text type="secondary">Unknown Account</Text>
            );
          }}
        />

        <Table.Column
          dataIndex="status"
          title="Status"
          filters={[
            { text: "Completed", value: "COMPLETED" },
            { text: "Pending", value: "PENDING" },
            { text: "Canceled", value: "CANCELED" },
          ]}
          render={(value: keyof typeof STATUS_COLOR_MAP) =>
            getStatusBadge(value)
          }
          filterMultiple={false}
        />

        <Table.Column
          dataIndex="totalPrice"
          title={
            <Tooltip title="Total order amount">
              <Space>
                <DollarOutlined />
                <span>Total</span>
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
              <Tooltip title="Edit Order">
                <EditButton
                  hideText
                  size="small"
                  recordItemId={record.orderId}
                  icon={<EditOutlined className="text-blue-600" />}
                  className="hover:text-blue-700"
                />
              </Tooltip>
              <Tooltip title="View Details">
                <ShowButton
                  hideText
                  size="small"
                  recordItemId={record.orderId}
                  className="text-green-600 hover:text-green-700"
                />
              </Tooltip>
              <Tooltip title="Delete Order">
                <DeleteButton
                  hideText
                  size="small"
                  recordItemId={record.orderId}
                  icon={<DeleteOutlined className="text-red-600" />}
                  className="hover:text-red-700"
                  confirmTitle="Delete Order"
                  confirmOkText="Delete"
                  confirmCancelText="Cancel"
                />
              </Tooltip>
            </Space>
          )}
        />
      </Table>
    </List>
  );
};
