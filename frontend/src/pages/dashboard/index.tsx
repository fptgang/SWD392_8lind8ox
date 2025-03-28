import React, { useState } from "react";
import {
  Card,
  Typography,
  Tabs,
  Row,
  Col,
  Spin,
  Space,
  DatePicker,
} from "antd";
import {
  AreaChartOutlined,
  BarChartOutlined,
  FireOutlined,
  LineChartOutlined,
  PieChartOutlined,
} from "@ant-design/icons";
import { useCustom } from "@refinedev/core";
import { Line, Column, Pie, Bar } from '@ant-design/plots';
import dayjs from "dayjs";
import { Table } from "antd/lib";

const { Title, Paragraph } = Typography;
const { RangePicker } = DatePicker;

const DashboardPage: React.FC = () => {
  const [timeRange, setTimeRange] = useState<[dayjs.Dayjs, dayjs.Dayjs]>([
    dayjs().subtract(7, "days"),
    dayjs(),
  ]);

  const API_BASE = "stats"; // API Base URL

  // 📡 Fetch Data from API Endpoints
  const fetchStats = (endpoint: string, additionalParams = {}) =>
    useCustom({
      url: `${API_BASE}/${endpoint}`,
      method: "get",
      config: {
        query: {
          "start-date": timeRange[0].toISOString(),
          "end-date": timeRange[1].toISOString(),
          ...additionalParams,
        },
      },
    });

  const { data: dailyRevenueResponse, isLoading: dailyRevenueLoading } = fetchStats("daily-revenue");
  const { data: dailyOrdersResponse, isLoading: dailyOrdersLoading } = fetchStats("daily-order");
  const { data: monthlyRevenueResponse, isLoading: monthlyRevenueLoading } = fetchStats("monthly-revenue");
  const { data: revenueBySkuResponse, isLoading: revenueBySkuLoading } = fetchStats("revenue-by-sku");
  const { data: revenueByBrandResponse, isLoading: revenueByBrandLoading } = fetchStats("revenue-by-brand");
  const { data: revenueByBlindBoxResponse, isLoading: revenueByBlindBoxLoading } = fetchStats("revenue-by-blind-box");
  const { data: topSellingSkusResponse, isLoading: topSellingSkusLoading } = fetchStats("top-selling-skus", { limit: 10 });

  const isLoading =
    dailyRevenueLoading ||
    dailyOrdersLoading ||
    monthlyRevenueLoading ||
    revenueBySkuLoading ||
    revenueByBrandLoading ||
    revenueByBlindBoxLoading ||
    topSellingSkusLoading;

    
  // 📊 Transform API Response Data (Simplified)
  const transformData = (response: any) =>
    response?.data?.map((item: any) => ({
      key: item.key || "Unknown",
      value: item.value ?? 0,
    })) || [];
  
  

  // 📈 Define Chart Configurations
  const commonConfig = {
    autoFit: true,  // let the chart auto-fit its container
    padding: [30, 30, 50, 50],
  };

  const dailyRevenueConfig = {
    data: transformData(dailyRevenueResponse),
    xField: "key",
    yField: "value",
    point: {
      shapeField: 'square',
      sizeField: 4,
    },
    interaction: {
      tooltip: {
        marker: false,
      },
    },
    style: {
      lineWidth: 2,
    },
  };
  const monthlyRevenueConfig = {
    data: transformData(monthlyRevenueResponse),
    xField: "key",
    yField: "value",
    shapeField: 'column25D',
    style: {
      fill: 'rgba(126, 212, 236, 0.8)',
    },
  };

  const dailyOrdersConfig = {
    ...commonConfig,
    data: transformData(dailyOrdersResponse),
    xField: "key",
    yField: "value",
    smooth: true,
    point: { shape: "circle", size: 4 },
    color: "#ff4d4f",
  };

  const revenueBySkuConfig = {
    data: transformData(revenueBySkuResponse),
    xField: 'key',
    yField: 'value',
    sort: {
      reverse: true,
    },
  };
  

  const revenueByBrandConfig = {
    data: transformData(revenueByBrandResponse),
    angleField: 'value',
    colorField: 'key',
    label: {
      text: 'value',
      position: 'outside',
    },
    legend: {
      color: {
        title: false,
        position: 'right',
        rowPadding: 5,
      },
    },
  };

  const revenueByBlindBoxConfig = {
    data: transformData(revenueByBlindBoxResponse),
    angleField: 'value',
    colorField: 'key',
    innerRadius: 0.6,
    label: {
      text: 'value',
      style: {
        fontWeight: 'bold',
      },
    },
    legend: {
      color: {
        title: false,
        position: 'right',
        rowPadding: 5,
      },
    },
    annotations: [
      {
        type: 'text',
        style: {
          text: 'Blindbox\nCharts',
          x: '50%',
          y: '50%',
          textAlign: 'center',
          fontSize: 40,
          fontStyle: 'bold',
        },
      },
    ],
  };

  const topSellingSkusColumns = [
    {
      title: "Product Name",
      dataIndex: "key",
      key: "key",
      render: (text: string) => <strong>{text}</strong>,
    },
    {
      title: "Quantity Sold",
      dataIndex: "value",
      key: "value",
      align: "right" as "right",
      render: (text: number) => text.toLocaleString(),
    },
  ];


  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <Title level={2}>Sales & Analytics Dashboard</Title>
        <Paragraph className="text-gray-500">
          Comprehensive analytics and statistics about your blind box products
        </Paragraph>

        {/* 📆 Date Picker */}
        <Card className="mb-8">
          <Space>
            <RangePicker
              value={timeRange}
              format="YYYY-MM-DD"
              onChange={(dates) => {
                if (dates && dates[0] && dates[1]) {
                  setTimeRange([dates[0], dates[1]]);
                }
              }}
            />
          </Space>
        </Card>

        {/* Show Loading Spinner */}
        {topSellingSkusLoading ? (
          <Spin size="large" className="flex justify-center py-8" />
        ) : (
          <Tabs
            defaultActiveKey="1"
            items={[
              {
                key: "1",
                label: (
                  <span style={{ fontWeight: "bold", fontSize: "16px", color: "#000" }}>
                    <LineChartOutlined style={{ marginRight: 5 }} /> Revenue Overview
                  </span>
                ),
                children: (
                  <Row gutter={[16, 16]}>
                    <Col span={12}>
                      <Card title="Daily Revenue" >
                        <Line {...dailyRevenueConfig} />
                      </Card>
                    </Col>
                    <Col span={12}>
                      <Card title="Monthly Revenue" >
                        <Column {...monthlyRevenueConfig} />
                      </Card>
                    </Col>
                  </Row>
                ),
              },
              {
                key: "2",
                label: (
                  <span style={{ fontWeight: "bold", fontSize: "16px", color: "#000" }}>
                    <PieChartOutlined style={{ marginRight: 5 }} /> Revenue Distribution
                  </span>
                ),
                children: (
                  <Row gutter={[16, 16]}>
                    <Col span={12}>
                      <Card title="Revenue by Brand" >
                        <Pie {...revenueByBrandConfig} />
                      </Card>
                    </Col>
                    <Col span={12}>
                      <Card title="Revenue by Blind Box" >
                        <Pie {...revenueByBlindBoxConfig} />
                      </Card>
                    </Col>
                  </Row>
                ),
              },
              {
                key: "3",
                label: (
                  <span style={{ fontWeight: "bold", fontSize: "16px", color: "#000" }}>
                    <BarChartOutlined style={{ marginRight: 5 }} /> Revenue by SKU
                  </span>
                ),
                children: (
                  <Card title="Revenue by SKU" >
                    <Bar {...revenueBySkuConfig} />
                  </Card>
                ),
              },
              {
                key: "4",
                label: (
                  <span style={{ fontWeight: "bold", fontSize: "16px", color: "#000" }}>
                    <FireOutlined style={{ marginRight: 5 }} /> Trending
                  </span>
                ),
                children: (
                  <Table
                    title={() => <Title level={4}>Top Selling SKUs</Title>}
                    dataSource={transformData(topSellingSkusResponse)}
                    columns={topSellingSkusColumns}
                    pagination={{ pageSize: 5 }}
                    bordered
                  />
                ),
              },
            ]}
          />
        )}
      </div>
    </div>
  );
};

export { DashboardPage };
export default DashboardPage;
