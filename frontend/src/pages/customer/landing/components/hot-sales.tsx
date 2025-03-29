import React from "react";
import {Col, notification, Row, Spin, Typography} from "antd";
import {ThunderboltOutlined} from "@ant-design/icons";
import {useCustom} from "@refinedev/core";
import {BlindBoxDto, GetBlindBoxes200Response} from "../../../../../generated";
import ProductItem from "./product-item";

const {Title, Text} = Typography;

const HotSaleProducts: React.FC = () => {
  const {data, isLoading, isError} = useCustom<GetBlindBoxes200Response>({
    url: "sales/hot-sale-products",
    method: "get",
    config: {
      query: {
        size: 6
      },
    },
    onError: (error) => {
      console.error("Error fetching trending products:", error);
      notification.error({
        message: "Error loading hot sales products",
        description: "Unable to load hot sales products at this time. Please try again later.",
        placement: "topRight",
        duration: 5,
      });
    },
  });

  if (isError) {
    return (
      <div className="py-8 text-center">
        <Text type="danger">Error loading flash deals. Please try again
          later.</Text>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="py-8 text-center">
        <Spin size="large"/>
      </div>
    );
  }

  return (
    <div className="py-8">
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center space-x-2">
          <ThunderboltOutlined className="text-2xl text-yellow-500"/>
          <Title level={2} className="!mb-0">Hot Sales</Title>
        </div>
      </div>

      <Row gutter={[16, 16]} className="mt-4">
        {data?.data?.content?.map((product: BlindBoxDto) => (
          <Col xs={24} sm={12} md={8} key={product.blindBoxId}>
            <ProductItem item={product} />
          </Col>
        ))}
      </Row>
    </div>
  );
};

export default HotSaleProducts;