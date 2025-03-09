import React, { useEffect, useState } from "react";
import NavBar from "./nav-bar";
import Hero from "./components/hero";
import BrandShowcase from "./components/brand-showcase";
import TrendingProducts from "./components/trending-products";
import ProductSeries from "./components/product-series";
import TrustedBy from "./components/trusted-by";
import { Button, Typography, BackTop } from "antd";
import { ArrowUpOutlined, GiftOutlined, FireOutlined, CrownOutlined } from "@ant-design/icons";
import { motion } from "framer-motion";
import { useGo } from "@refinedev/core";

const { Title, Text } = Typography;

export default function LandingPage() {
  const [hoverIndex, setHoverIndex] = useState<number | null>(null);
  const go = useGo();
  // Animation variants for scroll animations
  const fadeInUp = {
    initial: { opacity: 0, y: 60 },
    animate: { opacity: 1, y: 0, transition: { duration: 0.6 } }
  };

  // Parallax effect on scroll
  useEffect(() => {
    const handleScroll = () => {
      const scrollY = window.scrollY;
      const parallaxElements = document.querySelectorAll('.parallax');
      
      parallaxElements.forEach((element) => {
        const speed = element.getAttribute('data-speed') || '0.5';
        const yPos = -(scrollY * parseFloat(speed));
        element.setAttribute('style', `transform: translateY(${yPos}px)`);
      });
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <div className="min-h-screen overflow-hidden">
      {/* Colorful background with gradient */}
      <div 
        className="fixed inset-0 z-[-1] animate-gradient-xy" 
        style={{ 
          background: 'linear-gradient(135deg, rgba(130,58,180,0.1) 0%, rgba(253,29,29,0.1) 50%, rgba(252,176,69,0.1) 100%)',
          backgroundSize: '300% 300%',
        }}
      />
      
      {/* Floating colored shapes */}
      <div className="fixed top-20 left-10 w-64 h-64 rounded-full bg-purple-500/10 blur-3xl animate-float z-[-1]" />
      <div className="fixed bottom-40 right-10 w-96 h-96 rounded-full bg-blue-500/10 blur-3xl animate-pulse-slow z-[-1]" />
      <div className="fixed top-1/2 left-1/3 w-80 h-80 rounded-full bg-pink-500/10 blur-3xl animate-float z-[-1]" />
      
      {/* Additional animated elements */}
      <div className="fixed bottom-20 left-1/4 w-40 h-40 rounded-full bg-green-500/10 blur-2xl animate-pulse z-[-1]" />
      <div className="fixed top-40 right-1/4 w-56 h-56 rounded-full bg-yellow-500/10 blur-2xl animate-float z-[-1]" />


      {/* Hero Section with enhanced glow */}
      <div className="relative overflow-hidden">
        <div className="parallax" data-speed="0.2">
          <div className="absolute top-20 -left-10 w-40 h-40 rounded-full bg-yellow-300/30 blur-xl animate-pulse-slow" />
          <div className="absolute bottom-10 right-20 w-60 h-60 rounded-full bg-blue-400/20 blur-xl animate-pulse" />
          <div className="absolute top-40 left-1/2 w-32 h-32 rounded-full bg-pink-400/30 blur-xl animate-float" />
          <div className="absolute bottom-32 left-1/4 w-48 h-48 rounded-full bg-purple-400/20 blur-xl animate-pulse-slow" />
        </div>
      </div>

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
          <Text className="text-gray-500 text-lg mt-4">Unbox the most popular mystery collectibles right now</Text>
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
            boxShadow: hoverIndex === 0 ? '0 0 30px rgba(236, 72, 153, 0.3)' : 'none',
            transition: 'box-shadow 0.3s ease',
            borderRadius: '1rem',
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
            onClick={() => go({ to: '/products' })}
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
              <Text className="text-gray-600 text-lg mt-4">Discover collectibles from your favorite brands</Text>
            </div>
            <motion.div
              whileHover={{ scale: 1.02 }}
              transition={{ type: "spring", stiffness: 400, damping: 10 }}
            >
              <BrandShowcase />
            </motion.div>
          </div>
        </motion.div>

        {/* Product Series with enhanced colorful background */}
        <div className="relative py-16 mb-16 rounded-3xl overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-br from-blue-600/20 via-purple-600/20 to-indigo-600/20 bg-[length:200%_200%] animate-gradient-xy backdrop-blur-sm" />
          <div className="absolute -top-24 -right-24 w-96 h-96 rounded-full bg-yellow-400/20 blur-3xl animate-pulse-slow" />
          <div className="absolute -bottom-24 -left-24 w-96 h-96 rounded-full bg-pink-400/20 blur-3xl animate-pulse" />
          
          <motion.div 
            className="relative text-center mb-12"
            initial="initial"
            whileInView="animate"
            viewport={{ once: true }}
            variants={fadeInUp}
          >
            <div className="inline-block px-4 py-1 rounded-full bg-gradient-to-r from-blue-500 via-indigo-500 to-blue-500 bg-[length:200%_auto] animate-gradient-x text-white mb-4">
              <Text className="flex items-center text-white">
                <CrownOutlined className="mr-2" /> Exclusive Series
              </Text>
            </div>
            <Title level={2} className="mb-1 relative">
              Explore Our Collections
              <span className="absolute -bottom-2 left-1/2 transform -translate-x-1/2 w-24 h-1 bg-gradient-to-r from-blue-500 to-indigo-500 rounded-full"></span>
            </Title>
            <Text className="text-gray-600 text-lg mt-4">Find your perfect series of collectibles</Text>
            <Button 
              type="link" 
              className="block mx-auto mt-2 text-blue-500 hover:text-blue-600"
              onClick={() => go({ to: '/products' })}
            >
              Browse All Collections →
            </Button>
          </motion.div>

          <motion.div
            initial="initial"
            whileInView="animate"
            viewport={{ once: true }}
            variants={fadeInUp}
            onMouseEnter={() => setHoverIndex(1)}
            onMouseLeave={() => setHoverIndex(null)}
            style={{ 
              boxShadow: hoverIndex === 1 ? '0 0 30px rgba(59, 130, 246, 0.3)' : 'none',
              transition: 'box-shadow 0.3s ease',
              borderRadius: '0.75rem',
            }}
          >
            <ProductSeries />
          </motion.div>
        </div>

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
                  animation: `float ${Math.random() * 6 + 4}s ease-in-out infinite`,
                  animationDelay: `${Math.random() * 5}s`
                }}
              />
            ))}
          </div>
          <div className="relative">
            <Title level={2} className="text-white mb-4 text-shadow">Ready to Start Your Collection?</Title>
            <Text className="text-white/80 text-lg mb-8 block">Join thousands of collectors around the world</Text>
            <motion.div whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }}>
              <Button 
                type="primary" 
                size="large" 
                shape="round" 
                className="bg-gradient-to-r from-yellow-400 to-orange-500 border-0 hover:from-orange-500 hover:to-yellow-400 shadow-lg"
                onClick={() => go({ to: '/products' })}
              >
                Shop Now
              </Button>
            </motion.div>
          </div>
        </motion.div>
      </div>

      {/* Footer with gradient */}
      <div className="bg-gradient-to-r from-gray-900 via-gray-800 to-gray-900 text-white py-12 mt-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
              <Title level={4} style={{ color: 'white' }} className="mb-4">
                <span className="bg-clip-text text-transparent bg-gradient-to-r from-pink-400 to-purple-400">
                  Blind Box
                </span>
              </Title>
              <Text className="text-gray-400 block mb-6">Discover the joy of mystery collectibles</Text>
            </div>
            <div>
              <Title level={5} style={{ color: 'white' }} className="mb-4">
                <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-cyan-400">
                  Shop
                </span>
              </Title>
              <ul className="space-y-2 text-gray-400">
                <li className="hover:text-blue-400 transition-colors duration-200 cursor-pointer">New Arrivals</li>
                <li className="hover:text-blue-400 transition-colors duration-200 cursor-pointer">Best Sellers</li>
                <li className="hover:text-blue-400 transition-colors duration-200 cursor-pointer">Collections</li>
                <li className="hover:text-blue-400 transition-colors duration-200 cursor-pointer">Limited Editions</li>
              </ul>
            </div>
            <div>
              <Title level={5} style={{ color: 'white' }} className="mb-4">
                <span className="bg-clip-text text-transparent bg-gradient-to-r from-green-400 to-emerald-400">
                  Help
                </span>
              </Title>
              <ul className="space-y-2 text-gray-400">
                <li className="hover:text-green-400 transition-colors duration-200 cursor-pointer">FAQs</li>
                <li className="hover:text-green-400 transition-colors duration-200 cursor-pointer">Shipping</li>
                <li className="hover:text-green-400 transition-colors duration-200 cursor-pointer">Returns</li>
                <li className="hover:text-green-400 transition-colors duration-200 cursor-pointer">Contact Us</li>
              </ul>
            </div>
            <div>
              <Title level={5} style={{ color: 'white' }} className="mb-4">
                <span className="bg-clip-text text-transparent bg-gradient-to-r from-orange-400 to-yellow-400">
                  Connect
                </span>
              </Title>
              <ul className="space-y-2 text-gray-400">
                <li className="hover:text-orange-400 transition-colors duration-200 cursor-pointer">Instagram</li>
                <li className="hover:text-orange-400 transition-colors duration-200 cursor-pointer">Twitter</li>
                <li className="hover:text-orange-400 transition-colors duration-200 cursor-pointer">Facebook</li>
                <li className="hover:text-orange-400 transition-colors duration-200 cursor-pointer">Discord</li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-700 mt-12 pt-8 text-center text-gray-500">
            <Text>© 2023 Blind Box. All rights reserved.</Text>
          </div>
        </div>
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
