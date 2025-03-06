import React from "react";
import { useShow, useOne } from "@refinedev/core";
import {
  Show,
  TextField,
  NumberField,
  BooleanField,
  DateField,
} from "@refinedev/antd";
import { Typography, Card, Row, Col, Tag, Spin, Image, Space } from "antd";
import {
  CheckCircleOutlined,
  CloseCircleOutlined,
  InfoCircleOutlined,
  GiftOutlined,
  DollarOutlined,
  CalendarOutlined,
  TagOutlined,
} from "@ant-design/icons";
import { ImageDto, PackDto, ToyDto, ToyDtoRarityEnum } from "../../../generated";

const { Title, Text } = Typography;

export const PacksShow = () => {
  const { query } = useShow<PackDto>();
  const { data , isLoading } = query;
  const record = data?.data as PackDto;



  const rarityColorMap: Record<ToyDtoRarityEnum, string> = {
    REGULAR: "default",
    SECRET: "gold",
  };

  return (
    <Show isLoading={isLoading}>
      <Row gutter={[24, 24]}>
        {/* Image Gallery */}
        {record?.images?.length > 0 && (
          <Col span={24}>
            <Card title="Media" bordered={false}>
              <Space>
                {record?.images.map((image: ImageDto) => (
                  <Image
                    key={image.imageId}
                    width={120}
                    src={image.imageUrl}
                    placeholder={<Spin size="small" />}
                  />
                ))}
              </Space>
            </Card>
          </Col>
        )}

        {/* Main Information */}
        <Col xs={24} lg={16}>
          <Card
            title={
              <Space>
                <GiftOutlined />
                <Text>Pack Details</Text>
              </Space>
            }
            bordered={false}
          >
            <Row gutter={[16, 16]}>
              <Col span={12}>
                <Label>Product</Label>
                {isLoading ? (
                  <Spin size="small" />
                ) : (
                  <Text strong>#{record.packId}</Text>
                )}
              </Col>

              <Col span={12}>
                <Label>Type</Label>
                <Tag color="geekblue">{record?.type}</Tag>
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

        {/* Pricing & Status */}
        <Col xs={24} lg={8}>
          <Card
            title={
              <Space>
                <DollarOutlined />
                <Text>Pricing & Status</Text>
              </Space>
            }
            bordered={false}
          >
            <Row gutter={[16, 16]}>
              <Col span={24}>
                <Label>Current Price</Label>
                <NumberField
                  value={record?.currentPrice}
                  options={{
                    style: "currency",
                    currency: "USD",
                  }}
                  style={{ fontSize: 16, fontWeight: 500 }}
                />
              </Col>

              <Col span={24}>
                <Label>Visibility</Label>
                <div>
                  {record?.isVisible ? (
                    <Space>
                      <CheckCircleOutlined style={{ color: "#52c41a" }} />
                      <Text>Visible to customers</Text>
                    </Space>
                  ) : (
                    <Space>
                      <CloseCircleOutlined style={{ color: "#ff4d4f" }} />
                      <Text>Hidden from customers</Text>
                    </Space>
                  )}
                </div>
              </Col>

              <Col span={24}>
                <Label>Total Toys</Label>
                <Space>
                  <TagOutlined />
                  <Text strong>{record?.toyCount}</Text>
                </Space>
              </Col>
            </Row>
          </Card>
        </Col>

        {/* Guaranteed Toys */}
        <Col span={24}>
          <Card
            title={
              <Space>
                <InfoCircleOutlined />
                <Text>Guaranteed Toys</Text>
              </Space>
            }
            bordered={false}
          >
            {record?.guaranteedToys?.length > 0 ? (
              <Space size={[8, 16]} wrap>
                {record?.guaranteedToys.map((toy: ToyDto) => (
                  <Card.Grid
                    key={toy.toyId}
                    style={{ width: 240, cursor: "default" }}
                    hoverable={false}
                  >
                    <Text strong>{toy.name}</Text>
                    <div>
                      <Tag
                        color={
                          toy.rarity === rarityColorMap.REGULAR
                            ? "default"
                            : "gold"
                        }
                      >
                        {toy.rarity}
                      </Tag>
                    </div>
                    <Text type="secondary" ellipsis>
                      {toy.description}
                    </Text>
                  </Card.Grid>
                ))}
              </Space>
            ) : (
              <Text type="secondary">No guaranteed toys specified</Text>
            )}
          </Card>
        </Col>

        {/* Dates */}
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
