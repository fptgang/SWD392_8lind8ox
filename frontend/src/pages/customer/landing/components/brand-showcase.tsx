import React from "react";
import { Card, Typography, Row, Col, Button, Spin } from "antd";
import { RightOutlined } from "@ant-design/icons";
import { useList } from "@refinedev/core";
import { BrandDto } from "../../../../../generated";

const { Title, Text } = Typography;

const BrandShowcase: React.FC = () => {
  const { data, isLoading, isError } = useList<BrandDto>({
    resource: "brands",
    pagination: {
      pageSize: 4
    },
  });

  if (isError) {
    return (
      <div className="py-12 text-center">
        <Text type="danger">Error loading brands. Please try again later.</Text>
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

  const brands = data?.data || [];

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
          <Col xs={12} sm={12} md={6} key={brand.brandId}>
            <Card hoverable className="text-center h-full">
              <div className="mb-4 h-24 flex items-center justify-center">
                <img
                  src={`https://bizweb.dktcdn.net/thumb/large/100/515/274/products/c-users-admin-desktop-hinh-san-pham-hirono-shelter-new-folder-20240715-143423-251736-8-1200x1200.jpg`}
                  alt={brand.name}
                  className="max-h-full max-w-full object-contain"
                />
              </div>
              <Title level={4} className="!mb-2">{brand.name}</Title>
              <Text type="secondary" className="block mb-2">{brand.description}</Text>
              <Text type="secondary">{brand.blindBoxes?.length || 0} Products</Text>
            </Card>
          </Col>
        ))}
      </Row>
    </div>
  );
};

export default BrandShowcase;