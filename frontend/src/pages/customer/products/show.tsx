import { useParams } from "react-router";
import { useCart } from "../../../hooks/useCart";
import {
  BlindBoxDto,
  BrandDto,
  StockKeepingUnitDto,
} from "../../../../generated";
import { useOne } from "@refinedev/core";
import { Col, Empty, notification, Row } from "antd";
import { LoadingState } from "../../../components/customer/products/show/loading-state";
import { ProductImages } from "../../../components/customer/products/show/product-images";
import { ProductInfo } from "../../../components/customer/products/show/product-info";
const CustomerProductShow: React.FC = () => {
  const { id } = useParams();
  const { addToCart } = useCart();

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
      addToCart({
        skuId: sku.skuId || 0,
        name: `${product.name} - ${sku.name}` || "",
        price: sku.price,
        stock: sku.stock,
        imageUrl: product.images?.[0]?.imageUrl ?? "",
        blindBoxId: product.blindBoxId,
        promotionalCampaignId: product.promotionalCampaignId,
      });

      notification.success({
        message: "Added to Cart",
        description: `${product.name} - ${sku.name} has been added to your cart.`,
      });
    }
  };

  if (isProductLoading || isBrandLoading) {
    return <LoadingState />;
  }

  if (!productData?.data) {
    return <Empty description="Product not found" />;
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
