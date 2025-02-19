import React from "react";
import { useList } from "@refinedev/core";
import {
  Card,
  Col,
  Row,
  Typography,
  Space,
  Input,
  Tag,
  Pagination,
} from "antd";
import { SearchOutlined } from "@ant-design/icons";

const { Title, Text } = Typography;
const { Search } = Input;

const CustomerDeals: React.FC = () => {
  const [searchTerm, setSearchTerm] = React.useState("");
  const [currentPage, setCurrentPage] = React.useState(1);

  const { data, isLoading } = useList({
    resource: "promotional-campaigns",
    pagination: {
      current: currentPage,
      pageSize: 12,
    },
    filters: [
      {
        field: "name",
        operator: "contains",
        value: searchTerm,
      },
      {
        field: "status",
        operator: "eq",
        value: "ACTIVE",
      },
    ],
  });

  const handleSearch = (value: string) => {
    setSearchTerm(value);
    setCurrentPage(1);
  };

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
  };

  const calculateDiscount = (
    originalPrice: number,
    discountPercentage: number
  ) => {
    return originalPrice - (originalPrice * discountPercentage) / 100;
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="mb-8">
        <Title level={2}>Special Deals & Offers</Title>
        <Text className="text-gray-600">
          Explore our latest promotions and special discounts
        </Text>
      </div>

      <div className="flex flex-col md:flex-row justify-between items-center mb-6 gap-4">
        <Search
          placeholder="Search deals..."
          allowClear
          enterButton={<SearchOutlined />}
          size="large"
          className="w-full md:w-96"
          onSearch={handleSearch}
        />
      </div>

      <Row gutter={[16, 16]}>
        {data?.data.map((deal: any) => (
          <Col xs={24} sm={12} md={8} lg={6} key={deal.id}>
            <Card
              hoverable
              cover={
                <div className="relative">
                  <img
                    alt={deal.name}
                    src={deal.imageUrl || "https://placeholder.com/300x300"}
                    className="object-cover h-48 w-full"
                  />
                  <Tag color="red" className="absolute top-2 right-2">
                    {deal.discountPercentage}% OFF
                  </Tag>
                </div>
              }
            >
              <Card.Meta
                title={deal.name}
                description={
                  <Space direction="vertical">
                    <div className="flex items-center gap-2">
                      <Text className="text-lg font-semibold text-red-500">
                        $
                        {calculateDiscount(
                          deal.originalPrice,
                          deal.discountPercentage
                        )}
                      </Text>
                      <Text className="text-sm line-through text-gray-400">
                        ${deal.originalPrice}
                      </Text>
                    </div>
                    <Text className="text-gray-500 line-clamp-2">
                      {deal.description}
                    </Text>
                    <Text className="text-xs text-gray-400">
                      Valid until: {new Date(deal.endDate).toLocaleDateString()}
                    </Text>
                  </Space>
                }
              />
            </Card>
          </Col>
        ))}
      </Row>

      <div className="mt-8 flex justify-center">
        <Pagination
          current={currentPage}
          total={data?.total || 0}
          pageSize={12}
          onChange={handlePageChange}
          showSizeChanger={false}
        />
      </div>
    </div>
  );
};

export default CustomerDeals;
