import React from "react";
import {Button, Col, Row, Spin, Typography} from "antd";
import {useGo, useList} from "@refinedev/core";
import {BlindBoxDto} from "../../../../../generated";
import ProductItem from "./product-item";

const {Title, Text} = Typography;

const ProductSeries: React.FC = () => {
  const go = useGo();
  const {data, isLoading, isError} = useList<BlindBoxDto>({
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
        <Text type="danger">Error loading products. Please try again
          later.</Text>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="py-12 text-center">
        <Spin size="large"/>
      </div>
    );
  }

  const series = data?.data || [];

  return (
    <div className="py-12">
      <div className="mb-8 flex justify-between items-center">
        <div>
          <Title level={2} className="!mb-2">Popular Series</Title>
          <Text className="text-gray-600">Discover our latest and most exciting
            blind box series</Text>
        </div>
        <Button
          type="link"
          size="large"
          onClick={() => go({to: '/products'})}
        >
          View All Series
        </Button>
      </div>

      <Row gutter={[16, 24]}>
        {series.map((item: BlindBoxDto) => {
          return (
            <Col xs={24} sm={12} md={8} key={item.blindBoxId}>
              <ProductItem item={item}/>
            </Col>
          );
        })}
      </Row>
    </div>
  );
};

export default ProductSeries;