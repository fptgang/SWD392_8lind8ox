import React from "react";
import { Card, Typography, Row, Col, Button, Tag, Rate, Spin } from "antd";
import { ShoppingOutlined, FireOutlined } from "@ant-design/icons";
import { useGo, useList } from "@refinedev/core";
import { BlindBoxDto } from "../../../../../generated";
import { useCart } from "../../../../hooks/useCart";

const { Title, Text } = Typography;

const ProductSeries: React.FC = () => {
  const go = useGo();
  const { addToCart } = useCart();
  const { data, isLoading, isError } = useList<BlindBoxDto>({
    resource: "blind-boxes",
    pagination: {
      pageSize: 6
    },
    sorters: [
      {
        field: "createdAt",
        order: "desc"
      }
    ],
    meta: {
      include: ["skus", "images", "blindBoxCampaigns"],
    }
  });

  if (isError) {
    return (
      <div className="py-12 text-center">
        <Text type="danger">Error loading products. Please try again later.</Text>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="py-12 text-center">
        <Spin size="large" />
      </div>
    );
  }

  const series = data?.data || [];

  function handleCardClick(item: BlindBoxDto): void {
    go({to: `/products/${item.blindBoxId}`})
  }

  const handleAddToCart = (product: BlindBoxDto) => {
    if (!product.skus || product.skus.length === 0) return;
    
    const sku = product.skus[0];
    
    // Find active campaign if exists
    const hasActiveCampaign = product.blindBoxCampaigns && product.blindBoxCampaigns.length > 0;
    const activePromotionalCampaignId = hasActiveCampaign ? product.blindBoxCampaigns?.[0]?.promotionalCampaignId : undefined;
    
    // Calculate discounted price if applicable
    const skuPrice = sku.price || 0;
    // Since we can't access discountRate directly
    const discountRate = 0;
    
    const currentPrice = skuPrice * (1 - discountRate);
    
    addToCart({
      skuId: sku.skuId || 0,
      name: `${product.name || ''} - ${sku.name || ''}`,
      price: currentPrice,
      subTotal: skuPrice,
      finalTotal: currentPrice,
      stock: sku.stock || 0,
      imageUrl: product.images?.[0]?.imageUrl || 'https://product.hstatic.net/200000726533/product/mo-hinh-blind-box-gau-bong-baby-three-12-chinese-zodiac_c710cefbe85f4fffa9f398d62f0103b8_1024x1024.jpg',
      blindBoxId: product.blindBoxId || 0,
      promotionalCampaignId: activePromotionalCampaignId,
    });
  };

  return (
    <div className="py-12">
      <div className="mb-8 flex justify-between items-center">
        <div>
          <Title level={2} className="!mb-2">Popular Series</Title>
          <Text className="text-gray-600">Discover our latest and most exciting blind box series</Text>
        </div>
        <Button 
          type="link" 
          size="large"
          onClick={() => go({ to: '/products' })}
        >
          View All Series
        </Button>
      </div>
      
      <Row gutter={[16, 24]}>
        {series.map((item: BlindBoxDto) => {
          const skuCount = item.skus?.length || 0;
          const basePrice = item.skus?.[0]?.price || 0;
          
          return (
            <Col xs={24} sm={12} md={8} key={item.blindBoxId}>
              <div className="relative">
                <Card
                  hoverable
                  onClick={() => handleCardClick(item)}
                  className="h-full overflow-hidden flex flex-col"
                >
                  <div className="relative h-48 overflow-hidden group">
                    <img
                      src={item.images?.[0]?.imageUrl || 'https://product.hstatic.net/200000726533/product/mo-hinh-blind-box-gau-bong-baby-three-12-chinese-zodiac_c710cefbe85f4fffa9f398d62f0103b8_1024x1024.jpg'}
                      alt={item.name}
                      className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
                    />
                  </div>
                  <div className="flex flex-col flex-grow p-4">
                    <div className="flex-grow">
                      <Title level={4} className="!mb-1">{item.name}</Title>
                      <Text type="secondary" className="block min-h-3 max-h-[4em]"
                      ellipsis={{
                        expanded: false,
                        symbol: '...',
                      }}
                      >{item.description}</Text>
                      
                      <div className="flex items-center justify-between mt-2">
                        <div className="flex items-center space-x-2">
                          <Text type="secondary" className="text-sm">{skuCount} variations</Text>
                        </div>
                        <Text className="text-xl font-bold text-red-600">${basePrice.toFixed(2)}</Text>
                      </div>
                    </div>
                  </div>
                </Card>
                <Button 
                  type="primary" 
                  icon={<ShoppingOutlined />}
                  className="absolute bottom-4 left-4 right-4"
                  onClick={(e) => {
                    e.stopPropagation();
                    handleAddToCart(item);
                  }}
                  disabled={!item.skus || item.skus.length === 0 || !item.skus[0].stock}
                >
                  Add to Cart
                </Button>
              </div>
            </Col>
          );
        })}
      </Row>
    </div>
  );
};

export default ProductSeries;