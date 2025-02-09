import React from 'react';
import { useOne } from '@refinedev/core';
import { useParams } from 'react-router';
import { Card, Col, Row, Typography, Space, Button, Tag, Image, Descriptions, message } from 'antd';
import { ShoppingOutlined } from '@ant-design/icons';
import { BlindBoxDto, BrandDto } from '../../../../generated';
import { useCart } from '../../../hooks/useCart';

const { Title, Text } = Typography;

function CustomerProductShow() {
  const { id } = useParams();
  const { addItem } = useCart();

  const { data, isLoading } = useOne<BlindBoxDto>({
    resource: 'blind-boxes',
    id: id || '',
  });

  const { data: brandData, isLoading: isBrandLoading } = useOne<BrandDto>({
    resource: 'brands',
    id: data?.data?.brandId || '',
  });

  const product = data?.data;
  const brand = brandData?.data;

  const handleAddToCart = () => {
    if (product) {
      addItem({
        id: String(product.blindBoxId || ''),
        name: product.name || '',
        price: product.currentPrice || 0,
        image: typeof product.images?.[0] === 'string' 
          ? product.images[0] 
          : '/placeholder-image.jpg',
      });

      message.success('Product added to cart');
    }
  };

  if (isLoading || isBrandLoading) {
    return <div>Loading...</div>;
  }

  if (!product) {
    return <div>Product not found</div>;
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <Row gutter={[32, 32]}>
        <Col xs={24} md={12}>
          <Card>
            <Image.PreviewGroup>
              <div className="grid grid-cols-1 gap-4">
                <Image
                  src={'https://bizweb.dktcdn.net/thumb/large/100/515/274/products/2-bf348bcc-6374-40e0-ab17-626ccb87b1b1.jpg'}
                  alt={product.name}
                  className="w-full rounded-lg"
                />
                <Row gutter={[8, 8]}>
                  {product.images?.slice(1).map((image, index) => (
                    <Col span={6} key={index}>
                      <Image
                        src={'https://bizweb.dktcdn.net/thumb/large/100/515/274/products/2-bf348bcc-6374-40e0-ab17-626ccb87b1b1.jpg'}
                        alt={`${product.name} ${index + 2}`}
                        className="w-full h-24 object-cover rounded-lg"
                      />
                    </Col>
                  ))}
                </Row>
              </div>
            </Image.PreviewGroup>
          </Card>
        </Col>

        <Col xs={24} md={12}>
          <Card>
            <Space direction="vertical" size="large" className="w-full">
              <div>
                <Title level={3}>{product.name}</Title>
                {brand.name && (
                  <Text type="secondary">Brand: {brand.name}</Text>
                )}
              </div>

              <div className="flex items-baseline gap-4">
                <Title level={2} className="text-red-500 m-0">
                  ${product.currentPrice}
                </Title>
                              </div>

              <Descriptions column={1}>
                <Descriptions.Item label="Status">
                  <Tag color={product.isVisible ? 'green' : 'red'}>
                    {product.isVisible ? 'In Stock' : 'Out of Stock'}
                  </Tag>
                </Descriptions.Item>
                {/* TODO: Add description and Rating */}
                <Descriptions.Item label="Sold">{69}</Descriptions.Item>
                <Descriptions.Item label="Rating">{product.rating || 4.5} ★</Descriptions.Item>
              </Descriptions>

              <div className="flex gap-4">
                <Button
                  type="primary"
                  size="large"
                  icon={<ShoppingOutlined />}
                  onClick={handleAddToCart}
                  block
                >
                  Add to Cart
                </Button>
              </div>

              <Card title="Product Description" bordered={false}>
                <Text>{product.description}</Text>
              </Card>
            </Space>
          </Card>
        </Col>
      </Row>
    </div>
  );
}

export default CustomerProductShow;