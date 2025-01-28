import React from "react";
import { useShow, useOne } from "@refinedev/core";
import {
  Show,
  TextField,
  NumberField,
  BooleanField,
  DateField,
} from "@refinedev/antd";
import { Typography, Card, Row, Col, Image, Spin, Space, Tag, Button, message } from "antd";
import {
  ShoppingOutlined,
  DollarOutlined,
  EyeInvisibleOutlined,
  EyeOutlined,
  CalendarOutlined,
  InfoCircleOutlined,
  ShoppingCartOutlined,
} from "@ant-design/icons";
import { BlindBoxDto } from "../../../generated";
import { useCart } from "../../hooks/useCart";

const { Title, Text } = Typography;

export const BlindBoxesShow = () => {
  const { query } = useShow();
  const { data, isLoading } = query;
  const record = data?.data as BlindBoxDto;
  const { addItem } = useCart();

  const handleAddToCart = () => {
    if (record) {
      addItem({
        id: record.blindBoxId,
        name: record.name,
        price: record.price,
        image: record.images?.[0]?.imageUrl || ''
      });
      message.success('Added to cart successfully!');
    }
  };

 

  return (
    <Show isLoading={isLoading}>
      <Row gutter={[24, 24]}>
        {/* Image Gallery */}
        {(record?.images?.length ?? 0) > 0 && (
          <Col span={24}>
            <Card
              title={
                <Space>
                  <InfoCircleOutlined />
                  <Text>Product Images</Text>
                </Space>
              }
              bordered={false}
            >
              <Space wrap>
                {record?.images?.map((image: any) => (
                  <Image
                    key={image.imageId}
                    width={200}
                    src={image.imageUrl}
                    placeholder={<Spin size="small" />}
                    style={{ borderRadius: 8 }}
                  />
                ))}
              </Space>
            </Card>
          </Col>
        )}

        {/* Main Product Info */}
        <Col xs={24} lg={16}>
          <Card
            title={
              <Space>
                <ShoppingOutlined />
                <Text>Blind Box Details</Text>
              </Space>
            }
            bordered={false}
          >
            <Row gutter={[16, 16]}>
              <Col span={24}>
                <Label>Product ID</Label>
                {isLoading ? (
                  <Spin size="small" />
                ) : (
                  <Text strong>#{record.blindBoxId}</Text>
                )}
              </Col>
              <Col span={24}>
                <Label>Name</Label>
                <Text strong style={{ fontSize: 18 }}>
                  {record?.name}
                </Text>
              </Col>

              <Col span={24}>
                <Label>Description</Label>
                <Text type="secondary">{record?.description}</Text>
              </Col>
            </Row>
          </Card>
        </Col>

        {/* Pricing & Visibility */}
        <Col xs={24} lg={8}>
          <Card
            title={
              <Space>
                <DollarOutlined />
                <Text>Pricing & Visibility</Text>
              </Space>
            }
            bordered={false}
          >
            <Row gutter={[16, 16]}>
              <Col span={24}>
                <Label>Current Price</Label>
                <Space direction="vertical" size="middle" style={{ width: '100%' }}>
                  <NumberField
                    value={record?.currentPrice ?? 0}
                    options={{
                      style: "currency",
                      currency: "USD",
                    }}
                    style={{ fontSize: 16, fontWeight: 500 }}
                  />
                  <Button
                    type="primary"
                    icon={<ShoppingCartOutlined />}
                    onClick={handleAddToCart}
                    block
                  >
                    Add to Cart
                  </Button>
                </Space>
              </Col>

              <Col span={24}>
                <Label>Visibility</Label>
                <div>
                  {record?.isVisible ? (
                    <Space>
                      <EyeOutlined style={{ color: "#52c41a" }} />
                      <Text>Visible to customers</Text>
                    </Space>
                  ) : (
                    <Space>
                      <EyeInvisibleOutlined style={{ color: "#ff4d4f" }} />
                      <Text>Hidden from customers</Text>
                    </Space>
                  )}
                </div>
              </Col>
            </Row>
          </Card>
        </Col>

        {/* Timestamps */}
        <Col span={24}>
          <Card
            title={
              <Space>
                <CalendarOutlined />
                <Text>Timestamps</Text>
              </Space>
            }
            bordered={false}
          >
            <Row gutter={[16, 16]}>
              <Col xs={24} md={12}>
                <Label>Created At</Label>
                <DateField
                  value={record?.createdAt}
                  format="YYYY-MM-DD HH:mm"
                />
              </Col>
              <Col xs={24} md={12}>
                <Label>Updated At</Label>
                <DateField
                  value={record?.updatedAt}
                  format="YYYY-MM-DD HH:mm"
                />
              </Col>
            </Row>
          </Card>
        </Col>
      </Row>
    </Show>
  );
};

const Label = ({ children }: { children: React.ReactNode }) => (
  <Text
    type="secondary"
    style={{ display: "block", marginBottom: 4, fontSize: 12 }}
  >
    {children}
  </Text>
);
