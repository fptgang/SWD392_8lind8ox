import React from "react";
import {
  Modal,
  Space,
  Descriptions,
  Divider,
  Card,
  Typography,
  Button,
  Avatar,
  notification,
} from "antd";
import { ShoppingOutlined } from "@ant-design/icons";
import { useDelete, useTranslation, useUpdate } from "@refinedev/core";
import { OrderDto, OrderDetailDto } from "../../../../../generated";
import { formatCurrency } from "../../../../utils/currency-formatter";
import { OrderStatusBadge } from "./OrderStatusBadge";
import { OrderTimeline } from "./OrderTimeline";
import api from "../../../../config/openapi-config";
import { error } from "console";

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

  const handleCancel = async () => {
    try {
      api
        .cancelOrder({
          orderId: order.orderId || -1,
        })
        .then((response) => {
          if (response != null) {
            notification.success({
              message: "Order Canceled",
              description: "Order has been canceled successfully.",
            });
            onClose();
          }
        })
        .catch((error) => {
          notification.error({
            message: "Order Canceled",
            description: error,
          });
          onClose();
        });
    } catch (error) {
      console.error("Error canceling order:", error);
    }
  };

  const confirmReceive = async () => {
    try {
      api
        .receiveOrder({
          orderId: order.orderId || -1,
        })
        .then((response) => {
          if (response != null) {
            notification.success({
              message: "Order Received",
              description: "Order has been received successfully.",
            });
            onClose();
          }
        })
        .catch((error) => {
          notification.error({
            message: "Order Received",
            description: error,
          });
          onClose();
        });
    } catch (error) {
      console.error("Error confirming receive:", error);
    }
  };
  const actionButton = () => {
    switch (order.latestStatus) {
      case "CREATED":
        return (
          <Button type="primary" danger onClick={handleCancel}>
            {translate("orders.actions.cancel", "Cancel Order")}
          </Button>
        );
      case "DELIVERED":
        return (
          <Button type="primary" onClick={confirmReceive}>
            {translate("orders.actions.confirmReceive", "Confirm Receive")}
          </Button>
        );
      default:
        return null;
    }
  };

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
            <OrderStatusBadge histories={order.orderStatusHistories || []} />
          </Descriptions.Item>
          <Descriptions.Item
            label={translate("orders.fields.orderDate", "Order Date")}
          >
            {new Date(order.createdAt ?? "").toLocaleString()}
          </Descriptions.Item>
          <Descriptions.Item
            label={translate("orders.fields.total", "Total Amount")}
          >
            {formatCurrency(order.finalTotal || 0)}
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
                  <Avatar src={detail.sku?.image?.imageUrl} className="m-2" />
                  <Text strong>
                    {detail?.slot
                      ? detail.sku?.name + " : slot#" + detail.slot?.position
                      : detail.sku?.name + " * " + detail.quantity}
                  </Text>

                  <br />
                  <Text type="secondary">
                    {translate("orders.fields.subTotal", "Unit Price")}:{" "}
                    {formatCurrency(detail.unitPrice ?? 0)}
                  </Text>
                </div>

                <div>
                  {(detail.subTotal ?? 0) > (detail.finalTotal ?? 0) && (
                    <Text type="secondary" delete>
                      {formatCurrency(detail.subTotal ?? 0)}
                    </Text>
                  )}
                  <Text strong className="text-lg">
                    {formatCurrency(detail.finalTotal ?? 0)}
                  </Text>
                </div>
              </div>
            </Card>
          ))}
        </div>

        <Divider orientation="left">
          {translate("orders.details.timeline", "Order Timeline")}
        </Divider>

        <OrderTimeline histories={order.orderStatusHistories || []} />
      </div>
      {actionButton()}
    </Modal>
  );
};
