// src/components/products/show/product-images.tsx
import React, { useState } from "react";
import { Card, Row, Col, Image } from "antd";

interface ProductImagesProps {
  product: BlindBoxDto;
}

export const ProductImages: React.FC<ProductImagesProps> = ({ product }) => {
  const [selectedImage, setSelectedImage] = useState<string>(
    product.images?.[0]?.imageUrl || "/placeholder.jpg"
  );

  return (
    <Card className="shadow-sm">
      <div className="space-y-4">
        <div className="aspect-square w-full overflow-hidden rounded-lg bg-gray-50">
          <Image
            src={selectedImage}
            alt={product.name}
            className="w-full h-full object-cover"
            fallback="/placeholder.jpg"
            preview={false}
          />
        </div>
        {product.images && product.images.length > 0 && (
          <Row gutter={[8, 8]}>
            {product.images.map((image, index) => (
              <Col span={6} key={image.imageId || index}>
                <div
                  className={`aspect-square overflow-hidden rounded-lg cursor-pointer border-2 transition-all ${
                    selectedImage === image.imageUrl
                      ? "border-blue-500 shadow-sm"
                      : "border-transparent hover:border-gray-200"
                  }`}
                  onClick={() =>
                    setSelectedImage(image.imageUrl || "/placeholder.jpg")
                  }
                >
                  <Image
                    src={image.imageUrl || "/placeholder.jpg"}
                    alt={`${product.name} ${index + 1}`}
                    className="w-full h-full object-cover"
                    fallback="/placeholder.jpg"
                    preview={false}
                  />
                </div>
              </Col>
            ))}
          </Row>
        )}
      </div>
    </Card>
  );
};

// src/components/products/show/sku-selector.tsx
import { Typography, Space, Tag } from "antd";
import { BlindBoxDto, StockKeepingUnitDto } from "../../../../../generated";

const { Text } = Typography;

interface SkuSelectorProps {
  skus: StockKeepingUnitDto[];
  selectedSku?: StockKeepingUnitDto;
  onChange: (sku: StockKeepingUnitDto) => void;
}

export const SkuSelector: React.FC<SkuSelectorProps> = ({
  skus,
  selectedSku,
  onChange,
}) => {
  return (
    <div className="space-y-2">
      <Text strong>Select Option:</Text>
      <div className="flex flex-wrap gap-2">
        {skus.map((sku) => (
          <Card
            key={sku.skuId}
            className={`cursor-pointer transition-all hover:shadow-md ${
              selectedSku?.skuId === sku.skuId
                ? "border-blue-500 shadow-md"
                : "border-gray-200 hover:border-blue-500"
            }`}
            bodyStyle={{ padding: "12px" }}
            onClick={() => onChange(sku)}
          >
            <Space direction="vertical" size="small" className="text-center">
              <Text strong className="block truncate max-w-[150px]">
                {sku.name}
              </Text>
              <Text>${sku.price?.toFixed(2)}</Text>
              <Tag color={sku.stock ? "success" : "error"}>
                {sku.stock ? `${sku.stock} left` : "Out of stock"}
              </Tag>
              {sku.specCount && (
                <Text type="secondary" className="text-xs">
                  {sku.specCount} per box
                </Text>
              )}
            </Space>
          </Card>
        ))}
      </div>
    </div>
  );
};
