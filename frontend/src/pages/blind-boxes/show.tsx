import React from "react";
import { useShow } from "@refinedev/core";
import {
  Show,
  TextField,
  NumberField,
  DateField,
  TagField,
} from "@refinedev/antd";
import {
  Typography,
  Row,
  Col,
  Card,
  Space,
  Image,
  Divider,
  Spin,
  Tag,
} from "antd";
import {
  InfoCircleOutlined,
  EyeOutlined,
  EyeInvisibleOutlined,
  ShoppingOutlined,
  DollarOutlined,
  CalendarOutlined,
} from "@ant-design/icons";
import { BlindBoxDto } from "../../../generated";

const { Title, Text } = Typography;

export const BlindBoxesShow = () => {
  const { queryResult } = useShow<BlindBoxDto>();
  const { data, isLoading } = queryResult;
  const record = data?.data;

  return (
    <Show isLoading={isLoading}>
      <Card bordered={false} className="shadow-sm">
        {/* Basic Information Section */}
        <div className="mb-8">
          <Title level={5} className="mb-4 text-gray-800">
            Basic Information
          </Title>

          <Row gutter={24}>
            <Col xs={24} md={12}>
              <DetailItem label="Brand">
                {isLoading ? (
                  <Spin size="small" />
                ) : (
                  <Text strong>{record?.brand?.name}</Text>
                )}
              </DetailItem>
            </Col>
            <Col xs={24} md={12}>
              <DetailItem label="Blind Box Name">
                <Text strong style={{ fontSize: 18 }}>
                  {record?.name}
                </Text>
              </DetailItem>
            </Col>
          </Row>

          <DetailItem label="Description">
            <div
              // type="secondary"
              dangerouslySetInnerHTML={{ __html: record?.description || "" }}
            ></div>
          </DetailItem>

          <DetailItem label="Visibility">
            {record?.isVisible ? (
              <Tag icon={<EyeOutlined />} color="success">
                Visible to customers
              </Tag>
            ) : (
              <Tag icon={<EyeInvisibleOutlined />} color="error">
                Hidden from customers
              </Tag>
            )}
          </DetailItem>

          <DetailItem label="Blind Box Images">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              {record?.images?.map((image) => (
                <Image
                  key={image.imageId}
                  src={image.imageUrl}
                  className="rounded-lg"
                  placeholder={<Spin size="small" />}
                  preview={{
                    maskClassName: "rounded-lg",
                    mask: <EyeOutlined className="text-2xl text-white" />,
                  }}
                />
              ))}
            </div>
          </DetailItem>
        </div>

        <Divider className="my-8" />

        {/* SKU Configuration */}
        <div className="mb-8">
          <Title level={5} className="mb-4 text-gray-800">
            SKU Configuration
          </Title>

          {record?.skus?.map((sku, index) => (
            <Card
              key={sku.skuId}
              className="mb-4 shadow-sm border-0 bg-gray-50"
              title={`SKU ${index + 1} - ${sku.name}`}
            >
              <Row gutter={16}>
                <Col xs={24} md={6}>
                  <DetailItem label="Price">
                    {sku.price !== undefined ? (
                      <NumberField
                        value={sku.price}
                        options={{ style: "currency", currency: "USD" }}
                      />
                    ) : (
                      <Text>Not available</Text>
                    )}
                  </DetailItem>
                </Col>
                <Col xs={24} md={6}>
                  <DetailItem label="Stock">
                    <Text strong>{sku.stock}</Text>
                  </DetailItem>
                </Col>
                <Col xs={24} md={6}>
                  <DetailItem label="Spec Count">
                    <Text strong>{sku.specCount}</Text>
                  </DetailItem>
                </Col>
                <Col xs={24} md={6}>
                  <DetailItem label="Visibility">
                    {sku.isVisible ? (
                      <Tag color="success">Visible</Tag>
                    ) : (
                      <Tag color="error">Hidden</Tag>
                    )}
                  </DetailItem>
                </Col>
              </Row>

              <DetailItem label="SKU Images">
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  {sku.image && (
                    <Image
                      key={sku.image.imageId}
                      src={sku.image.imageUrl}
                      className="rounded-lg"
                      placeholder={<Spin size="small" />}
                      preview={{
                        maskClassName: "rounded-lg",
                        mask: <EyeOutlined className="text-2xl text-white" />,
                      }}
                    />
                  )}
                </div>
              </DetailItem>
            </Card>
          ))}
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
                <DateField
                  value={record?.createdAt}
                  format="YYYY-MM-DD HH:mm"
                />
              </DetailItem>
            </Col>
            <Col xs={24} md={12}>
              <DetailItem label="Updated At">
                <DateField
                  value={record?.updatedAt}
                  format="YYYY-MM-DD HH:mm"
                />
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
