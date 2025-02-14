import React from "react";
import { Card, Typography, Space, Badge, Divider, Button, theme } from "antd";
import { ShoppingOutlined } from "@ant-design/icons";
import { ProductCardProps } from "./types";

const { Title, Text } = Typography;
const { useToken } = theme;

export const ProductCard: React.FC<ProductCardProps> = ({
  blindBox,
  onCardClick,
  onAddToCart,
}) => {
  const { token } = useToken();

  return (
    <Card
      hoverable
      className="h-full"
      style={{
        boxShadow: token.boxShadowTertiary,
        borderRadius: token.borderRadiusLG,
      }}
      cover={
        <div className="relative pt-[100%] overflow-hidden cursor-pointer">
          <img
            alt={blindBox.name}
            src={blindBox.images?.[0]?.imageUrl || "/api/placeholder/400/400"}
            className="absolute top-0 left-0 w-full h-full object-cover transition-transform duration-300 hover:scale-110"
          />
          {blindBox.promotionalCampaignId && (
            <Badge.Ribbon text="ON SALE" color={token.colorPrimary} />
          )}
        </div>
      }
      onClick={() => onCardClick(blindBox.blindBoxId!)}
    >
      <Space direction="vertical" className="w-full">
        <Title level={5} className="mb-0">
          {blindBox.name}
        </Title>
        <Text type="secondary" className="line-clamp-2">
          {blindBox.description}
        </Text>
        <Divider className="my-2" />
        {blindBox.skus?.map((sku) => (
          <div key={sku.skuId} className="p-2 rounded border">
            <Space direction="vertical" className="w-full">
              <div className="flex justify-between items-center">
                <Text strong>{sku.name}</Text>
                <Badge
                  count={sku.stock}
                  showZero
                  color={sku.stock ? "green" : "red"}
                />
              </div>
              <div className="flex justify-between items-center">
                <Text type="success" strong>
                  ${sku.price?.toFixed(2)}
                </Text>
              </div>
            </Space>
          </div>
        ))}
      </Space>
    </Card>
  );
};
