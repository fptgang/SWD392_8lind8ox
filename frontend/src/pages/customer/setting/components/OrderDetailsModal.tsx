import React, { useState } from "react";
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
  Alert,
  Tag,
  Tooltip,
} from "antd";
import {
  CheckCircleOutlined,
  CloseCircleOutlined,
  PlayCircleOutlined,
  ShoppingOutlined,
  UploadOutlined,
} from "@ant-design/icons";
import { useMany, useTranslation } from "@refinedev/core";
import {
  OrderDto,
  OrderDetailDto,
  SlotDto,
  VideoDto,
} from "../../../../../generated";
import { formatCurrency } from "../../../../utils/currency-formatter";
import { OrderStatusBadge } from "./OrderStatusBadge";
import { OrderTimeline } from "./OrderTimeline";
import api from "../../../../config/openapi-config";
import { VideoUploadModal } from "./UploadVideoModal";

const { Text } = Typography;

interface OrderDetailsModalProps {
  order: OrderDto | null;
  onClose: () => void;
  refetch: () => void;
}

export const OrderDetailsModal: React.FC<OrderDetailsModalProps> = ({
  order,
  onClose,
  refetch,
}) => {
  const { translate } = useTranslation();
  const [uploadModalVisible, setUploadModalVisible] = useState(false);
  const [selectedSlot, setSelectedSlot] = useState<SlotDto | undefined>(
    undefined
  );

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
            refetch();
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
            refetch();
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

  const showUploadModal = (slot: SlotDto | undefined) => {
    setSelectedSlot(slot);
    setUploadModalVisible(true);
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

        {order.orderDetails?.find((detail) => detail.slot !== null) &&
          order.latestStatus === "RECEIVED" && (
            <Alert
              message={translate(
                "orders.details.slotAlert",
                "You can upload a video for slot to get voucher"
              )}
              type="warning"
              showIcon
            />
          )}

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
                  {detail?.slot && (
                    <Text type="secondary">
                      {translate("orders.fields.slot", "Slot")}:{" "}
                      {detail.slot?.position}
                    </Text>
                  )}
                </div>

                <div className="flex flex-col items-end">
                  {(detail.subTotal ?? 0) > (detail.finalTotal ?? 0) && (
                    <Text type="secondary" delete>
                      {formatCurrency(detail.subTotal ?? 0)}
                    </Text>
                  )}
                  <Text strong className="text-lg">
                    {formatCurrency(detail.finalTotal ?? 0)}
                  </Text>

                  {detail?.slot &&
                    order.latestStatus === "RECEIVED" &&
                    (detail?.slot?.video?.isVisible == true ? (
                      <div className="mt-2 text-center">
                        <Tooltip title="Watch video">
                          <Button
                            type="link"
                            icon={<PlayCircleOutlined />}
                            onClick={() => {
                              Modal.info({
                                title: "Video Preview",
                                content: (
                                  <div className="mt-2 w-full">
                                    <video
                                      src={detail.slot?.video?.url}
                                      controls
                                      style={{
                                        width: "100%",
                                      }}
                                      className="rounded"
                                      autoPlay
                                    />
                                  </div>
                                ),
                                width: 600,
                                closable: true,
                                maskClosable: true,
                                okText: "Close",
                                centered: true,
                              });
                            }}
                          >
                            Watch Video
                          </Button>
                        </Tooltip>
                        {detail.slot.video.isVerified ? (
                          <Tag color="success" icon={<CheckCircleOutlined />}>
                            Verified
                          </Tag>
                        ) : (
                          <Tag color="warning" icon={<CloseCircleOutlined />}>
                            Pending
                          </Tag>
                        )}
                      </div>
                    ) : (
                      <>
                        {detail.slot.video && (
                          <Text type="secondary" className="mt-2">
                            Your video has been rejected. Please upload a new
                            video.
                          </Text>
                        )}
                        <Button
                          type="primary"
                          icon={<UploadOutlined />}
                          size="small"
                          className="mt-2"
                          onClick={() => showUploadModal(detail?.slot)}
                        >
                          Upload Video
                        </Button>
                      </>
                    ))}
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

      <VideoUploadModal
        visible={uploadModalVisible}
        onCancel={() => setUploadModalVisible(false)}
        slot={selectedSlot}
        refetch={refetch}
      />
    </Modal>
  );
};
