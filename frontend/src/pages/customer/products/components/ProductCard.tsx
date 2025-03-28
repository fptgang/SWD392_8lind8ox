import React, { useState } from "react";
import { Card, Typography, Space, Badge, Divider, Button, theme } from "antd";
import { ShoppingOutlined, InboxOutlined } from "@ant-design/icons";
import { BlindBoxDto, StockKeepingUnitDto } from "../../../../../generated";
import { SkuCardProps } from "./types";

const { Title, Text } = Typography;
const { useToken } = theme;

export const ProductCard: React.FC<SkuCardProps> = ({
  blindBox,
  sku,
  onCardClick,
  onAddToCart,
  promos,
}) => {
  const { token } = useToken();
  const [imgError, setImgError] = useState(false);

  const hasActiveCampaign =
    blindBox.blindBoxCampaigns && blindBox.blindBoxCampaigns.length > 0;

  // Safely get image URL if it exists
  const imageUrl = blindBox.images?.[0]?.imageUrl || "";

  return (
    <>
      {hasActiveCampaign ? (
        <Badge.Ribbon text="ON SALE" color={token.colorPrimary}>
          <Card
            hoverable
            className="h-full"
            style={{
              boxShadow: token.boxShadowTertiary,
              borderRadius: token.borderRadiusLG,
            }}
            cover={
              <div
                className="relative pt-[100%] overflow-hidden cursor-pointer"
                onClick={() => onCardClick(blindBox.blindBoxId!)}
              >
                {!imageUrl || imgError ? (
                  <div className="absolute top-0 left-0 w-full h-full flex items-center justify-center bg-gray-100">
                    <InboxOutlined
                      style={{
                        fontSize: "3rem",
                        color: token.colorTextSecondary,
                      }}
                    />
                  </div>
                ) : (
                  <img
                    alt={`${blindBox.name || "Product"} - ${sku.name || ""}`}
                    src={
                      typeof sku.image === "string"
                        ? sku.image
                        : sku.image?.imageUrl ?? ""
                    }
                    className="absolute top-0 left-0 w-full h-full object-cover transition-transform duration-300 hover:scale-110"
                    onError={() => {
                      setImgError(true);
                    }}
                  />
                )}
              </div>
            }
          >
            <Space direction="vertical" className="w-full">
              <div>
                <Title
                  level={5}
                  className="mb-0 cursor-pointer"
                  onClick={() => onCardClick(blindBox.blindBoxId!)}
                >
                  {blindBox.name || "Unnamed Product"}
                </Title>
                <Text strong className="block mt-1 text-primary">
                  {sku.name || "Standard"}
                </Text>
              </div>

              <div className="flex justify-between items-center mt-2">
                {hasActiveCampaign ? (
                  <div>
                    <Text type="danger" delete className="text-lg mr-4">
                      ${(sku.price || 0).toFixed(2)}
                    </Text>
                    <Text type="danger" strong className="text-lg">
                      -
                      {(promos?.find((p) =>
                        blindBox?.blindBoxCampaigns?.find(
                          (bc) => bc.promotionalCampaignId === p.campaignId
                        )
                      )?.discountRate || 0) * 100}
                      %
                    </Text>
                    <br />
                    <Text type="success" strong className="text-lg">
                      $
                      {(
                        (sku.price || 0) *
                        (1 -
                          (promos?.find((p) =>
                            blindBox?.blindBoxCampaigns?.find(
                              (bc) => bc.promotionalCampaignId === p.campaignId
                            )
                          )?.discountRate || 0))
                      ).toFixed(2)}
                    </Text>
                  </div>
                ) : (
                  <Text type="success" strong className="text-lg">
                    ${(sku.price || 0).toFixed(2)}
                  </Text>
                )}
                <Badge
                  count={sku.stock || 0}
                  showZero
                  color={sku.stock ? "green" : "red"}
                />
              </div>

              <Divider className="my-2" />

              <div className="mt-auto">
                <Button
                  type="primary"
                  icon={<ShoppingOutlined />}
                  onClick={(e) => {
                    e.stopPropagation();
                    onAddToCart(blindBox, sku);
                  }}
                  disabled={!sku.stock || sku.stock <= 0}
                  block
                >
                  {!sku.stock || sku.stock <= 0
                    ? "Out of Stock"
                    : "Add to Cart"}
                </Button>
              </div>
            </Space>
          </Card>
        </Badge.Ribbon>
      ) : (
        <Card
          hoverable
          className="h-full"
          style={{
            boxShadow: token.boxShadowTertiary,
            borderRadius: token.borderRadiusLG,
          }}
          cover={
            <div
              className="relative pt-[100%] overflow-hidden cursor-pointer"
              onClick={() => onCardClick(blindBox.blindBoxId!)}
            >
              {!imageUrl || imgError ? (
                <div className="absolute top-0 left-0 w-full h-full flex items-center justify-center bg-gray-100">
                  <InboxOutlined
                    style={{
                      fontSize: "3rem",
                      color: token.colorTextSecondary,
                    }}
                  />
                </div>
              ) : (
                <img
                  alt={`${blindBox.name || "Product"} - ${sku.name || ""}`}
                  src={
                    typeof sku.image === "string"
                      ? sku.image
                      : sku.image?.imageUrl ?? ""
                  }
                  className="absolute top-0 left-0 w-full h-full object-cover transition-transform duration-300 hover:scale-110"
                  onError={() => {
                    setImgError(true);
                  }}
                />
              )}
            </div>
          }
        >
          <Space direction="vertical" className="w-full">
            <div>
              <Title
                level={5}
                className="mb-0 cursor-pointer"
                onClick={() => onCardClick(blindBox.blindBoxId!)}
              >
                {blindBox.name || "Unnamed Product"}
              </Title>
              <Text strong className="block mt-1 text-primary">
                {sku.name || "Standard"}
              </Text>
            </div>

            <div className="flex justify-between items-center mt-2">
              {hasActiveCampaign ? (
                <div>
                  <Text type="danger" delete className="text-lg mr-4">
                    ${(sku.price || 0).toFixed(2)}
                  </Text>
                  <Text type="danger" strong className="text-lg">
                    -
                    {(promos?.find((p) =>
                      blindBox?.blindBoxCampaigns?.find(
                        (bc) => bc.promotionalCampaignId === p.campaignId
                      )
                    )?.discountRate || 0) * 100}
                    %
                  </Text>
                  <br />
                  <Text type="success" strong className="text-lg">
                    $
                    {(
                      (sku.price || 0) *
                      (1 -
                        (promos?.find((p) =>
                          blindBox?.blindBoxCampaigns?.find(
                            (bc) => bc.promotionalCampaignId === p.campaignId
                          )
                        )?.discountRate || 0))
                    ).toFixed(2)}
                  </Text>
                </div>
              ) : (
                <Text type="success" strong className="text-lg">
                  ${(sku.price || 0).toFixed(2)}
                </Text>
              )}
              <Badge
                count={sku.stock || 0}
                showZero
                color={sku.stock ? "green" : "red"}
              />
            </div>

            <Divider className="my-2" />

            <div className="mt-auto">
              <Button
                type="primary"
                icon={<ShoppingOutlined />}
                onClick={(e) => {
                  e.stopPropagation();
                  onAddToCart(blindBox, sku);
                }}
                disabled={!sku.stock || sku.stock <= 0}
                block
              >
                {!sku.stock || sku.stock <= 0 ? "Out of Stock" : "Add to Cart"}
              </Button>
            </div>
          </Space>
        </Card>
      )}
    </>
  );
};
