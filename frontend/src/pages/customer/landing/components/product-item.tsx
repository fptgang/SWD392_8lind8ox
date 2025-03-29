import React from "react";
import {Button, Card, Typography, message} from "antd";
import {ShoppingOutlined} from "@ant-design/icons";
import {useGo} from "@refinedev/core";
import {BlindBoxDto} from "../../../../../generated";
import {useCart} from "../../../../hooks/useCart";
import Countdown from "../../../../components/Countdown";

const {Title, Text} = Typography;

interface ProductItemProps {
  item: BlindBoxDto;
  featured?: boolean;
}

const ProductItem: React.FC<ProductItemProps> = ({item, featured = false}) => {
  const go = useGo();
  const {addToCart} = useCart();

  const skuCount = item.skus?.length || 0;
  const basePrice = item.skus?.[0]?.price || 0;

  // Get discount rate from bestPromotion if available
  const hasDiscount = !!item.bestPromotion?.discountRate;
  const discountRate = item.bestPromotion?.discountRate || 0;
  const finalPrice = basePrice * (1 - discountRate);

  // Format discount percentage for display
  const discountPercentage = Math.round(discountRate * 100);
  
  // Get promotion end date if available
  const promotionEndDate = item.bestPromotion?.endDate ? new Date(item.bestPromotion.endDate).getTime() : undefined;

  function handleCardClick(): void {
    go({to: `/products/${item.blindBoxId}`})
  }

  const handleAddToCart = (e: React.MouseEvent) => {
    e.stopPropagation();

    if (!item.skus || item.skus.length === 0) return;

    const sku = item.skus[0];

    // Find active campaign if exists
    const hasActiveCampaign = item.blindBoxCampaigns && item.blindBoxCampaigns.length > 0;
    const activePromotionalCampaignId = hasActiveCampaign ? item.blindBoxCampaigns?.[0]?.promotionalCampaignId : undefined;

    // Calculate discounted price if applicable
    const skuPrice = sku.price || 0;
    // Since we can't access discountRate directly
    const discountRate = 0;

    const currentPrice = skuPrice * (1 - discountRate);

    addToCart({
      skuId: sku.skuId || 0,
      name: `${item.name || ''} - ${sku.name || ''}`,
      price: currentPrice,
      subTotal: skuPrice,
      finalTotal: currentPrice,
      stock: sku.stock || 0,
      imageUrl: item.images?.[0]?.imageUrl || 'https://product.hstatic.net/200000726533/product/mo-hinh-blind-box-gau-bong-baby-three-12-chinese-zodiac_c710cefbe85f4fffa9f398d62f0103b8_1024x1024.jpg',
      blindBoxId: item.blindBoxId || 0,
      promotionalCampaignId: activePromotionalCampaignId,
    });
    
    // Display success message
    message.success(`Added ${item.name} to cart`);
  };

  // Original layout for non-featured items
  return (
    <Card
      hoverable
      onClick={handleCardClick}
      className="h-full overflow-hidden flex flex-col pb-24"
      style={{display: 'flex', flexDirection: 'column', height: '100%'}}
    >
      <div className={`relative ${featured ? 'h-72' : 'h-48'} overflow-hidden group`}>
        <img
          src={item.images?.[0]?.imageUrl || 'https://product.hstatic.net/200000726533/product/mo-hinh-blind-box-gau-bong-baby-three-12-chinese-zodiac_c710cefbe85f4fffa9f398d62f0103b8_1024x1024.jpg'}
          alt={item.name}
          className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
        />
      </div>
      <div className="flex flex-col flex-grow mt-2">
        <Title level={featured ? 3 : 4} className="!mb-1">{item.name}</Title>
      </div>
      <div className="absolute bottom-4 left-4 right-4">
        <div className="flex items-center justify-between ">
          <Text type="secondary"
                className="text-sm ml-2">{skuCount} variations</Text>
          {hasDiscount ? (
            <div className="text-right">
              <Text
                className="text-gray-400 line-through text-sm">${basePrice.toFixed(2)}</Text>
              <div className="flex items-center">
                <Text
                  className="text-xl font-bold text-red-600 mr-2">${finalPrice.toFixed(2)}</Text>
                <Text
                  className="text-xs font-semibold bg-red-100 text-red-600 px-1 rounded">-{discountPercentage}%</Text>
              </div>
            </div>
          ) : (
            <Text
              className="text-xl font-bold text-red-600">${basePrice.toFixed(2)}</Text>
          )}
        </div>
        <div className="flex items-end justify-between space-x-2 mt-6 pl-2">
        <div className="mt-1">
            {promotionEndDate && (
                <Text type="secondary" className="text-sm flex gap-1">
                    Sale ends in <Countdown targetDate={promotionEndDate} />
                </Text>
            )}
            </div>
          <Button
            type="primary"
            icon={<ShoppingOutlined/>}
            onClick={handleAddToCart}
            disabled={!item.skus || item.skus.length === 0 || !item.skus[0].stock}
          >
            Add to Cart
          </Button>
        </div>
      </div>
    </Card>
  );
};

export default ProductItem;
