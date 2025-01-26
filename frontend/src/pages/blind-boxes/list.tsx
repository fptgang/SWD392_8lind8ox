import React from "react";
import { BaseRecord } from "@refinedev/core";
import {
  useTable,
  List,
  EditButton,
  ShowButton,
  DeleteButton,
  DateField,
  BooleanField,
} from "@refinedev/antd";
import { Table, Space, Tooltip, Typography, Tag, Input, Badge } from "antd";
import {
  GiftOutlined,
  EyeOutlined,
  DollarOutlined,
  ClockCircleOutlined,
  CheckCircleOutlined,
  EditOutlined,
  DeleteOutlined,
  PictureOutlined,
} from "@ant-design/icons";
import { BlindBoxDto } from "../../../generated";

const { Text } = Typography;

export const BlindBoxesList: React.FC = () => {
  const { tableProps, searchFormProps } = useTable<BlindBoxDto>({
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
          field: "type",
          operator: "eq",
          value: undefined,
        },
        {
          field: "isVisible",
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

  const getVisibilityStatus = (isVisible: boolean) => {
    return isVisible ? (
      <Badge status="success" text="Visible" />
    ) : (
      <Badge status="error" text="Hidden" />
    );
  };

  return (
    <List>
      <div className="mb-6">
        <Input.Search
          placeholder="Search products..."
          className="max-w-md"
          {...(searchFormProps.onFinish && {
            onSearch: searchFormProps.onFinish,
          })}
        />
      </div>

      <Table
        {...tableProps}
        rowKey="blindBoxId"
        className="overflow-x-auto"
        scroll={{ x: true }}
      >
        <Table.Column
          dataIndex="blindBoxId"
          title={
            <Tooltip title="Unique product identifier">
              <Space>
                <GiftOutlined />
                <span>BlindBox Id</span>
              </Space>
            </Tooltip>
          }
          sorter
          className="font-medium"
        />
        <Table.Column
          dataIndex="name"
          title="Name"
          sorter
          render={(value: string) => <Text strong>{value}</Text>}
        />

        <Table.Column
          dataIndex="description"
          title="Description"
          render={(value: string) => (
            <Tooltip title={value}>
              <Text className="text-gray-600">{value.slice(0, 60)}...</Text>
            </Tooltip>
          )}
        />

        <Table.Column
          dataIndex="currentPrice"
          title={
            <Tooltip title="Current selling price">
              <Space>
                <DollarOutlined />
                <span>Price</span>
              </Space>
            </Tooltip>
          }
          render={(value: number) => (
            <Text className="font-semibold">{formatCurrency(value)}</Text>
          )}
          sorter
        />

        <Table.Column
          dataIndex="isVisible"
          title={
            <Tooltip title="Product visibility status">
              <Space>
                <EyeOutlined />
                <span>Status</span>
              </Space>
            </Tooltip>
          }
          render={(value: boolean) => getVisibilityStatus(value)}
          filters={[
            { text: "Visible", value: true },
            { text: "Hidden", value: false },
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
          dataIndex="images"
          title={
            <Tooltip title="Product images">
              <Space>
                <PictureOutlined />
                <span>Images</span>
              </Space>
            </Tooltip>
          }
          render={(value: any[]) => (
            <Badge
              count={value?.length || 0}
              showZero
              color={value?.length ? "blue" : "gray"}
              className="font-medium"
            />
          )}
        />

        <Table.Column
          title="Actions"
          fixed="right"
          render={(_, record: BlindBoxDto) => (
            <Space size="middle">
              <Tooltip title="Edit Product">
                <EditButton
                  hideText
                  size="small"
                  recordItemId={record.blindBoxId}
                  icon={<EditOutlined className="text-blue-600" />}
                  className="hover:text-blue-700"
                />
              </Tooltip>
              <Tooltip title="View Details">
                <ShowButton
                  hideText
                  size="small"
                  recordItemId={record.blindBoxId}
                  className="text-green-600 hover:text-green-700"
                />
              </Tooltip>
              <Tooltip title="Delete Product">
                <DeleteButton
                  hideText
                  size="small"
                  recordItemId={record.blindBoxId}
                  icon={<DeleteOutlined className="text-red-600" />}
                  className="hover:text-red-700"
                  confirmTitle="Delete Product"
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
