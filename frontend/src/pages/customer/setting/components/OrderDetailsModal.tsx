import React from "react";
import { Modal, Space, Descriptions, Divider, Card, Typography } from "antd";
import { ShoppingOutlined } from "@ant-design/icons";
import { useTranslation } from "@refinedev/core";
import { OrderDto, OrderDetailDto } from "../../../../../generated";
import { formatCurrency } from "../../../../utils/currency-formatter";
import { OrderStatusBadge } from "./OrderStatusBadge";
import { OrderTimeline } from "./OrderTimeline";

const { Text } = Typography;

interface OrderDetailsModalProps {
  order: OrderDto | null;
  onClose: () => void;
}

export const OrderDetailsModal: React.FC<OrderDetailsModalProps> = ({
  order,
  onClose,
}) => {
  const { translate } = useTranslation();

  if (!order) return null;

  return (
    <Modal
      open={!!order}
      onCancel={onClose}
      footer={null}
      title={
        <Space>
          <ShoppingOutlined className="text-primary" />
          <span>
            {translate("orders.details.title", "Order Details")} #
            {order.orderId}
          </span>
        </Space>
      }
      width={800}
      centered
    >
      <div className="space-y-6">
        <Descriptions bordered column={2}>
          <Descriptions.Item
            label={translate("orders.fields.status", "Order Status")}
            span={2}
          >
            <OrderStatusBadge histories={order.orderStatusHistories} />
          </Descriptions.Item>
          <Descriptions.Item
            label={translate("orders.fields.orderDate", "Order Date")}
          >
            {new Date(order.createdAt ?? "").toLocaleString()}
          </Descriptions.Item>
          <Descriptions.Item
            label={translate("orders.fields.total", "Total Amount")}
          >
            {formatCurrency(order.totalPrice || 0)}
          </Descriptions.Item>
        </Descriptions>

        <Divider orientation="left">
          {translate("orders.details.items", "Order Items")}
        </Divider>

        <div className="space-y-4">
          {order.orderDetails?.map((detail: OrderDetailDto) => (
            <Card key={detail.orderDetailId} size="small" className="shadow-sm">
              <div className="flex justify-between items-center">
                <div>
                  <Text strong>
                    {translate("orders.fields.skuId", "SKU ID")}: {detail.skuId}
                  </Text>
                  <br />
                  <Text type="secondary">
                    {translate("orders.fields.originalPrice", "Original Price")}
                    : {formatCurrency(detail.originalPrice ?? 0)}
                  </Text>
                </div>
                <Text strong className="text-lg">
                  {formatCurrency(detail.checkoutPrice ?? 0)}
                </Text>
              </div>
            </Card>
          ))}
        </div>

        <Divider orientation="left">
          {translate("orders.details.timeline", "Order Timeline")}
        </Divider>

        <OrderTimeline histories={order.orderStatusHistories} />
      </div>
    </Modal>
  );
};
