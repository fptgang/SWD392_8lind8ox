import React from "react";
import { BaseRecord, useTranslate, useGetIdentity } from "@refinedev/core";
import {
  useTable,
  List,
  EditButton,
  ShowButton,
  DeleteButton,
  BooleanField,
  DateField,
} from "@refinedev/antd";
import { Table, Space, Tooltip, Typography, Badge, Input } from "antd";
import {
  ShopOutlined,
  EyeOutlined,
  ClockCircleOutlined,
  CheckCircleOutlined,
  EditOutlined,
  DeleteOutlined,
  InboxOutlined,
} from "@ant-design/icons";
import { SetDto, AccountDto } from "../../../generated";

const { Text } = Typography;

export const SetsList: React.FC = () => {
  const translate = useTranslate();
  const { data: user } = useGetIdentity<AccountDto>();
  const isStaff = user?.role === "STAFF";

  const { tableProps, setFilters } = useTable<SetDto>({
    resource: "sets",
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
          value: isStaff ? true : undefined,
        },
      ],
    },
  });

  const getVisibilityStatus = (isVisible: boolean) =>
    isVisible ? (
      <Badge status="success" text="Visible" />
    ) : (
      <Badge status="error" text="Hidden" />
    );

  return (
    <List>
      {/* Search Input */}
      <div className="mb-6">
        <Input.Search
          placeholder="Search sets..."
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
        rowKey="setId"
        className="overflow-x-auto"
        scroll={{ x: true }}
      >
        <Table.Column
          dataIndex="setId"
          title={
            <Tooltip title="Unique set identifier">
              <Space>
                <InboxOutlined />
                <span>Set ID</span>
              </Space>
            </Tooltip>
          }
          sorter
          className="font-medium"
        />

        <Table.Column
          dataIndex={["sku", "name"]}
          title="SKU Name"
          sorter
          render={(value: string) => <Text strong>{value}</Text>}
        />

        <Table.Column
          dataIndex={["blindBox", "name"]}
          title="Blind Box"
          sorter
          render={(value: string) =>
            value || <Text type="secondary">None</Text>
          }
        />

        {!isStaff && (
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
            render={(value: boolean) => getVisibilityStatus(value)}
            filters={[
              { text: "Visible", value: true },
              { text: "Hidden", value: false },
            ]}
            filterMultiple={false}
          />
        )}

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
          render={(_, record: BaseRecord) => (
            <Space size="middle">
              <Tooltip title="Edit Set">
                <EditButton
                  hideText
                  size="small"
                  recordItemId={record.setId}
                  icon={<EditOutlined className="text-blue-600" />}
                  className="hover:text-blue-700"
                />
              </Tooltip>
              <Tooltip title="View Details">
                <ShowButton
                  hideText
                  size="small"
                  recordItemId={record.setId}
                  className="text-green-600 hover:text-green-700"
                />
              </Tooltip>
              <Tooltip title="Delete Set">
                <DeleteButton
                  hideText
                  size="small"
                  recordItemId={record.setId}
                  icon={<DeleteOutlined className="text-red-600" />}
                  className="hover:text-red-700"
                  confirmTitle="Delete Set"
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
