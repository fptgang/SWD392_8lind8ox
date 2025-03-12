import React from "react";
import { Card, Typography, Row, Col, Button, Tag, Carousel, Spin } from "antd";
import { ThunderboltOutlined, StarOutlined, ShoppingOutlined } from "@ant-design/icons";
import { useList, useGo } from "@refinedev/core";
import { BlindBoxDto, StockKeepingUnitDto } from "../../../../../generated";
import { useCart } from "../../../../hooks/useCart";

const { Title, Text } = Typography;

const TrendingProducts: React.FC = () => {
  const { addToCart } = useCart();
  const go = useGo();
  
  const { data, isLoading, isError } = useList<BlindBoxDto>({
    resource: "blind-boxes",   
    pagination: {
      pageSize: 4
    },
    sorters: [
      {
        field: "createdAt",
        order: "desc"
      }
    ],
    meta: {
      include: ["skus", "images", "blindBoxCampaigns"]
    }
  });

  // Helper function to calculate the current price
  const calculateCurrentPrice = (product: BlindBoxDto): number => {
    if (!product.skus || product.skus.length === 0) return 0;
    
    // Get the first SKU's price as base price
    const basePrice = product.skus[0].price || 0;
    
    // Check if there's an active campaign
    const hasActiveCampaign = product.blindBoxCampaigns && product.blindBoxCampaigns.length > 0;
    if (!hasActiveCampaign) return basePrice;
    
    // Since we can't access discountRate directly, return base price
    return basePrice;
  };

  const handleAddToCart = (e: React.MouseEvent, product: BlindBoxDto) => {
    e.stopPropagation(); // Prevent card click event from triggering
    
    if (!product.skus || product.skus.length === 0) return;
    
    const sku = product.skus[0];
    const currentPrice = calculateCurrentPrice(product);
    
    // Find active campaign if exists
    const hasActiveCampaign = product.blindBoxCampaigns && product.blindBoxCampaigns.length > 0;
    const activePromotionalCampaign = hasActiveCampaign ? product.blindBoxCampaigns?.[0]?.promotionalCampaignId : undefined;
    
    addToCart({
      skuId: sku.skuId || 0,
      name: product.name || '',
      price: currentPrice,
      subTotal: sku.price || 0,
      finalTotal: currentPrice,
      stock: sku.stock || 0,
      imageUrl: product.images?.[0]?.imageUrl || 'https://product.hstatic.net/200000726533/product/mo-hinh-blind-box-gau-bong-baby-three-12-chinese-zodiac_c710cefbe85f4fffa9f398d62f0103b8_1024x1024.jpg',
      blindBoxId: product.blindBoxId || 0,
      promotionalCampaignId: activePromotionalCampaign,
    });
  };

  const handleCardClick = (product: BlindBoxDto) => {
    if (product.blindBoxId) {
      go({ to: `/products/${product.blindBoxId}` });
    }
  };

  const handleViewMoreDeals = () => {
    go({ to: '/products' });
  };

  if (isError) {
    return (
      <div className="py-8 text-center">
        <Text type="danger">Error loading flash deals. Please try again later.</Text>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="py-8 text-center">
        <Spin size="large" />
      </div>
    );
  }

  return (
    <div className="py-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center space-x-2">
          <ThunderboltOutlined className="text-2xl text-yellow-500" />
          <Title level={2} className="!mb-0">Flash Deals</Title>
        </div>
        <Button 
          type="link" 
          icon={<StarOutlined />} 
          onClick={handleViewMoreDeals}
        >
          View More Deals
        </Button>
      </div>

      <Row gutter={[16, 16]}>
        {data?.data?.map((product: BlindBoxDto) => {
          const currentPrice = calculateCurrentPrice(product);
          const hasDiscount = product.blindBoxCampaigns && product.blindBoxCampaigns.length > 0;
          const subTotal = product.skus?.[0]?.price || 0;
          
          return (
            <Col xs={12} sm={12} md={6} key={product.blindBoxId}>
              <Card
                hoverable
                className="relative overflow-hidden cursor-pointer"
                onClick={() => handleCardClick(product)}
                cover={
                  <div className="relative pt-[100%] overflow-hidden group">
                    <img
                      alt={product.name}
                      src={product.images?.[0]?.imageUrl || 'https://product.hstatic.net/200000726533/product/mo-hinh-blind-box-gau-bong-baby-three-12-chinese-zodiac_c710cefbe85f4fffa9f398d62f0103b8_1024x1024.jpg'}
                      className="absolute top-0 left-0 w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
                    />
                    {hasDiscount && (
                      <Tag color="red" className="absolute top-2 right-2">
                        ON SALE
                      </Tag>
                    )}
                  </div>
                }
              >
                <Card.Meta
                  title={product.name}
                  description={
                    <div className="space-y-2">
                      <div>
                        <Text className="text-lg font-semibold">
                          ${currentPrice.toFixed(2)}
                        </Text>
                        {hasDiscount && (
                          <Text delete className="ml-2 text-gray-400">
                            ${subTotal.toFixed(2)}
                          </Text>
                        )}
                      </div>
                      <Button
                        type="primary"
                        icon={<ShoppingOutlined />}
                        block
                        onClick={(e) => handleAddToCart(e, product)}
                        disabled={!product.skus || product.skus.length === 0 || !product.skus[0].stock}
                      >
                        Add to Cart
                      </Button>
                    </div>
                  }
                />
              </Card>
            </Col>
          );
        })}
      </Row>
    </div>
  );
};

export default TrendingProducts;