// src/pages/customer/products/show/index.tsx
import React from "react";
import { useOne } from "@refinedev/core";
import { useParams } from "react-router";
import { Row, Col, Empty, notification } from "antd";
import {
  BlindBoxDto,
  BrandDto,
  StockKeepingUnitDto,
} from "../../../../generated";
import { useCart } from "../../../hooks/useCart";
import { LoadingState } from "../../../components/customer/products/show/loading-state";
import { ProductImages } from "../../../components/customer/products/show/product-images";
import { ProductInfo } from "../../../components/customer/products/show/product-info";

const CustomerProductShow: React.FC = () => {
  const { id } = useParams();
  const { addItem } = useCart();

  const { data: productData, isLoading: isProductLoading } =
    useOne<BlindBoxDto>({
      resource: "blind-boxes",
      id: id || "",
    });

  const { data: brandData, isLoading: isBrandLoading } = useOne<BrandDto>({
    resource: "brands",
    id: productData?.data?.brandId || "",
    queryOptions: {
      enabled: !!productData?.data?.brandId,
    },
  });

  const handleAddToCart = (sku: StockKeepingUnitDto) => {
    const product = productData?.data;
    if (product && sku) {
      addItem({
        id: String(sku.skuId),
        name: `${product.name} - ${sku.name}`,
        price: sku.price || 0,
        image: product.images?.[0]?.imageUrl || "/placeholder.jpg",
      });

      notification.success({
        message: "Added to Cart",
        description: `${product.name} - ${sku.name} has been added to your cart.`,
      });
    }
  };

  if (isProductLoading || isBrandLoading) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <LoadingState />
      </div>
    );
  }

  if (!productData?.data) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Empty
          description="Product not found"
          image={Empty.PRESENTED_IMAGE_SIMPLE}
        />
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <Row gutter={[32, 32]}>
        <Col xs={24} md={12}>
          <ProductImages product={productData.data} />
        </Col>
        <Col xs={24} md={12}>
          <ProductInfo
            product={productData.data}
            brand={brandData?.data}
            onAddToCart={handleAddToCart}
          />
        </Col>
      </Row>
    </div>
  );
};

export default CustomerProductShow;
