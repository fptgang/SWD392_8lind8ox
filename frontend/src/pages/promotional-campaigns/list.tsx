import React from "react";
import { BaseRecord } from "@refinedev/core";
import {
  useTable,
  List,
  EditButton,
  ShowButton,
  DeleteButton,
  MarkdownField,
  DateField,
  BooleanField,
} from "@refinedev/antd";
import { Table, Space, Tooltip, Typography, Input, Badge, Tag } from "antd";
import {
  TagOutlined,
  CalendarOutlined,
  EyeOutlined,
  ClockCircleOutlined,
  CheckCircleOutlined,
  EditOutlined,
  DeleteOutlined,
} from "@ant-design/icons";

const { Text } = Typography;

export const PromotionalCampaignsList: React.FC = () => {
  const { tableProps, setFilters } = useTable({
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
          field: "isVisible",
          operator: "eq",
          value: undefined,
        },
        {
          field: "search",
          operator: "contains",
          value: undefined,
        }
      ],
    },
  });

  return (
    <List>
      <div className="mb-6">
        <Input.Search
          placeholder="Search promotions..."
          className="max-w-md"
          allowClear
          onSearch={(value) => {
            setFilters([
              ...(tableProps.filters?.filter(filter => filter.field !== "search") || []),
              {
                field: "search",
                operator: "contains",
                value: value || undefined,
              }
            ]);
          }}
        />
      </div>

      <Table {...tableProps} rowKey="id" className="overflow-x-auto" scroll={{ x: true }}>
        <Table.Column
          dataIndex="title"
          title={
            <Tooltip title="Promotion title">
              <Space>
                <TagOutlined />
                <span>Title</span>
              </Space>
            </Tooltip>
          }
          sorter
          className="font-medium"
        />

        <Table.Column
          dataIndex="description"
          title="Description"
          render={(value: string) => (
            <Tooltip title={value}>
              <MarkdownField value={value.slice(0, 80) + "..."} />
            </Tooltip>
          )}
        />

        <Table.Column
          dataIndex="startDate"
          title={
            <Tooltip title="Promotion start date">
              <Space>
                <CalendarOutlined />
                <span>Start Date</span>
              </Space>
            </Tooltip>
          }
          render={(value: string) => (
            <DateField value={value} format="MMMM DD, YYYY" />
          )}
          sorter
        />

        <Table.Column
          dataIndex="endDate"
          title={
            <Tooltip title="Promotion end date">
              <Space>
                <CalendarOutlined />
                <span>End Date</span>
              </Space>
            </Tooltip>
          }
          render={(value: string) => (
            <DateField value={value} format="MMMM DD, YYYY" />
          )}
          sorter
        />

        <Table.Column
          dataIndex="discountRate"
          title="Discount"
          render={(value: number) => (
            <Text strong className="text-green-600">
              {value}%
            </Text>
          )}
        />

        <Table.Column
          dataIndex="promoCode"
          title="Code"
          render={(value: string) => (
            <Tag color="blue" className="font-mono">
              {value}
            </Tag>
          )}
        />

        <Table.Column
          dataIndex="isVisible"
          title={
            <Tooltip title="Visibility status">
              <Space>
                <EyeOutlined />
                <span>Status</span>
              </Space>
            </Tooltip>
          }
          render={(value: boolean) => (
            value ? (
              <Badge status="success" text="Active" />
            ) : (
              <Badge status="error" text="Hidden" />
            )
          )}
          filters={[
            { text: "Active", value: true },
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
          title="Actions"
          fixed="right"
          render={(_, record: BaseRecord) => (
            <Space size="middle">
              <Tooltip title="Edit Promotion">
                <EditButton
                  hideText
                  size="small"
                  recordItemId={record.id}
                  icon={<EditOutlined className="text-blue-600" />}
                  className="hover:text-blue-700"
                />
              </Tooltip>
              <Tooltip title="View Details">
                <ShowButton
                  hideText
                  size="small"
                  recordItemId={record.id}
                  className="text-green-600 hover:text-green-700"
                />
              </Tooltip>
              <Tooltip title="Delete Promotion">
                <DeleteButton
                  hideText
                  size="small"
                  recordItemId={record.id}
                  icon={<DeleteOutlined className="text-red-600" />}
                  className="hover:text-red-700"
                  confirmTitle="Delete Promotion"
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
