import { useList } from "@refinedev/core";
import { SetDto } from "../../../../generated";
import { useState } from "react";
import {
  Card,
  Typography,
  Spin,
  Tag,
  Divider,
  Row,
  Col,
  Empty,
  Select,
  Input,
  Space,
  Button,
  Tooltip,
} from "antd";
import { useNavigate } from "react-router";
import {
  SortAscendingOutlined,
  SortDescendingOutlined,
  SearchOutlined,
  FilterOutlined,
  ReloadOutlined,
} from "@ant-design/icons";

const { Title, Paragraph, Text } = Typography;
const { Meta } = Card;
const { Option } = Select;
const { Search } = Input;

// Define sort options
const SORT_OPTIONS = [
  { label: "Name (A-Z)", value: "name:asc" },
  { label: "Name (Z-A)", value: "name:desc" },
  { label: "Price (Low to High)", value: "price:asc" },
  { label: "Price (High to Low)", value: "price:desc" },
  { label: "Newest First", value: "createdAt:desc" },
  { label: "Oldest First", value: "createdAt:asc" },
];

const CustomerCasesPage = () => {
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState<string>("");
  const [sortBy, setSortBy] = useState<string>("name:asc");
  const [currentPage, setCurrentPage] = useState(1);
  const navigate = useNavigate();

  // Parse sort option
  const [sortField, sortOrder] = sortBy.split(":");

  const {
    data: sets,
    isLoading,
    refetch,
  } = useList<SetDto>({
    resource: "sets",
    config: {
      pagination: {
        pageSize: 100,
        current: currentPage,
      },
    },
    liveMode: "auto",
  });

  // Extract unique categories for filtering
  const categories = sets?.data
    ? [...new Set(sets.data.map((set) => set.category).filter(Boolean))]
    : [];

  // Handle search
  const handleSearch = (value: string) => {
    setSearchTerm(value);
    setCurrentPage(1); // Reset to first page on new search
  };

  // Handle sort change
  const handleSortChange = (value: string) => {
    setSortBy(value);
    setCurrentPage(1); // Reset to first page on sort change
  };

  // Handle reset filters
  const handleReset = () => {
    setSelectedCategory(null);
    setSearchTerm("");
    setCurrentPage(1);
    refetch();
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center min-h-[80vh]">
        <Spin size="large" />
      </div>
    );
  }

  return (
    <div className="container mx-auto py-8 px-4">
      {/* Header Section */}
      <div className="flex justify-between items-center mb-6">
        <Title level={2} className="font-bold m-0">
          Browse Our Collections
        </Title>
        <Button
          icon={<ReloadOutlined />}
          onClick={handleReset}
          title="Reset all filters"
        >
          Reset
        </Button>
      </div>

      {/* Search and Filter Section */}
      <div className="bg-white p-6 rounded-lg shadow-sm mb-8">
        <Space direction="vertical" className="w-full">
          <div className="flex flex-wrap gap-4 items-center justify-between">
            {/* Search Bar */}
            <Search
              placeholder="Search collections..."
              allowClear
              value={searchTerm}
              onChange={(e) => handleSearch(e.target.value)}
              className="w-full md:w-96"
              prefix={<SearchOutlined className="text-gray-400" />}
            />

            {/* Sort Dropdown */}
            <Select
              value={sortBy}
              onChange={handleSortChange}
              className="w-full md:w-64"
              placeholder="Sort by..."
              suffixIcon={
                sortOrder === "asc" ? (
                  <SortAscendingOutlined />
                ) : (
                  <SortDescendingOutlined />
                )
              }
            >
              {SORT_OPTIONS.map((option) => (
                <Option key={option.value} value={option.value}>
                  {option.label}
                </Option>
              ))}
            </Select>
          </div>

          {/* Categories */}
          <div className="mt-4">
            <Text strong className="mr-2">
              <FilterOutlined /> Categories:
            </Text>
            <div className="flex flex-wrap gap-2 mt-2">
              <Tag
                color={selectedCategory === null ? "blue" : "default"}
                onClick={() => setSelectedCategory(null)}
                className="cursor-pointer mb-2 px-3 py-1 hover:shadow-sm transition-all"
              >
                All
              </Tag>
              {categories.map((category) => (
                <Tag
                  key={category}
                  color={selectedCategory === category ? "blue" : "default"}
                  onClick={() => setSelectedCategory(category)}
                  className="cursor-pointer mb-2 px-3 py-1 hover:shadow-sm transition-all"
                >
                  {category}
                </Tag>
              ))}
            </div>
          </div>
        </Space>
      </div>

      <Divider className="mb-8" />

      {/* Results Section */}
      {sets?.data.length === 0 ? (
        <Empty
          description={
            <div>
              <p>No sets found.</p>
              <Button type="primary" onClick={handleReset}>
                Clear Filters
              </Button>
            </div>
          }
          className="py-12"
        />
      ) : (
        <Row gutter={[24, 24]}>
          {sets?.data.map((set) => (
            <Col xs={24} sm={12} md={8} lg={6} key={set.setId}>
              <Card
                hoverable
                cover={
                  <div className="relative">
                    <img
                      alt={set.sku?.name}
                      src={
                        set.sku?.image?.imageUrl ||
                        "https://via.placeholder.com/300x200?text=No+Image"
                      }
                      className="h-48 w-full object-cover"
                    />
                    {/* Status Badge */}
                    {set.sku?.status && (
                      <Tag
                        color={
                          set.sku.status === "AVAILABLE" ? "success" : "error"
                        }
                        className="absolute top-2 right-2"
                      >
                        {set.sku.status}
                      </Tag>
                    )}
                  </div>
                }
                className="h-full flex flex-col transition-all duration-300 hover:shadow-lg"
                onClick={() => navigate(`/case/${set.setId}`)}
                actions={[
                  <Tooltip title="Total Slots">
                    <div>
                      <Text type="secondary">
                        <span className="mr-1">🎲</span>
                        {set.slots?.filter((s) => s.state === "AVAILABLE")
                          .length || 0}
                        /{set.slots?.length || 0} slots available
                      </Text>
                    </div>
                  </Tooltip>,
                  <Tooltip title="Specification Count">
                    <div>
                      <Text type="secondary">
                        <span className="mr-1">📦</span>
                        {set.sku?.specCount || 0} specs
                      </Text>
                    </div>
                  </Tooltip>,
                ]}
              >
                <Meta
                  title={
                    <div className="flex justify-between items-start mb-2">
                      <Tooltip title={set.sku?.name}>
                        <Text strong className="text-lg truncate block">
                          {set.sku?.name}
                        </Text>
                      </Tooltip>
                      {set.sku?.price && (
                        <Text className="text-lg font-semibold text-blue-600 whitespace-nowrap">
                          ${set.sku.price.toFixed(2)}
                        </Text>
                      )}
                    </div>
                  }
                  description={
                    <div className="space-y-2">
                      {/* SKU Details */}
                      <div className="flex flex-col gap-2">
                        {/* Brand Info */}
                        {set.blindBox?.brand && (
                          <div className="flex items-center gap-2">
                            <Tag
                              color="blue"
                              className="truncate max-w-[120px]"
                            >
                              {set.blindBox.brand.name}
                            </Tag>
                            {set.blindBox.brand.country && (
                              <Tag color="cyan">
                                {set.blindBox.brand.country}
                              </Tag>
                            )}
                          </div>
                        )}

                        {/* SKU Metadata */}
                        <div className="grid grid-cols-2 gap-2 text-xs text-gray-500">
                          {set.sku?.code && (
                            <Tooltip title="SKU Code">
                              <div className="truncate">
                                <Text type="secondary">
                                  Code: {set.sku.code}
                                </Text>
                              </div>
                            </Tooltip>
                          )}
                          {set.sku?.weight && (
                            <Tooltip title="Weight">
                              <div className="truncate text-right">
                                <Text type="secondary">{set.sku.weight}g</Text>
                              </div>
                            </Tooltip>
                          )}
                        </div>

                        {/* Description or Spec Count */}
                        <Paragraph
                          ellipsis={{ rows: 2 }}
                          className="text-gray-500 text-sm"
                        >
                          {set.sku?.description ||
                            `Contains ${
                              set.sku?.specCount || 0
                            } specifications`}
                        </Paragraph>
                      </div>

                      {/* Availability Status */}
                      <div className="flex justify-between items-center mt-2">
                        <div className="flex items-center gap-1">
                          <div
                            className={`w-2 h-2 rounded-full ${
                              set.sku?.stock > 0 ? "bg-green-500" : "bg-red-500"
                            }`}
                          />
                          <Text type="secondary" className="text-xs">
                            {set.sku?.stock > 0 ? "In Stock" : "Out of Stock"}
                          </Text>
                        </div>
                        {set.sku?.stock && (
                          <Tooltip title="Available Quantity">
                            <Text type="secondary" className="text-xs">
                              {set.sku.stock} left
                            </Text>
                          </Tooltip>
                        )}
                      </div>
                    </div>
                  }
                />
              </Card>
            </Col>
          ))}
        </Row>
      )}
    </div>
  );
};

export default CustomerCasesPage;
