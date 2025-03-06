import { useParams } from "react-router";
import { useCart } from "../../../hooks/useCart";
import {
  BlindBoxDto,
  BrandDto,
  StockKeepingUnitDto,
} from "../../../../generated";
import { useOne } from "@refinedev/core";
import { Col, Empty, notification, Row, Spin, Typography, Divider, Card } from "antd";
import { InfoCircleOutlined } from "@ant-design/icons";
import { LoadingState } from "../../../components/customer/products/show/loading-state";
import { ProductImages } from "../../../components/customer/products/show/product-images";
import { ProductInfo } from "../../../components/customer/products/show/product-info";
import "./product-description.css";

const { Text, Title } = Typography;

const CustomerProductShow: React.FC = () => {
  const { id } = useParams();
  const { addToCart } = useCart();

  const { data: productData, isLoading: isProductLoading } =
    useOne<BlindBoxDto>({
      resource: "blind-boxes",
      id: id || "",
    });

  // Only fetch brand data if we have a valid brandId
  const brandId = productData?.data?.brand?.brandId;
  const shouldFetchBrand = !!brandId;

  const { data: brandData, isLoading: isBrandLoading } = useOne<BrandDto>({
    resource: "brands",
    id: brandId || "",
    queryOptions: {
      enabled: shouldFetchBrand,
    },
  });

  const handleAddToCart = (sku: StockKeepingUnitDto) => {
    const product = productData?.data;
    if (product && sku) {
      // Calculate base price
      const basePrice = sku.price || 0;
      
      // Find active campaign if exists
      const hasActiveCampaign = product.blindBoxCampaigns && product.blindBoxCampaigns.length > 0;
      const activePromotionalCampaignId = hasActiveCampaign 
        ? product.blindBoxCampaigns?.[0]?.promotionalCampaignId 
        : undefined;
      
      addToCart({
        skuId: sku.skuId || 0,
        name: `${product.name || ''} - ${sku.name || ''}`,
        price: basePrice,
        originalPrice: basePrice,
        checkoutPrice: basePrice,
        stock: sku.stock || 0,
        imageUrl: product.images?.[0]?.imageUrl || '',
        blindBoxId: product.blindBoxId || 0,
        promotionalCampaignId: activePromotionalCampaignId,
      });

      notification.success({
        message: "Added to Cart",
        description: `${product.name || ''} - ${sku.name || ''} has been added to your cart.`,
      });
    }
  };

  // Handle the product loading state
  if (isProductLoading) {
    return <LoadingState />;
  }

  // Handle the case where product data fails to load
  if (!productData?.data) {
    return <Empty description="Product not found" />;
  }

  // Separate loading state for brand data
  const isLoadingBrand = shouldFetchBrand && isBrandLoading;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {/* Product details section */}
      <Row gutter={[32, 32]} className="mb-8">
        <Col xs={24} md={12}>
          <ProductImages product={productData.data} />
        </Col>
        <Col xs={24} md={12}>
          {isLoadingBrand ? (
            <Spin tip="Loading brand information...">
              <ProductInfo
                product={productData.data}
                brand={undefined}
                onAddToCart={handleAddToCart}
              />
            </Spin>
          ) : (
            <ProductInfo
              product={productData.data}
              brand={brandData?.data}
              onAddToCart={handleAddToCart}
            />
          )}
        </Col>
      </Row>

      {/* Full-width Description Section */}
      {(productData.data.description || brandData?.data?.description) && (
        <div className="product-details-section">
          <Card className="shadow-sm">
            <Title level={4} className="flex items-center">
              <InfoCircleOutlined className="mr-2" /> Product Information
            </Title>
            
            <Divider className="mt-2 mb-6" />
            
            {productData.data.description && (
              <div className="mb-8">
                <Title level={5}>Description</Title>
                <div 
                  className="product-description" 
                  dangerouslySetInnerHTML={{ __html: productData.data.description }}
                />
              </div>
            )}
            
            {brandData?.data?.description && (
              <div>
                <Title level={5}>About the Brand</Title>
                <div 
                  className="brand-description" 
                  dangerouslySetInnerHTML={{ __html: brandData.data.description }}
                />
              </div>
            )}
          </Card>
        </div>
      )}
    </div>
  );
};

export default CustomerProductShow;
