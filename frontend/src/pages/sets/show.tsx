import React from "react";
import { useShow, useOne } from "@refinedev/core";
import { Show, MarkdownField, DateField, BooleanField } from "@refinedev/antd";
import {
  Typography,
  Descriptions,
  Card,
  Space,
  Table,
  Tag,
  Divider,
  Button,
} from "antd";
import { SetDto } from "../../../generated/models/SetDto";
import { CheckCircleOutlined, CloseCircleOutlined } from "@ant-design/icons";

const { Title, Text } = Typography;

export const SetsShow: React.FC = () => {
  const { queryResult } = useShow<SetDto>({
    resource: "sets",
  });

  const { data, isLoading } = queryResult;
  const record = data?.data;

  return (
    <Show isLoading={isLoading}>
      <div className="grid gap-6">
        <Card bordered={false} className="overflow-hidden shadow-md">
          <Title level={4} className="mb-4">
            Set Details
          </Title>
          <Descriptions bordered column={{ xs: 1, sm: 2, md: 3 }} size="middle">
            <Descriptions.Item label="Set ID" span={1}>
              {record?.setId}
            </Descriptions.Item>
            <Descriptions.Item label="SKU Name" span={2}>
              {record?.sku?.name || "N/A"}
            </Descriptions.Item>
            <Descriptions.Item label="Blind Box">
              {record?.blindBox?.name || "N/A"}
            </Descriptions.Item>
            <Descriptions.Item label="Visibility">
              {record?.isVisible ? (
                <Space>
                  <CheckCircleOutlined style={{ color: "#52c41a" }} />
                  <span>Visible</span>
                </Space>
              ) : (
                <Space>
                  <CloseCircleOutlined style={{ color: "#f5222d" }} />
                  <span>Hidden</span>
                </Space>
              )}
            </Descriptions.Item>
            <Descriptions.Item label="Created At">
              {record?.createdAt && (
                <DateField
                  value={record.createdAt}
                  format="MMMM DD, YYYY HH:mm"
                />
              )}
            </Descriptions.Item>
            <Descriptions.Item label="Updated At">
              {record?.updatedAt && (
                <DateField
                  value={record.updatedAt}
                  format="MMMM DD, YYYY HH:mm"
                />
              )}
            </Descriptions.Item>
          </Descriptions>
        </Card>

        {record?.slots && record.slots.length > 0 && (
          <Card bordered={false} className="overflow-hidden shadow-md">
            <Title level={4} className="mb-4">
              Slots
            </Title>
            <Table
              dataSource={record.slots}
              rowKey="slotId"
              pagination={false}
              className="w-full"
            >
              <Table.Column title="Slot ID" dataIndex="slotId" key="slotId" />
              <Table.Column
                title="Toy"
                dataIndex={["toy", "name"]}
                key="toyName"
                render={(value) => value || "No Toy Assigned"}
              />
              <Table.Column
                title="Video"
                dataIndex={["video", "url"]}
                key="videoUrl"
                render={(value) =>
                  value ? (
                    <a href={value} target="_blank" rel="noopener noreferrer">
                      View Video
                    </a>
                  ) : (
                    "No Video"
                  )
                }
              />
            </Table>
          </Card>
        )}
      </div>
    </Show>
  );
};
