// src/components/products/show/loading-state.tsx
import React from "react";
import { Card, Row, Col, Skeleton } from "antd";

export const LoadingState: React.FC = () => (
  <Row gutter={[32, 32]}>
    <Col xs={24} md={12}>
      <Card className="shadow-sm">
        <Skeleton.Image className="w-full aspect-square" />
        <Row gutter={[8, 8]} className="mt-4">
          {Array(4)
            .fill(null)
            .map((_, index) => (
              <Col span={6} key={index}>
                <Skeleton.Image className="w-full aspect-square" />
              </Col>
            ))}
        </Row>
      </Card>
    </Col>
    <Col xs={24} md={12}>
      <Card className="shadow-sm">
        <Skeleton active paragraph={{ rows: 8 }} />
      </Card>
    </Col>
  </Row>
);
