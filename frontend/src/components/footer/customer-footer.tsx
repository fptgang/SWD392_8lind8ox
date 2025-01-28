import React from 'react';
import { Layout, Row, Col, Typography, Input, Button, Space, Divider, theme } from 'antd';
import { Link } from 'react-router';
import {
  FacebookOutlined,
  TwitterOutlined,
  InstagramOutlined,
  LinkedinOutlined,
  SendOutlined,
} from '@ant-design/icons';

const { Footer } = Layout;
const { Title, Text } = Typography;
const { useToken } = theme;

const CustomerFooter: React.FC = () => {
  const { token } = useToken();

  return (
    <Footer
      style={{
        backgroundColor: token.colorBgContainer,
        padding: `${token.paddingLG}px 0 ${token.paddingMD}px`,
        borderTop: `1px solid ${token.colorBorderSecondary}`
      }}
    >
      <div className="container mx-auto px-4">
        <Row gutter={[token.marginLG, token.marginLG]}>
          {/* Company Information */}
          <Col xs={24} sm={12} md={6}>
            <Title level={4} style={{ color: token.colorText, marginBottom: token.marginMD }}>
              8lind8ox
            </Title>
            <Text style={{ color: token.colorTextSecondary, display: 'block', marginBottom: token.marginSM }}>
              Your premier destination for collectible toys and blind boxes.
            </Text>
            <Space className="mt-4">
              <a href="https://facebook.com" style={{ color: token.colorTextSecondary, fontSize: token.fontSizeLG }}>
                <FacebookOutlined />
              </a>
              <a href="https://twitter.com" style={{ color: token.colorTextSecondary, fontSize: token.fontSizeLG }}>
                <TwitterOutlined />
              </a>
              <a href="https://instagram.com" style={{ color: token.colorTextSecondary, fontSize: token.fontSizeLG }}>
                <InstagramOutlined />
              </a>
              <a href="https://linkedin.com" style={{ color: token.colorTextSecondary, fontSize: token.fontSizeLG }}>
                <LinkedinOutlined />
              </a>
            </Space>
          </Col>

          {/* Quick Links */}
          <Col xs={24} sm={12} md={6}>
            <Title level={4} style={{ color: token.colorText, marginBottom: token.marginMD }}>
              Quick Links
            </Title>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
              <li style={{ marginBottom: token.marginXS }}>
                <Link to="/products" style={{ color: token.colorTextSecondary }}>
                  Products
                </Link>
              </li>
              <li style={{ marginBottom: token.marginXS }}>
                <Link to="/blind-boxes" style={{ color: token.colorTextSecondary }}>
                  Blind Boxes
                </Link>
              </li>
              <li style={{ marginBottom: token.marginXS }}>
                <Link to="/packs" style={{ color: token.colorTextSecondary }}>
                  Packs
                </Link>
              </li>
              <li style={{ marginBottom: token.marginXS }}>
                <Link to="/deals" style={{ color: token.colorTextSecondary }}>
                  Special Deals
                </Link>
              </li>
            </ul>
          </Col>

          {/* Customer Service */}
          <Col xs={24} sm={12} md={6}>
            <Title level={4} style={{ color: token.colorText, marginBottom: token.marginMD }}>
              Customer Service
            </Title>
            <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
              <li style={{ marginBottom: token.marginXS }}>
                <Link to="/contact" style={{ color: token.colorTextSecondary }}>
                  Contact Us
                </Link>
              </li>
              <li style={{ marginBottom: token.marginXS }}>
                <Link to="/faq" style={{ color: token.colorTextSecondary }}>
                  FAQ
                </Link>
              </li>
              <li style={{ marginBottom: token.marginXS }}>
                <Link to="/shipping" style={{ color: token.colorTextSecondary }}>
                  Shipping Information
                </Link>
              </li>
              <li style={{ marginBottom: token.marginXS }}>
                <Link to="/returns" style={{ color: token.colorTextSecondary }}>
                  Returns Policy
                </Link>
              </li>
            </ul>
          </Col>

          {/* Newsletter */}
          <Col xs={24} sm={12} md={6}>
            <Title level={4} style={{ color: token.colorText, marginBottom: token.marginMD }}>
              Newsletter
            </Title>
            <Text style={{ color: token.colorTextSecondary, display: 'block', marginBottom: token.marginSM }}>
              Subscribe to receive updates, access to exclusive deals, and more.
            </Text>
            <Space.Compact style={{ width: '100%' }}>
              <Input 
                placeholder="Enter your email"
                style={{ 
                  backgroundColor: token.colorBgElevated,
                  borderColor: token.colorBorder
                }}
              />
              <Button 
                type="primary" 
                icon={<SendOutlined />}
                style={{
                  backgroundColor: token.colorPrimary,
                  borderColor: token.colorPrimary
                }}
              >
                Subscribe
              </Button>
            </Space.Compact>
          </Col>
        </Row>

        <Divider style={{ borderColor: token.colorBorderSecondary }} />

        <Row justify="space-between" align="middle">
          <Col>
            <Text style={{ color: token.colorTextSecondary }}>
              © 2024 8lind8ox. All rights reserved.
            </Text>
          </Col>
          <Col>
            <Space split={<Divider type="vertical" style={{ borderColor: token.colorBorderSecondary }} />}>
              <Link to="/privacy" style={{ color: token.colorTextSecondary }}>
                Privacy Policy
              </Link>
              <Link to="/terms" style={{ color: token.colorTextSecondary }}>
                Terms of Service
              </Link>
            </Space>
          </Col>
        </Row>
      </div>
    </Footer>
  );
};

export default CustomerFooter;