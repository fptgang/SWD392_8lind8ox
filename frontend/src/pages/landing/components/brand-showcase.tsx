import React from "react";
import { Card, Typography, Row, Col, Button } from "antd";
import { RightOutlined } from "@ant-design/icons";

const { Title, Text } = Typography;

const brands = [
  {
    id: 1,
    name: "Bandai",
    image: "/public/brands/bandai.png",
    productCount: 128,
    description: "Official Gundam & Dragon Ball Series"
  },
  {
    id: 2,
    name: "Good Smile Company",
    image: "/public/brands/goodsmile.png",
    productCount: 95,
    description: "Premium Nendoroid Series"
  },
  {
    id: 3,
    name: "Kotobukiya",
    image: "/public/brands/kotobukiya.png",
    productCount: 76,
    description: "Exclusive Anime Figure Series"
  },
  {
    id: 4,
    name: "Max Factory",
    image: "/public/brands/maxfactory.png",
    productCount: 64,
    description: "High-Quality Figma Series"
  }
];

const BrandShowcase: React.FC = () => {
  return (
    <div className="py-12">
      <div className="mb-8 flex justify-between items-center">
        <div>
          <Title level={2} className="!mb-2">Featured Brands</Title>
          <Text type="secondary">Explore authentic series from top manufacturers</Text>
        </div>
        <Button type="link" size="large" icon={<RightOutlined />}>
          View All Brands
        </Button>
      </div>

      <Row gutter={[16, 16]}>
        {brands.map((brand) => (
          <Col xs={12} sm={12} md={6} key={brand.id}>
            <Card hoverable className="text-center h-full">
              <div className="mb-4 h-24 flex items-center justify-center">
                <img
                  src={brand.image}
                  alt={brand.name}
                  className="max-h-full max-w-full object-contain"
                />
              </div>
              <Title level={4} className="!mb-2">{brand.name}</Title>
              <Text type="secondary" className="block mb-2">{brand.description}</Text>
              <Text type="primary">{brand.productCount} Products</Text>
            </Card>
          </Col>
        ))}
      </Row>
    </div>
  );
};

export default BrandShowcase;