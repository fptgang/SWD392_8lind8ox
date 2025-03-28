import React, { useEffect, useState } from "react";
import NavBar from "./nav-bar";
import Hero from "./components/hero";
import BrandShowcase from "./components/brand-showcase";
import TrendingProducts from "./components/trending-products";
import ProductSeries from "./components/product-series";
import TrustedBy from "./components/trusted-by";
import {
  Button,
  Typography,
  BackTop,
  Card,
  Statistic,
  Row,
  Col,
  Spin,
  Tooltip,
} from "antd";
import {
  ArrowUpOutlined,
  GiftOutlined,
  FireOutlined,
  CrownOutlined,
  RiseOutlined,
  EyeOutlined,
  ShoppingOutlined,
  StarOutlined,
} from "@ant-design/icons";
import { motion } from "framer-motion";
import { useGo, useCustom } from "@refinedev/core";
import CountUp from "react-countup";

// Define enum for trending intervals
enum TrendingInterval {
  WEEK = "WEEK",
  MONTH = "MONTH",
  YEAR = "YEAR",
}

interface TrendingProductStats {
  id?: number;
  name?: string;
  totalSales?: number;
  totalViews?: number;
  averageRating?: number;
}

const { Title, Text } = Typography;

export default function LandingPage() {
  const [hoverIndex, setHoverIndex] = useState<number | null>(null);
  const go = useGo();
  const [statsInterval, setStatsInterval] = useState<TrendingInterval>(
    TrendingInterval.MONTH
  );

  // Fetch trending product stats
  const {
    data: statsData,
    isLoading: statsLoading,
    isError: statsError,
  } = useCustom<TrendingProductStats[]>({
    url: "sales/trending-products",
    method: "get",
    config: {
      query: {
        interval: statsInterval,
      },
    },
  });

  // Animation variants for scroll animations
  const fadeInUp = {
    initial: { opacity: 0, y: 60 },
    animate: { opacity: 1, y: 0, transition: { duration: 0.6 } },
  };

  // Parallax effect on scroll
  useEffect(() => {
    const handleScroll = () => {
      const scrollY = window.scrollY;
      const parallaxElements = document.querySelectorAll(".parallax");

      parallaxElements.forEach((element) => {
        const speed = element.getAttribute("data-speed") || "0.5";
        const yPos = -(scrollY * parseFloat(speed));
        element.setAttribute("style", `transform: translateY(${yPos}px)`);
      });
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  // Prepare stats data
  const formatStatsData = () => {
    if (!statsData)
      return {
        totalSales: 0,
        totalViews: 0,
        avgRating: 0,
        topProducts: 0,
      };

    try {
      const products = Array.isArray(statsData)
        ? statsData
        : (statsData as any)?.data || [];

      return {
        totalSales: products.reduce(
          (sum: number, p: TrendingProductStats) => sum + (p.totalSales || 0),
          0
        ),
        totalViews: products.reduce(
          (sum: number, p: TrendingProductStats) => sum + (p.totalViews || 0),
          0
        ),
        avgRating:
          products.reduce(
            (sum: number, p: TrendingProductStats) =>
              sum + (p.averageRating || 0),
            0
          ) / (products.length || 1),
        topProducts: products.length,
      };
    } catch (e) {
      console.error("Error processing stats data:", e);
      return {
        totalSales: 0,
        totalViews: 0,
        avgRating: 0,
        topProducts: 0,
      };
    }
  };

  const stats = formatStatsData();

  // Create a type-safe formatter function that returns ReactNode
  const formatter = (value: number | string) => {
    return <CountUp end={Number(value)} separator="," />;
  };

  return (
    <div className="min-h-screen overflow-hidden">
      {/* Colorful background with gradient */}
      <div
        className="fixed inset-0 z-[-1] animate-gradient-xy"
        style={{
          background:
            "linear-gradient(135deg, rgba(130,58,180,0.1) 0%, rgba(253,29,29,0.1) 50%, rgba(252,176,69,0.1) 100%)",
          backgroundSize: "300% 300%",
        }}
      />

      {/* Floating colored shapes */}
      <div className="fixed top-20 left-10 w-64 h-64 rounded-full bg-purple-500/10 blur-3xl animate-float z-[-1]" />
      <div className="fixed bottom-40 right-10 w-96 h-96 rounded-full bg-blue-500/10 blur-3xl animate-pulse-slow z-[-1]" />
      <div className="fixed top-1/2 left-1/3 w-80 h-80 rounded-full bg-pink-500/10 blur-3xl animate-float z-[-1]" />

      {/* Additional animated elements */}
      <div className="fixed bottom-20 left-1/4 w-40 h-40 rounded-full bg-green-500/10 blur-2xl animate-pulse z-[-1]" />
      <div className="fixed top-40 right-1/4 w-56 h-56 rounded-full bg-yellow-500/10 blur-2xl animate-float z-[-1]" />
      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {/* Featured section header with shimmer effect */}
        <motion.div
          className="text-center mb-12"
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          variants={fadeInUp}
        >
          <div className="inline-block px-4 py-1 rounded-full bg-gradient-to-r from-pink-500 via-purple-500 to-pink-500 bg-[length:200%_auto] animate-gradient-x text-white mb-4">
            <Text className="flex items-center text-white">
              <FireOutlined className="mr-2" /> Hot & Trending
            </Text>
          </div>
          <Title level={2} className="mb-1 relative">
            Discover Trending Blind Boxes
            <span className="absolute -bottom-2 left-1/2 transform -translate-x-1/2 w-24 h-1 bg-gradient-to-r from-pink-500 to-purple-500 rounded-full"></span>
          </Title>
          <Text className="text-gray-500 text-lg mt-4">
            Unbox the most popular mystery collectibles right now
          </Text>
        </motion.div>

        {/* Stats Cards */}
        <motion.div
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          variants={fadeInUp}
          className="mb-10"
        >
          <Row gutter={[16, 16]} className="mb-8">
            {statsLoading ? (
              <div className="w-full flex justify-center py-8">
                <Spin size="large" />
              </div>
            ) : statsError ? (
              <div className="w-full text-center py-8">
                <Text type="danger">Error loading statistics</Text>
              </div>
            ) : (
              <>
                <Col xs={12} md={6}>
                  <Card
                    className="h-full overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300"
                    style={{
                      borderTop: "4px solid #ff4d4f",
                      background:
                        "linear-gradient(135deg, rgba(255, 77, 79, 0.05) 0%, rgba(255, 255, 255, 0.8) 100%)",
                    }}
                  >
                    <Statistic
                      title={
                        <span className="text-gray-600 font-medium">
                          Total Sales
                        </span>
                      }
                      value={stats.totalSales}
                      formatter={formatter}
                      prefix={
                        <ShoppingOutlined className="text-red-500 mr-2" />
                      }
                      valueStyle={{ color: "#ff4d4f", fontWeight: "bold" }}
                    />
                    <Text className="text-xs text-gray-500 mt-2 block">
                      Across all trending products
                    </Text>
                  </Card>
                </Col>
                <Col xs={12} md={6}>
                  <Card
                    className="h-full overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300"
                    style={{
                      borderTop: "4px solid #1677ff",
                      background:
                        "linear-gradient(135deg, rgba(22, 119, 255, 0.05) 0%, rgba(255, 255, 255, 0.8) 100%)",
                    }}
                  >
                    <Statistic
                      title={
                        <span className="text-gray-600 font-medium">
                          Total Views
                        </span>
                      }
                      value={stats.totalViews}
                      formatter={formatter}
                      prefix={<EyeOutlined className="text-blue-500 mr-2" />}
                      valueStyle={{ color: "#1677ff", fontWeight: "bold" }}
                    />
                    <Text className="text-xs text-gray-500 mt-2 block">
                      Product impressions this {statsInterval.toLowerCase()}
                    </Text>
                  </Card>
                </Col>
                <Col xs={12} md={6}>
                  <Card
                    className="h-full overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300"
                    style={{
                      borderTop: "4px solid #faad14",
                      background:
                        "linear-gradient(135deg, rgba(250, 173, 20, 0.05) 0%, rgba(255, 255, 255, 0.8) 100%)",
                    }}
                  >
                    <Statistic
                      title={
                        <span className="text-gray-600 font-medium">
                          Average Rating
                        </span>
                      }
                      value={stats.avgRating.toFixed(1)}
                      prefix={<StarOutlined className="text-yellow-500 mr-2" />}
                      valueStyle={{ color: "#faad14", fontWeight: "bold" }}
                      precision={1}
                    />
                    <div className="flex mt-1">
                      {[...Array(5)].map((_, i) => (
                        <StarOutlined
                          key={i}
                          className={
                            i < Math.round(stats.avgRating)
                              ? "text-yellow-400"
                              : "text-gray-300"
                          }
                        />
                      ))}
                    </div>
                  </Card>
                </Col>
                <Col xs={12} md={6}>
                  <Card
                    className="h-full overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300"
                    style={{
                      borderTop: "4px solid #52c41a",
                      background:
                        "linear-gradient(135deg, rgba(82, 196, 26, 0.05) 0%, rgba(255, 255, 255, 0.8) 100%)",
                    }}
                  >
                    <Statistic
                      title={
                        <span className="text-gray-600 font-medium">
                          Top Products
                        </span>
                      }
                      value={stats.topProducts}
                      formatter={formatter}
                      prefix={<RiseOutlined className="text-green-500 mr-2" />}
                      valueStyle={{ color: "#52c41a", fontWeight: "bold" }}
                    />
                    <div className="flex justify-between items-center mt-2">
                      <Tooltip title="View all statistics">
                        <Button
                          type="link"
                          size="small"
                          onClick={() => go({ to: "/stats" })}
                          className="p-0"
                        >
                          View Details
                        </Button>
                      </Tooltip>
                      <div className="flex">
                        <Button
                          type="text"
                          size="small"
                          className={`px-2 ${
                            statsInterval === TrendingInterval.WEEK
                              ? "bg-green-50 text-green-600"
                              : ""
                          }`}
                          onClick={() =>
                            setStatsInterval(TrendingInterval.WEEK)
                          }
                        >
                          W
                        </Button>
                        <Button
                          type="text"
                          size="small"
                          className={`px-2 ${
                            statsInterval === TrendingInterval.MONTH
                              ? "bg-green-50 text-green-600"
                              : ""
                          }`}
                          onClick={() =>
                            setStatsInterval(TrendingInterval.MONTH)
                          }
                        >
                          M
                        </Button>
                        <Button
                          type="text"
                          size="small"
                          className={`px-2 ${
                            statsInterval === TrendingInterval.YEAR
                              ? "bg-green-50 text-green-600"
                              : ""
                          }`}
                          onClick={() =>
                            setStatsInterval(TrendingInterval.YEAR)
                          }
                        >
                          Y
                        </Button>
                      </div>
                    </div>
                  </Card>
                </Col>
              </>
            )}
          </Row>
        </motion.div>

        {/* Trending Products with hover effects */}
        <motion.div
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          variants={fadeInUp}
          className="mb-8"
          onMouseEnter={() => setHoverIndex(0)}
          onMouseLeave={() => setHoverIndex(null)}
          style={{
            boxShadow:
              hoverIndex === 0 ? "0 0 30px rgba(236, 72, 153, 0.3)" : "none",
            transition: "box-shadow 0.3s ease",
            borderRadius: "1rem",
          }}
        >
          <TrendingProducts />
        </motion.div>

        {/* View All Products section */}
        <motion.div
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          variants={fadeInUp}
          className="mb-16 text-center"
        >
          <Button
            type="primary"
            size="large"
            shape="round"
            className="bg-gradient-to-r from-purple-500 to-indigo-500 border-0 shadow-lg px-8"
            onClick={() => go({ to: "/products" })}
          >
            View All Products
          </Button>
        </motion.div>

        {/* Brand Showcase with enhanced animated border */}
        <motion.div
          className="relative p-1 rounded-3xl mb-16 overflow-hidden"
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          variants={fadeInUp}
        >
          <div className="absolute inset-0 bg-gradient-to-r from-pink-500 via-red-500 to-yellow-500 bg-[length:200%_auto] animate-gradient-x" />
          <div className="absolute inset-0 bg-[url('/public/pattern.svg')] opacity-20"></div>
          <div className="relative rounded-3xl bg-white/90 backdrop-blur-sm p-8">
            <div className="text-center mb-12">
              <div className="inline-block px-4 py-1 rounded-full bg-gradient-to-r from-green-500 via-emerald-500 to-green-500 bg-[length:200%_auto] animate-gradient-x text-white mb-4">
                <Text className="flex items-center text-white">
                  <GiftOutlined className="mr-2" /> Featured Brands
                </Text>
              </div>
              <Title level={2} className="mb-1 relative">
                Shop By Brand
                <span className="absolute -bottom-2 left-1/2 transform -translate-x-1/2 w-24 h-1 bg-gradient-to-r from-green-500 to-emerald-500 rounded-full"></span>
              </Title>
              <Text className="text-gray-600 text-lg mt-4">
                Discover collectibles from your favorite brands
              </Text>
            </div>
            <motion.div
              transition={{ type: "spring", stiffness: 400, damping: 10 }}
            >
              <BrandShowcase />
            </motion.div>
          </div>
        </motion.div>

        {/* Brand Showcase with enhanced animated border */}
        <motion.div
          className="relative p-1 rounded-3xl py-8 mb-16 overflow-hidden"
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          variants={fadeInUp}
        >
          <div className="absolute inset-0 bg-gradient-to-br from-blue-600/20 via-purple-600/20 to-indigo-600/20 bg-[length:200%_200%] animate-gradient-xy backdrop-blur-sm" />
          <div className="absolute -top-24 -right-24 w-96 h-96 rounded-full bg-yellow-400/20 blur-3xl animate-pulse-slow" />
          <div className="absolute -bottom-24 -left-24 w-96 h-96 rounded-full bg-pink-400/20 blur-3xl animate-pulse" />

          <div className="relative rounded-3xl  backdrop-blur-sm p-8">
            <div className="text-center mb-12">
              <div className="inline-block px-4 py-1 rounded-full bg-gradient-to-r from-blue-500 via-indigo-500 to-blue-500 bg-[length:200%_auto] animate-gradient-x text-white mb-4">
                <Text className="flex items-center text-white">
                  <CrownOutlined className="mr-2" /> Exclusive Series
                </Text>
              </div>
              <Title level={2} className="mb-1 relative">
                Explore Our Collections
                <span className="absolute -bottom-2 left-1/2 transform -translate-x-1/2 w-24 h-1 bg-gradient-to-r from-blue-500 to-indigo-500 rounded-full"></span>
              </Title>
              <Text className="text-gray-600 text-lg mt-4">
                Find your perfect series of collectibles
              </Text>
            </div>
            <Button
              type="link"
              className="block mx-auto mt-2 text-blue-500 hover:text-blue-600"
              onClick={() => go({ to: "/products" })}
            >
              Browse All Collections →
            </Button>
            <motion.div
              transition={{ type: "spring", stiffness: 400, damping: 10 }}
            >
              <ProductSeries />
            </motion.div>
          </div>
        </motion.div>

        {/* Call to Action with particle effect */}
        <motion.div
          className="text-center py-20 rounded-3xl relative overflow-hidden"
          initial="initial"
          whileInView="animate"
          viewport={{ once: true }}
          variants={fadeInUp}
        >
          <div className="absolute inset-0 bg-gradient-to-br from-purple-600/90 via-indigo-600/90 to-purple-600/90 bg-[length:200%_200%] animate-gradient-xy" />
          <div className="absolute inset-0">
            <div className="absolute top-0 left-0 w-full h-full bg-[url('/public/pattern.svg')] opacity-10" />
          </div>
          {/* Animated particles */}
          <div className="absolute inset-0 overflow-hidden">
            {[...Array(20)].map((_, i) => (
              <div
                key={i}
                className="absolute rounded-full bg-white/20"
                style={{
                  width: `${Math.random() * 10 + 5}px`,
                  height: `${Math.random() * 10 + 5}px`,
                  top: `${Math.random() * 100}%`,
                  left: `${Math.random() * 100}%`,
                  animation: `float ${
                    Math.random() * 6 + 4
                  }s ease-in-out infinite`,
                  animationDelay: `${Math.random() * 5}s`,
                }}
              />
            ))}
          </div>
          <div className="relative">
            <Title level={2} className="!text-white mb-4 text-shadow">
              Ready to Start Your Collection?
            </Title>
            <Text className="text-white/80 text-lg mb-8 block">
              Join thousands of collectors around the world
            </Text>
            <motion.div whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }}>
              <Button
                type="primary"
                size="large"
                shape="round"
                className="bg-gradient-to-r from-yellow-400 to-orange-500 border-0 hover:from-orange-500 hover:to-yellow-400 shadow-lg"
                onClick={() => go({ to: "/products" })}
              >
                Shop Now
              </Button>
            </motion.div>
          </div>
        </motion.div>
      </div>

      {/* Back to top button with enhanced styling */}
      <BackTop>
        <motion.div
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          className="flex items-center justify-center w-12 h-12 rounded-full bg-gradient-to-r from-pink-500 to-purple-500 text-white shadow-lg"
        >
          <ArrowUpOutlined />
        </motion.div>
      </BackTop>
    </div>
  );
}
