import React from "react";
import { Card, Typography, Row, Col, Button, Tag, Carousel, Spin } from "antd";
import { ThunderboltOutlined, StarOutlined, ShoppingOutlined } from "@ant-design/icons";
import { useList } from "@refinedev/core";
import { BlindBoxDto } from "../../../../generated";
import { useCart } from "../../../hooks/useCart";

const { Title, Text } = Typography;

const TrendingProducts: React.FC = () => {
  const { addItem } = useCart();
  const { data, isLoading, isError } = useList<BlindBoxDto>({
    resource: "blind-boxes",
    filters: [
      {
        field: "isVisible",
        operator: "eq",
        value: true
      },
    ],
    pagination: {
      pageSize: 4
    },
    sorters: [
      {
        field: "currentPrice",
        order: "asc"
      }
    ]
  });

  const handleAddToCart = (product: BlindBoxDto) => {
    addItem({
      id: product.blindBoxId || '',
      name: product.name || '',
      price: product.currentPrice || 0,
      image: product.images?.[0] || '/placeholder-image.jpg',
    });
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
        <Button type="link" icon={<StarOutlined />}>
          View More Deals
        </Button>
      </div>

      <Row gutter={[16, 16]}>
        {data?.data?.map((product: BlindBoxDto) => (
          <Col xs={12} sm={12} md={6} key={product.blindBoxId}>
            <Card
              hoverable
              className="relative overflow-hidden"
              cover={
                <div className="relative pt-[100%] overflow-hidden group">
                  <img
                    alt={product.name}
                    src={product?.images?.[0] || '/placeholder-image.jpg'}
                    className="absolute top-0 left-0 w-full h-full object-cover transition-transform duration-300 group-hover:scale-110"
                  />
                </div>
              }
            >
              <Card.Meta
                title={product.name}
                description={
                  <div className="space-y-2">
                    <Text className="text-lg font-semibold">
                      ${product.currentPrice}
                    </Text>
                    <Button
                      type="primary"
                      icon={<ShoppingOutlined />}
                      block
                      onClick={() => handleAddToCart(product)}
                    >
                      Add to Cart
                    </Button>
                  </div>
                }
              />
            </Card>
          </Col>
        ))}
      </Row>
    </div>
  );
};

export default TrendingProducts;