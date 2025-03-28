import React from "react";
import { useShow } from "@refinedev/core";
import { Show, TextField, DateField } from "@refinedev/antd";
import { Typography, Row, Col, Card, Space, Tag, Divider } from "antd";
import {
  InfoCircleOutlined,
  GiftOutlined,
  DollarOutlined,
  CalendarOutlined,
} from "@ant-design/icons";
import { VoucherDto } from "../../../generated";

const { Title, Text } = Typography;

export const VouchersShow = () => {
  const { queryResult } = useShow<VoucherDto>();
  const { data, isLoading } = queryResult;
  const record = data?.data;

  const getStatusTag = (state: string) => {
    switch (state) {
      case 'AVAILABLE':
        return <Tag color="success">Available</Tag>;
      case 'USED':
        return <Tag color="warning">Used</Tag>;
      case 'EXPIRED':
        return <Tag color="error">Expired</Tag>;
      default:
        return <Tag>{state}</Tag>;
    }
  };

  return (
    <Show isLoading={isLoading}>
      <Card bordered={false} className="shadow-sm">
        {/* Basic Information Section */}
        <div className="mb-8">
          <Title level={5} className="mb-4 text-gray-800">
            Voucher Information
          </Title>

          <Row gutter={24}>
            <Col xs={24} md={12}>
              <DetailItem label="Voucher Code">
                <Space>
                  <GiftOutlined />
                  <Text strong style={{ fontSize: 18 }}>
                    {record?.code}
                  </Text>
                </Space>
              </DetailItem>
            </Col>
            <Col xs={24} md={12}>
              <DetailItem label="Discount Rate">
                <Space>
                  <DollarOutlined />
                  <Text strong style={{ fontSize: 18 }}>
                    {record?.discountRate}%
                  </Text>
                </Space>
              </DetailItem>
            </Col>
          </Row>

          <DetailItem label="Description">
            <Text type="secondary">{record?.description}</Text>
          </DetailItem>

          <DetailItem label="Status">
            {record?.state && getStatusTag(record.state)}
          </DetailItem>
        </div>

        <Divider className="my-8" />

        {/* System Information */}
        <div>
          <Title level={5} className="mb-4 text-gray-800">
            System Information
          </Title>

          <Row gutter={24}>
            <Col xs={24} md={12}>
              <DetailItem label="Created At">
                <Space>
                  <CalendarOutlined />
                  <DateField value={record?.createdAt} format="YYYY-MM-DD HH:mm" />
                </Space>
              </DetailItem>
            </Col>
            <Col xs={24} md={12}>
              <DetailItem label="Updated At">
                <Space>
                  <CalendarOutlined />
                  <DateField value={record?.updatedAt} format="YYYY-MM-DD HH:mm" />
                </Space>
              </DetailItem>
            </Col>
          </Row>
        </div>
      </Card>
    </Show>
  );
};

const DetailItem = ({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) => (
  <div className="mb-6">
    <Text type="secondary" className="block text-sm text-gray-500 mb-2">
      {label}
    </Text>
    <div className="text-gray-800 text-base">{children}</div>
  </div>
);
