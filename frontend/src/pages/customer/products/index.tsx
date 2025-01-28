import React from 'react';
import { useList } from '@refinedev/core';
import { Card, Col, Row, Typography, Space, Input, Select, Pagination, Slider, Form, Button, Spin } from 'antd';
import { SearchOutlined, ShoppingOutlined } from '@ant-design/icons';
import { BlindBoxDto, BrandDto } from '../../../../generated';
import { useCart } from '../../../hooks/useCart';

const { Title, Text } = Typography;
const { Search } = Input;

const CustomerProducts: React.FC = () => {
  const { addItem } = useCart();
  const [form] = Form.useForm();
  const [searchTerm, setSearchTerm] = React.useState('');
  const [selectedBrand, setSelectedBrand] = React.useState<string | null>(null);
  const [priceRange, setPriceRange] = React.useState<[number, number]>([0, 1000]);
  const [currentPage, setCurrentPage] = React.useState(1);
  const [sortBy, setSortBy] = React.useState('popular');

  const { data: brandsData } = useList<BrandDto>({
    resource: 'brands',
    filters: [
      {
        field: 'isVisible',
        operator: 'eq',
        value: true,
      },
    ],
  });

  const { data, isLoading } = useList<BlindBoxDto>({
    resource: 'blind-boxes',
    queryOptions: {
      enabled: true,
    },

    pagination: {
      current: currentPage,
      pageSize: 12,
    },
    meta: {
        
      query: {
        q: searchTerm,
      },
    },
    filters: [
      {
        field: 'brandId',
        operator: 'eq',
        value: selectedBrand,
      },
      {
        field: 'currentPrice',
        operator: 'gte',
        value: priceRange[0],
      },
      {
        field: 'currentPrice',
        operator: 'lte',
        value: priceRange[1],
      },
      {
        field: 'isVisible',
        operator: 'eq',
        value: true,
      },
    ],
  });

  const handleSearch = (value: string) => {
    setSearchTerm(value);
    setCurrentPage(1);
  };

  const handleBrandChange = (value: string | null) => {
    setSelectedBrand(value);
    setCurrentPage(1);
  };

  const handlePriceChange = (value: [number, number]) => {
    setPriceRange(value);
    setCurrentPage(1);
  };

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
  };

  const handleReset = () => {
    form.resetFields();
    setSearchTerm('');
    setSelectedBrand(null);
    setPriceRange([0, 1000]);
    setCurrentPage(1);
  };

    function handleAddToCart(product: BlindBoxDto): void {
        console.log('Adding product to cart:', product);
        addItem({
          id: String(product.blindBoxId || ''),
          name: product.name || '',
          price: product.currentPrice || 0,
          image: product.images?.[0] || '/placeholder-image.jpg',
        });
    }

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="sticky top-0 z-10 bg-white shadow-sm mb-6 p-4">
        <Row gutter={[16, 16]} align="middle">
          <Col xs={24} md={16}>
            <Search
              placeholder="Search products..."
              allowClear
              enterButton={<SearchOutlined />}
              size="large"
              onSearch={handleSearch}
              className="w-full"
            />
          </Col>
          <Col xs={24} md={8}>
            <Select
              style={{ width: '100%' }}
              size="large"
              value={sortBy}
              onChange={(value) => setSortBy(value)}
            >
              <Select.Option value="popular">Most Popular</Select.Option>
              <Select.Option value="newest">Newest Arrivals</Select.Option>
              <Select.Option value="price-asc">Price: Low to High</Select.Option>
              <Select.Option value="price-desc">Price: High to Low</Select.Option>
            </Select>
          </Col>
        </Row>
      </div>

      <Row gutter={[16, 16]} className="mb-6">
        <Col xs={24} md={6}>
          <Card className="sticky top-24">
            <Form form={form}>
              <Form.Item label="Brand">
                <Select
                  placeholder="Select Brand"
                  allowClear
                  onChange={handleBrandChange}
                  style={{ width: '100%' }}
                >
                  {brandsData?.data?.map((brand: any) => (
                    <Select.Option key={brand.brandId} value={brand.brandId}>
                      {brand.name}
                    </Select.Option>
                  ))}
                </Select>
              </Form.Item>
              <Form.Item label="Price Range">
                <Slider
                  range
                  min={0}
                  max={1000}
                  value={priceRange}
                  onChange={(value: number[]) => handlePriceChange(value as [number, number])}
                />
                <div className="flex justify-between text-gray-500 text-sm">
                  <span>${priceRange[0]}</span>
                  <span>${priceRange[1]}</span>
                </div>
              </Form.Item>
              <Button type="default" block onClick={handleReset}>Reset Filters</Button>
            </Form>
          </Card>
        </Col>
        <Col xs={24} md={18}>
          <Row gutter={[16, 16]}>
            {isLoading ? (
              <Col span={24} className="text-center py-8">
                <Spin size="large" />
              </Col>
            ) : data?.data?.length === 0 ? (
              <Col span={24} className="text-center py-8">
                <Text>No products found</Text>
              </Col>
            ) : (
              data?.data?.map((product: BlindBoxDto) => (
                <Col xs={12} sm={8} md={8} lg={6} key={product.blindBoxId}>
                  <Card
                    hoverable
                    cover={
                      <div className="relative pt-[100%] overflow-hidden">
                        <img
                          alt={product.name}
                          src={product.images?.[0] || '/placeholder-image.jpg'}
                          className="absolute top-0 left-0 w-full h-full object-cover transition-transform duration-300 hover:scale-110"
                        />
                        {product.discount > 0 && (
                          <div className="absolute top-2 right-2 bg-red-500 text-white px-2 py-1 rounded-sm text-xs font-bold">
                            -{product.discount}%
                          </div>
                        )}
                      </div>
                    }
                    bodyStyle={{ padding: '12px' }}
                  >
                    <div className="mb-2">
                      <Text className="text-sm line-clamp-2" style={{ height: '3em' }}>
                        {product.name}
                      </Text>
                    </div>
                    <Space direction="vertical" size={2} className="w-full">
                      <div className="flex items-baseline gap-2">
                        <Text className="text-lg font-bold text-red-500">
                          ${product.currentPrice}
                        </Text>
                        {product.originalPrice && product.originalPrice > product.currentPrice && (
                          <Text delete className="text-xs text-gray-400">
                            ${product.originalPrice}
                          </Text>
                        )}
                      </div>
                      <div className="flex items-center justify-between text-xs text-gray-500">
                        <Text>Sold {product.soldCount || 0}</Text>
                        <Text>{product.rating || 4.5} ★</Text>
                      </div>
                      <Button
                        type="primary"
                        icon={<ShoppingOutlined />}
                        block
                        onClick={() => handleAddToCart(product)}
                        className="mt-2"
                      >
                        Add to Cart
                      </Button>
                    </Space>
                  </Card>
                </Col>
              ))
            )}
          </Row>
          {data?.total && data.total > 0 && (
            <div className="mt-6 text-center">
              <Pagination
                current={currentPage}
                total={data.total}
                pageSize={12}
                onChange={handlePageChange}
                showSizeChanger={false}
              />
            </div>
          )}
        </Col>
      </Row>
    </div>
  );
};

export default CustomerProducts;