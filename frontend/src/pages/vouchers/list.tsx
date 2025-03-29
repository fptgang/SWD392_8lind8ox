import React from "react";
import { BaseRecord, useGetIdentity } from "@refinedev/core";
import {
  useTable,
  List,
  EditButton,
  ShowButton,
  DeleteButton,
  DateField,
} from "@refinedev/antd";
import { Table, Space, Tooltip, Typography, Badge, Input } from "antd";
import {
  GiftOutlined,
  EyeOutlined,
  ClockCircleOutlined,
  CheckCircleOutlined,
  EditOutlined,
  DeleteOutlined,
  DollarOutlined,
} from "@ant-design/icons";
import { AccountDto, VoucherDto } from "../../../generated";

const { Text } = Typography;

export const VouchersList: React.FC = () => {
  const { data: user } = useGetIdentity<AccountDto>();
  const { tableProps, setFilters } = useTable<VoucherDto>({
    syncWithLocation: true,
    pagination: {
      pageSize: 10,
    },
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
          field: "state",
          operator: "eq",
          value: undefined,
        },
      ],
    },
  });

  const getStatusBadge = (state: string) => {
    switch (state) {
      case "AVAILABLE":
        return <Badge status="success" text="Available" />;
      case "USED":
        return <Badge status="warning" text="Used" />;
      case "EXPIRED":
        return <Badge status="error" text="Expired" />;
      default:
        return <Badge status="default" text={state} />;
    }
  };

  return (
    <List>
      <div className="mb-6">
        <Input.Search
          placeholder="Search vouchers..."
          className="max-w-md"
          allowClear
          onSearch={(value) => {
            setFilters([
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
        rowKey="voucherId"
        className="overflow-x-auto"
        scroll={{ x: true }}
      >
        <Table.Column
          dataIndex="voucherId"
          title={
            <Tooltip title="Unique voucher identifier">
              <Space>
                <GiftOutlined />
                <span>Voucher ID</span>
              </Space>
            </Tooltip>
          }
          sorter
          className="font-medium"
        />

        <Table.Column
          dataIndex="code"
          title="Code"
          sorter
          render={(value: string) => <Text strong>{value}</Text>}
        />

        <Table.Column
          dataIndex="discountRate"
          title={
            <Tooltip title="Discount rate">
              <Space>
                <DollarOutlined />
                <span>Discount</span>
              </Space>
            </Tooltip>
          }
          render={(value: number) => `${(value * 100).toFixed(0)}%`}
          sorter
        />

        <Table.Column
          dataIndex="state"
          title={
            <Tooltip title="Voucher status">
              <Space>
                <EyeOutlined />
                <span>Status</span>
              </Space>
            </Tooltip>
          }
          render={(value: string) => getStatusBadge(value)}
          filters={[
            { text: "Available", value: "AVAILABLE" },
            { text: "Used", value: "USED" },
            { text: "Expired", value: "EXPIRED" },
          ]}
          filterMultiple={false}
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
          defaultSortOrder="descend"
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
          hidden={user?.role !== "ADMIN"}
          render={(_, record: BaseRecord) => (
            <Space size="middle">
              {user?.role === "ADMIN" && (
                <Tooltip title="Edit Voucher">
                  <EditButton
                    hideText
                    size="small"
                    recordItemId={record.voucherId}
                    icon={<EditOutlined className="text-blue-600" />}
                    className="hover:text-blue-700"
                  />
                </Tooltip>
              )}
              {user?.role === "ADMIN" && (
                <Tooltip title="Delete Voucher">
                  <DeleteButton
                    hideText
                    size="small"
                    recordItemId={record.voucherId}
                    icon={<DeleteOutlined className="text-red-600" />}
                    className="hover:text-red-700"
                    confirmTitle="Delete Voucher"
                    confirmOkText="Delete"
                    confirmCancelText="Cancel"
                  />
                </Tooltip>
              )}
            </Space>
          )}
        />
      </Table>
    </List>
  );
};
