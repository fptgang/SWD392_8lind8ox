import React, { useState } from "react";
import {
  Card,
  Typography,
  Tabs,
  Row,
  Col,
  Statistic,
  Spin,
  Button,
  Divider,
  Table,
  Select,
  Space,
  DatePicker,
  Empty
} from "antd";
import {
  ShoppingOutlined,
  RiseOutlined,
  AreaChartOutlined,
  BarChartOutlined,
  PieChartOutlined,
  UserOutlined,
  DollarOutlined,
  EyeOutlined,
  StarOutlined,
  CalendarOutlined,
  LineChartOutlined
} from "@ant-design/icons";
import { useCustom } from "@refinedev/core";
import CountUp from 'react-countup';
import { 
  AreaChart, Area, BarChart, Bar, PieChart, Pie, LineChart, Line,
  XAxis, YAxis, CartesianGrid, Tooltip as RechartsTooltip, Legend, 
  ResponsiveContainer, Cell
} from 'recharts';
import dayjs from 'dayjs';

const { Title, Text, Paragraph } = Typography;
const { TabPane } = Tabs;
const { RangePicker } = DatePicker;

// Define enum for trending intervals
enum TrendingInterval {
  WEEK = "WEEK",
  MONTH = "MONTH",
  YEAR = "YEAR"
}

interface TrendingProductStats {
  id?: number;
  name?: string;
  totalSales?: number;
  totalViews?: number;
  averageRating?: number;
  price?: number;
  imageUrl?: string;
}

// Sample category data for the pie chart
const categoryData = [
  { name: 'Action Figures', value: 35 },
  { name: 'Collectibles', value: 25 },
  { name: 'Anime', value: 20 },
  { name: 'Limited Edition', value: 15 },
  { name: 'Other', value: 5 },
];

// Sample colors for the pie chart
const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884d8'];

// Sample timeline data
const generateTimelineData = (days: number) => {
  const data = [];
  const now = new Date();
  for (let i = days; i >= 0; i--) {
    const date = new Date(now);
    date.setDate(date.getDate() - i);
    const formattedDate = date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
    data.push({
      date: formattedDate,
      sales: Math.floor(Math.random() * 100) + 50,
      views: Math.floor(Math.random() * 1000) + 200,
    });
  }
  return data;
};

const StatisticsPage: React.FC = () => {
  const [activeTab, setActiveTab] = useState("1");
  const [statsInterval, setStatsInterval] = useState<TrendingInterval>(TrendingInterval.MONTH);
  const [timeRange, setTimeRange] = useState('7d');
  
  // Generate sample timeline data based on the selected range
  const timelineData = React.useMemo(() => {
    switch(timeRange) {
      case '7d': return generateTimelineData(7);
      case '30d': return generateTimelineData(30);
      case '90d': return generateTimelineData(90);
      default: return generateTimelineData(7);
    }
  }, [timeRange]);

  // Fetch trending product stats
  const { data: statsData, isLoading: statsLoading } = useCustom<TrendingProductStats[]>({
    url: "trending-products",
    method: "get",
    config: {
      query: {
        interval: statsInterval
      }
    }
  });

  // Prepare stats data
  const formatStatsData = () => {
    if (!statsData) return { 
      totalSales: 0,
      totalViews: 0,
      avgRating: 0,
      topProducts: 0,
      totalRevenue: 0
    };

    try {
      const products = Array.isArray(statsData) ? statsData : 
                      (statsData as any)?.data || [];
      
      return {
        totalSales: products.reduce((sum: number, p: TrendingProductStats) => sum + (p.totalSales || 0), 0),
        totalViews: products.reduce((sum: number, p: TrendingProductStats) => sum + (p.totalViews || 0), 0),
        avgRating: products.reduce((sum: number, p: TrendingProductStats) => sum + (p.averageRating || 0), 0) / 
                  (products.length || 1),
        totalRevenue: products.reduce((sum: number, p: TrendingProductStats) => 
          sum + ((p.totalSales || 0) * (p.price || 0)), 0),
        topProducts: products.length
      };
    } catch (e) {
      console.error("Error processing stats data:", e);
      return { 
        totalSales: 0,
        totalViews: 0,
        avgRating: 0,
        topProducts: 0,
        totalRevenue: 0
      };
    }
  };

  const stats = formatStatsData();

  // Format product data for the table
  const productTableData = React.useMemo(() => {
    if (!statsData) return [];
    
    const products = Array.isArray(statsData) ? statsData : 
                     (statsData as any)?.data || [];
    
    return products.map((product: TrendingProductStats, index: number) => ({
      key: product.id || index,
      name: product.name || `Product ${index + 1}`,
      sales: product.totalSales || 0,
      views: product.totalViews || 0,
      rating: product.averageRating || 0,
      price: product.price || 0,
      image: product.imageUrl || 'https://via.placeholder.com/50'
    }));
  }, [statsData]);
  
  // Table columns
  const columns = [
    {
      title: 'Product',
      dataIndex: 'name',
      key: 'name',
      render: (text: string, record: any) => (
        <div className="flex items-center">
          <img 
            src={record.image} 
            alt={text} 
            className="w-10 h-10 rounded mr-3 object-cover"
          />
          <span>{text}</span>
        </div>
      ),
    },
    {
      title: 'Sales',
      dataIndex: 'sales',
      key: 'sales',
      sorter: (a: any, b: any) => a.sales - b.sales,
    },
    {
      title: 'Views',
      dataIndex: 'views',
      key: 'views',
      sorter: (a: any, b: any) => a.views - b.views,
    },
    {
      title: 'Rating',
      dataIndex: 'rating',
      key: 'rating',
      render: (rating: number) => (
        <div className="flex items-center">
          {rating.toFixed(1)}
          <div className="ml-2 flex">
            {[...Array(5)].map((_, i) => (
              <StarOutlined 
                key={i} 
                className={`text-xs ${i < Math.round(rating) ? "text-yellow-400" : "text-gray-300"}`}
              />
            ))}
          </div>
        </div>
      ),
      sorter: (a: any, b: any) => a.rating - b.rating,
    },
    {
      title: 'Price',
      dataIndex: 'price',
      key: 'price',
      render: (price: number) => `$${price.toFixed(2)}`,
      sorter: (a: any, b: any) => a.price - b.price,
    },
  ];

  const formatter = (value: number | string) => {
    return <CountUp end={Number(value)} separator="," />;
  };

  const handleTimeRangeChange = (value: string) => {
    setTimeRange(value);
  };

  const handleDateRangeChange = (dates: any) => {
    if (dates && dates.length === 2) {
      // Custom date range logic would go here
      console.log('Date range changed:', dates);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <Title level={2} className="mb-2">Sales & Analytics Dashboard</Title>
          <Paragraph className="text-gray-500">
            Comprehensive analytics and statistics about your blind box products
          </Paragraph>
        </div>
        
        {/* Time period selector */}
        <Card className="mb-8 shadow-sm">
          <div className="flex flex-wrap justify-between items-center">
            <Title level={4} className="mb-0 flex items-center">
              <CalendarOutlined className="mr-2" /> Time Period
            </Title>
            <Space>
              <Select
                value={timeRange}
                onChange={handleTimeRangeChange}
                style={{ width: 120 }}
              >
                <Select.Option value="7d">Last 7 days</Select.Option>
                <Select.Option value="30d">Last 30 days</Select.Option>
                <Select.Option value="90d">Last 90 days</Select.Option>
              </Select>
              <RangePicker 
                format="YYYY-MM-DD"
                onChange={handleDateRangeChange}
              />
              <Button type="primary">Apply</Button>
            </Space>
          </div>
        </Card>
        
        {/* Stats Cards */}
        {statsLoading ? (
          <div className="flex justify-center py-8">
            <Spin size="large" />
          </div>
        ) : (
          <Row gutter={[16, 16]} className="mb-8">
            <Col xs={12} sm={12} md={6}>
              <Card className="h-full shadow-sm hover:shadow-md transition-shadow duration-300">
                <Statistic
                  title="Total Sales"
                  value={stats.totalSales}
                  formatter={formatter}
                  prefix={<ShoppingOutlined className="text-blue-500" />}
                  valueStyle={{ color: '#1677ff' }}
                />
                <div className="mt-2 text-xs text-gray-500">
                  <RiseOutlined className="text-green-500 mr-1" />
                  <span className="text-green-500 font-medium">+5.2%</span> vs previous period
                </div>
              </Card>
            </Col>
            <Col xs={12} sm={12} md={6}>
              <Card className="h-full shadow-sm hover:shadow-md transition-shadow duration-300">
                <Statistic
                  title="Total Revenue"
                  value={stats.totalRevenue}
                  precision={2}
                  formatter={(value) => `$${formatter(value)}`}
                  prefix={<DollarOutlined className="text-green-500" />}
                  valueStyle={{ color: '#52c41a' }}
                />
                <div className="mt-2 text-xs text-gray-500">
                  <RiseOutlined className="text-green-500 mr-1" />
                  <span className="text-green-500 font-medium">+8.1%</span> vs previous period
                </div>
              </Card>
            </Col>
            <Col xs={12} sm={12} md={6}>
              <Card className="h-full shadow-sm hover:shadow-md transition-shadow duration-300">
                <Statistic
                  title="Total Views"
                  value={stats.totalViews}
                  formatter={formatter}
                  prefix={<EyeOutlined className="text-purple-500" />}
                  valueStyle={{ color: '#722ed1' }}
                />
                <div className="mt-2 text-xs text-gray-500">
                  <RiseOutlined className="text-green-500 mr-1" />
                  <span className="text-green-500 font-medium">+12.4%</span> vs previous period
                </div>
              </Card>
            </Col>
            <Col xs={12} sm={12} md={6}>
              <Card className="h-full shadow-sm hover:shadow-md transition-shadow duration-300">
                <Statistic
                  title="Conversion Rate"
                  value={(stats.totalSales / (stats.totalViews || 1)) * 100}
                  precision={2}
                  suffix="%"
                  prefix={<UserOutlined className="text-orange-500" />}
                  valueStyle={{ color: '#fa8c16' }}
                />
                <div className="mt-2 text-xs text-gray-500">
                  <RiseOutlined className="text-green-500 mr-1" />
                  <span className="text-green-500 font-medium">+2.3%</span> vs previous period
                </div>
              </Card>
            </Col>
          </Row>
        )}
        
        {/* Charts and Analytics */}
        <Tabs activeKey={activeTab} onChange={setActiveTab} className="mb-8">
          <TabPane 
            tab={<span><AreaChartOutlined /> Overview</span>} 
            key="1"
          >
            <Row gutter={[16, 16]}>
              <Col xs={24} lg={16}>
                <Card 
                  title={<div className="flex items-center"><AreaChartOutlined className="mr-2" /> Sales & Views Trend</div>} 
                  className="h-full shadow-sm"
                >
                  <ResponsiveContainer width="100%" height={350}>
                    <AreaChart
                      data={timelineData}
                      margin={{ top: 10, right: 30, left: 0, bottom: 0 }}
                    >
                      <CartesianGrid strokeDasharray="3 3" />
                      <XAxis dataKey="date" />
                      <YAxis yAxisId="left" />
                      <YAxis yAxisId="right" orientation="right" />
                      <RechartsTooltip />
                      <Legend />
                      <Area 
                        yAxisId="left"
                        type="monotone" 
                        dataKey="sales" 
                        name="Sales" 
                        stroke="#1677ff" 
                        fill="#1677ff" 
                        fillOpacity={0.3} 
                      />
                      <Area 
                        yAxisId="right"
                        type="monotone" 
                        dataKey="views" 
                        name="Views" 
                        stroke="#722ed1" 
                        fill="#722ed1" 
                        fillOpacity={0.3} 
                      />
                    </AreaChart>
                  </ResponsiveContainer>
                </Card>
              </Col>
              <Col xs={24} lg={8}>
                <Card 
                  title={<div className="flex items-center"><PieChartOutlined className="mr-2" /> Categories</div>} 
                  className="h-full shadow-sm"
                >
                  <ResponsiveContainer width="100%" height={350}>
                    <PieChart>
                      <Pie
                        data={categoryData}
                        cx="50%"
                        cy="50%"
                        labelLine={false}
                        label={({ name, percent }: { name: string; percent: number }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                        outerRadius={80}
                        fill="#8884d8"
                        dataKey="value"
                      >
                        {categoryData.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                        ))}
                      </Pie>
                      <RechartsTooltip />
                    </PieChart>
                  </ResponsiveContainer>
                </Card>
              </Col>
            </Row>
          </TabPane>
          <TabPane 
            tab={<span><BarChartOutlined /> Products</span>} 
            key="2"
          >
            <Card className="shadow-sm">
              <div className="mb-4 flex justify-between items-center">
                <Title level={4} className="m-0">Top Products Performance</Title>
                <Space>
                  <Select
                    defaultValue={TrendingInterval.MONTH}
                    style={{ width: 120 }}
                    onChange={(value) => setStatsInterval(value as TrendingInterval)}
                  >
                    <Select.Option value={TrendingInterval.WEEK}>Weekly</Select.Option>
                    <Select.Option value={TrendingInterval.MONTH}>Monthly</Select.Option>
                    <Select.Option value={TrendingInterval.YEAR}>Yearly</Select.Option>
                  </Select>
                </Space>
              </div>
              
              {statsLoading ? (
                <div className="flex justify-center py-16">
                  <Spin size="large" />
                </div>
              ) : productTableData.length > 0 ? (
                <Table 
                  columns={columns} 
                  dataSource={productTableData} 
                  pagination={{ pageSize: 10 }}
                  className="mt-4"
                />
              ) : (
                <Empty description="No product data available" />
              )}
            </Card>
          </TabPane>
        </Tabs>
        
        {/* Additional Stats */}
        <Row gutter={[16, 16]}>
          <Col xs={24} md={12}>
            <Card 
              title={<div className="flex items-center"><BarChartOutlined className="mr-2" /> Top Selling Products</div>}
              className="shadow-sm h-full"
            >
              <ResponsiveContainer width="100%" height={350}>
                <BarChart
                  data={productTableData.slice(0, 5)}
                  layout="vertical"
                  margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
                >
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis type="number" />
                  <YAxis dataKey="name" type="category" width={150} />
                  <RechartsTooltip />
                  <Legend />
                  <Bar dataKey="sales" name="Sales" fill="#1677ff" barSize={20} />
                </BarChart>
              </ResponsiveContainer>
            </Card>
          </Col>
          <Col xs={24} md={12}>
            <Card 
              title={<div className="flex items-center"><LineChartOutlined className="mr-2" /> Conversion Rate Trend</div>}
              className="shadow-sm h-full"
            >
              <ResponsiveContainer width="100%" height={350}>
                <LineChart
                  data={timelineData}
                  margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
                >
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="date" />
                  <YAxis />
                  <RechartsTooltip />
                  <Legend />
                  <Line 
                    type="monotone" 
                    dataKey="sales" 
                    name="Sales" 
                    stroke="#1677ff" 
                    activeDot={{ r: 8 }} 
                  />
                </LineChart>
              </ResponsiveContainer>
            </Card>
          </Col>
        </Row>
      </div>
    </div>
  );
};

export default StatisticsPage; 