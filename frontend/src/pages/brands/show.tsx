import React from "react";
import { useShow } from "@refinedev/core";
import { Show } from "@refinedev/antd";
import { Typography, Card, Row, Col, Tag } from "antd";
import { CheckCircleOutlined, CloseCircleOutlined } from "@ant-design/icons";
import dayjs from "dayjs";

const { Title, Text } = Typography;

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

export const BrandsShow = () => {
    const { queryResult } = useShow();
    const { data, isLoading } = queryResult;
    const record = data?.data;

    return (
        <Show isLoading={isLoading}>
            <Card bordered={false} className="shadow-sm">
                {/* Basic Information Section */}
                <div>
                    <Title level={5} className="mb-4 text-gray-800">
                        Basic Information
                    </Title>

                    <Row gutter={24}>
                        <Col xs={24} md={12}>
                            <DetailItem label="Brand Name">
                                <Text strong style={{ fontSize: 18 }}>
                                    {record?.name}
                                </Text>
                            </DetailItem>
                        </Col>
                    </Row>

                    <DetailItem label="Description">
                        <Text strong style={{ fontSize: 18 }}>
                            {record?.description}
                        </Text>
                    </DetailItem>

                    <DetailItem label="Visibility">
                        {record?.isVisible ? (
                            <Tag color="success" icon={<CheckCircleOutlined />}>
                                Visible to customers
                            </Tag>
                        ) : (
                            <Tag color="error" icon={<CloseCircleOutlined />}>
                                Hidden from customers
                            </Tag>
                        )}
                    </DetailItem>
                </div>

                {/* System Information */}
                <div className="mt-8">
                    <Title level={5} className="mb-4 text-gray-800">
                        System Information
                    </Title>

                    <Row gutter={24}>
                        <Col xs={24} md={12}>
                            <DetailItem label="Created At">
                                <Text strong style={{ fontSize: 18 }}>
                                    {record?.createdAt ? dayjs(record.createdAt).format('YYYY-MM-DD HH:mm:ss') : '-'}
                                </Text>
                            </DetailItem>
                        </Col>
                        <Col xs={24} md={12}>
                            <DetailItem label="Last Updated">
                                <Text strong style={{ fontSize: 18 }}>
                                    {record?.updatedAt ? dayjs(record.updatedAt).format('YYYY-MM-DD HH:mm:ss') : '-'}
                                </Text>
                            </DetailItem>
                        </Col>
                    </Row>
                </div>
            </Card>
        </Show>
    );
};
