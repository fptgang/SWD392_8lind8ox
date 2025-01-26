import React from "react";
import { Card, Typography, Row, Col, Button, Tag, Rate, Spin } from "antd";
import { ShoppingOutlined, FireOutlined } from "@ant-design/icons";
import { useList } from "@refinedev/core";
import { BlindBoxDto } from "../../../../generated";

const { Title, Text } = Typography;

// Temporary data for fallback
const fallbackSeries = [
  {
    id: 1,
    title: "Anime Heroes Series 2023",
    description: "Limited Edition Blind Box Series",
    image: "/public/series/anime.jpg",
    price: "¥2,999",
    rating: 4.8,
    sales: 2345,
    isNew: true
  },
  {
    id: 2,
    title: "Mythical Beasts Series",
    description: "Legendary Creatures Blind Box",
    image: "/public/series/fantasy.jpg",
    price: "¥3,499",
    rating: 4.9,
    sales: 1890,
    isHot: true
  },
  {
    id: 3,
    title: "Pop Culture Series Vol.5",
    description: "Trending Icons Mystery Box",
    image: "/public/series/pop.jpg",
    price: "¥2,799",
    rating: 4.7,
    sales: 2100,
    isLimited: true
  },
  {
    id: 4,
    title: "Kawaii Series 2023",
    description: "Cute Characters Blind Box",
    image: "/public/series/kawaii.jpg",
    price: "¥2,599",
    rating: 4.6,
    sales: 1678,
    isNew: true
  },
  {
    id: 5,
    title: "Street Fashion Series",
    description: "Urban Style Blind Box",
    image: "/public/series/street.jpg",
    price: "¥3,299",
    rating: 4.8,
    sales: 1234,
    isHot: true
  },
  {
    id: 6,
    title: "Mecha Warriors Series",
    description: "Robot Fighters Blind Box",
    image: "/public/series/mecha.jpg",
    price: "¥3,999",
    rating: 4.9,
    sales: 890,
    isLimited: true
  }
];

const ProductSeries: React.FC = () => {
  const { data, isLoading, isError } = useList<BlindBoxDto>({
    resource: "blind-boxes",
    filters: [
      {
        field: "isVisible",
        operator: "eq",
        value: true
      }
    ],
    pagination: {
      pageSize: 6
    },
    sorters: [
      {
        field: "createdAt",
        order: "desc"
      }
    ]
  });

  if (isError) {
    return (
      <div className="py-12 text-center">
        <Text type="danger">Error loading products. Please try again later.</Text>
      </div>
    );
  }

  const series = data?.data || fallbackSeries;

  return (
    <div className="py-12">
      <div className="mb-8 flex justify-between items-center">
        <div>
          <Title level={2} className="!mb-2">Popular Series</Title>
          <Text className="text-gray-600">Discover our latest and most exciting blind box series</Text>
        </div>
        <Button type="link" size="large">
          View All Series
        </Button>
      </div>
      
      <Row gutter={[16, 24]}>
        {series.map((item :BlindBoxDto) => (
          <Col xs={24} sm={12} md={8} key={item.blindBoxId}>
            <Card
              hoverable
              className="h-full overflow-hidden"
              cover={
                <div className="relative h-48 overflow-hidden group">
                 
                </div>
              }
            >
              <div className="space-y-2">
                <Title level={4} className="!mb-1">{item.name}</Title>
                <Text type="secondary">{item.description}</Text>
                
                <div className="flex items-center justify-between mt-2">
                  <div className="flex items-center space-x-2">
                    <Text type="secondary" className="text-sm">{item.currentPrice} sold</Text>
                  </div>
                  <Text className="text-xl font-bold text-red-600">{item.currentPrice}</Text>
                </div>
                
                <Button 
                  type="primary" 
                  icon={<ShoppingOutlined />}
                  className="w-full mt-4"
                >
                  Add to Cart
                </Button>
              </div>
            </Card>
          </Col>
        ))}
      </Row>
    </div>
  );
};

export default ProductSeries;