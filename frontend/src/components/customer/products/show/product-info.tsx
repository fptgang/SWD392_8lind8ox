// src/components/products/show/product-info.tsx
import React, { useState, useMemo } from "react";
import { Card, Space, Typography, Button, Tag, Divider } from "antd";
import {
  ShoppingOutlined,
  ShopOutlined,
  TagOutlined,
  InboxOutlined,
  InfoCircleOutlined,
} from "@ant-design/icons";
import {
  BlindBoxDto,
  BrandDto,
  StockKeepingUnitDto,
} from "../../../../../generated";
import { SkuSelector } from "./product-images";

const { Title, Text, Paragraph } = Typography;

interface ProductInfoProps {
  product: BlindBoxDto;
  brand?: BrandDto;
  onAddToCart: (sku: StockKeepingUnitDto) => void;
}

export const ProductInfo: React.FC<ProductInfoProps> = ({
  product,
  brand,
  onAddToCart,
}) => {
  const [selectedSku, setSelectedSku] = useState<
    StockKeepingUnitDto | undefined
  >(product.skus?.[0]);

  const isOutOfStock = useMemo(
    () => !selectedSku?.stock || selectedSku.stock <= 0,
    [selectedSku]
  );

  return (
    <Card className="shadow-sm">
      <Space direction="vertical" size="large" className="w-full">
        <div>
          <Title level={3} className="mb-2">
            {product.name}
          </Title>
          {brand?.name && (
            <Space>
              <ShopOutlined className="text-gray-500" />
              <Text type="secondary">Brand: {brand.name}</Text>
            </Space>
          )}
        </div>

        <Divider className="my-4" />

        {product.skus && product.skus.length > 0 && (
          <SkuSelector
            skus={product.skus}
            selectedSku={selectedSku}
            onChange={setSelectedSku}
          />
        )}

        <Divider className="my-4" />

        <Space direction="vertical" size="middle">
          {selectedSku && (
            <>
              <div className="flex items-center gap-4">
                <TagOutlined className="text-blue-500" />
                <Title level={2} className="text-blue-500 m-0">
                  ${selectedSku.price?.toFixed(2)}
                </Title>
              </div>

              <Space>
                <InboxOutlined className="text-gray-500" />
                <Text>
                  {isOutOfStock ? (
                    <Text type="danger">Out of Stock</Text>
                  ) : (
                    <>Stock: {selectedSku.stock} units</>
                  )}
                </Text>
              </Space>
            </>
          )}
        </Space>

        <Button
          type="primary"
          size="large"
          icon={<ShoppingOutlined />}
          onClick={() => selectedSku && onAddToCart(selectedSku)}
          disabled={isOutOfStock || !selectedSku}
          className="w-full"
        >
          {!selectedSku
            ? "Please select an option"
            : isOutOfStock
            ? "Out of Stock"
            : "Add to Cart"}
        </Button>

        {(product.description || brand?.description) && (
          <>
            <Divider orientation="left" className="my-4">
              <InfoCircleOutlined /> Product Information
            </Divider>
            {product.description && (
              <div className="mb-4">
                <Text strong>Description</Text>
                <Paragraph className="mt-2">{product.description}</Paragraph>
              </div>
            )}
            {brand?.description && (
              <div>
                <Text strong>About the Brand</Text>
                <Paragraph className="mt-2">{brand.description}</Paragraph>
              </div>
            )}
          </>
        )}
      </Space>
    </Card>
  );
};
