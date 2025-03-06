import React, { useState } from "react";
import { useShow, IResourceComponentsProps, useNavigation } from "@refinedev/core";
import {
  Show,
  ButtonGroup,
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
  Button,
  Tabs,
  Table,
  Tag,
  Image,
  Divider,
} from "antd";
import {
  EditOutlined,
  DeleteOutlined,
  BarcodeOutlined,
  ShoppingOutlined,
  InfoCircleOutlined,
  PlayCircleOutlined,
  PictureOutlined,
  BranchesOutlined,
} from "@ant-design/icons";
import { BlindBoxDto, StockKeepingUnitDto } from "../../../generated";
import { useCart } from "../../hooks/useCart";

const { Title, Text } = Typography;

export const BlindBoxesShow = () => {
  const { edit, list } = useNavigation();
  const { queryResult } = useShow<BlindBoxDto>();
  const { addToCart } = useCart();
  const record = queryResult.data?.data;

  const handleAddToCart = (sku: StockKeepingUnitDto) => {
    if (!record) return;
    
    const basePrice = sku.price || 0;
    
    // Find active campaign if exists
    const hasActiveCampaign = record.blindBoxCampaigns && record.blindBoxCampaigns.length > 0;
    const activePromotionalCampaignId = hasActiveCampaign && record.blindBoxCampaigns[0]
      ? record.blindBoxCampaigns[0].promotionalCampaignId
      : undefined;
    
    // For now, using base price
    const currentPrice = basePrice;
    
    addToCart({
      skuId: sku.skuId || 0,
      name: `${record.name || ''} - ${sku.name || ''}`,
      price: currentPrice,
      originalPrice: basePrice,
      checkoutPrice: currentPrice,
      stock: sku.stock || 0,
      imageUrl: record.images?.[0]?.imageUrl || '',
      blindBoxId: record.blindBoxId || 0,
      promotionalCampaignId: activePromotionalCampaignId,
    });
  };

  return (
    <Show isLoading={queryResult.isLoading}>
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
                {queryResult.isLoading ? (
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
                    value={record?.skus?.[0]?.price ?? 0}
                    options={{
                      style: "currency",
                      currency: "USD",
                    }}
                    style={{ fontSize: 16, fontWeight: 500 }}
                  />
                  {record?.blindBoxCampaigns && record.blindBoxCampaigns.length > 0 && (
                    <Tag color="red">
                      On sale - Check active campaign for discount details
                    </Tag>
                  )}
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
