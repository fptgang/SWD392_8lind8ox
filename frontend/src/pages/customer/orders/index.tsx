import React from 'react';
import { useList } from '@refinedev/core';
import { Card, Col, Row, Typography, Space, Input, Tag, Pagination, Select, DatePicker } from 'antd';
import { SearchOutlined, ShoppingOutlined, ClockCircleOutlined } from '@ant-design/icons';
import { OrderDto } from '../../../../generated';
import { formatCurrency } from '../../../utils/currency-formatter';

const { Title, Text } = Typography;
const { Search } = Input;
const { RangePicker } = DatePicker;

const CustomerOrders: React.FC = () => {
  const [searchTerm, setSearchTerm] = React.useState('');
  const [currentPage, setCurrentPage] = React.useState(1);
  const [status, setStatus] = React.useState<string | null>(null);
  const [dateRange, setDateRange] = React.useState<[Date | null, Date | null]>([null, null]);

  const { data, isLoading } = useList<OrderDto>({
    resource: 'orders',
    pagination: {
      current: currentPage,
      pageSize: 10,
    },
    filters: [
      {
        field: 'status',
        operator: 'eq',
        value: status,
      },
      {
        field: 'createdAt',
        operator: 'gte',
        value: dateRange[0]?.toISOString(),
      },
      {
        field: 'createdAt',
        operator: 'lte',
        value: dateRange[1]?.toISOString(),
      },
    ],
    sorters: [
      {
        field: 'createdAt',
        order: 'desc',
      },
    ],
  });

  const handleSearch = (value: string) => {
    setSearchTerm(value);
    setCurrentPage(1);
  };

  const handleStatusChange = (value: string | null) => {
    setStatus(value);
    setCurrentPage(1);
  };

  const handleDateRangeChange = (dates: any) => {
    setDateRange(dates);
    setCurrentPage(1);
  };

  const handlePageChange = (page: number) => {
    setCurrentPage(page);
  };

  const getStatusTag = (status: string) => {
    const statusConfig: Record<string, { color: string; text: string }> = {
      PENDING: { color: 'gold', text: 'Pending' },
      COMPLETED: { color: 'green', text: 'Completed' },
      CANCELED: { color: 'red', text: 'Canceled' },
    };

    const config = statusConfig[status] || { color: 'default', text: status };
    return <Tag color={config.color}>{config.text}</Tag>;
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="mb-8">
        <Title level={2}>My Orders</Title>
        <Text className="text-gray-600">
          Track and manage your order history
        </Text>
      </div>

      <div className="mb-8">
        <Row gutter={[16, 16]} align="middle">
          <Col xs={24} md={8}>
            <Search
              placeholder="Search orders..."
              allowClear
              enterButton={<SearchOutlined />}
              size="large"
              onSearch={handleSearch}
            />
          </Col>
          <Col xs={24} md={8}>
            <Select
              placeholder="Filter by Status"
              style={{ width: '100%' }}
              allowClear
              onChange={handleStatusChange}
              size="large"
            >
              <Select.Option value="PENDING">Pending</Select.Option>
              <Select.Option value="COMPLETED">Completed</Select.Option>
              <Select.Option value="CANCELED">Canceled</Select.Option>
            </Select>
          </Col>
          <Col xs={24} md={8}>
            <RangePicker
              style={{ width: '100%' }}
              size="large"
              onChange={handleDateRangeChange}
            />
          </Col>
        </Row>
      </div>

      <Row gutter={[16, 16]}>
        {data?.data?.map((order: OrderDto) => (
          <Col span={24} key={order.orderId}>
            <Card hoverable>
              <div className="flex flex-col md:flex-row justify-between">
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <ShoppingOutlined className="text-lg" />
                    <Text strong>Order #{order.orderId}</Text>
                    {getStatusTag(order.status)}
                  </div>
                  <div className="flex items-center space-x-2">
                    <ClockCircleOutlined className="text-gray-400" />
                    <Text type="secondary">
                      {new Date(order.createdAt).toLocaleDateString()}
                    </Text>
                  </div>
                </div>
                <div className="mt-4 md:mt-0 text-right">
                  <Text className="text-lg font-semibold text-green-600">
                    {formatCurrency(order.totalPrice)}
                  </Text>
                </div>
              </div>
            </Card>
          </Col>
        ))}
      </Row>

      <div className="mt-8 flex justify-center">
        <Pagination
          current={currentPage}
          total={data?.total || 0}
          pageSize={10}
          onChange={handlePageChange}
          showSizeChanger={false}
        />
      </div>
    </div>
  );
};

export default CustomerOrders;