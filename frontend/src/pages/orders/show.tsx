import React, { useState } from "react";
import { useShow, useTranslate, useMany } from "@refinedev/core";
import { Show, DateField, NumberField, List } from "@refinedev/antd";
import {
  Typography,
  Row,
  Col,
  Card,
  Button,
  Space,
  Modal,
  message,
  Descriptions,
  Spin,
  Divider,
  Tag,
  Timeline,
  Avatar,
  Tooltip,
} from "antd";
import api from "../../config/openapi-config";
import { OrderDto, OrderStatus } from "../../../generated";

const { Title, Text } = Typography;

// Define color mapping for order statuses
const getStatusColor = (status: OrderStatus | undefined) => {
  switch (status) {
    case "CREATED":
      return { color: "pink", backgroundColor: "#f0f0f0" };
    case "PREPARING":
      return { color: "orange", backgroundColor: "#ffe7ba" };
    case "READY_FOR_PICKUP":
      return { color: "cyan", backgroundColor: "#d9f7be" };
    case "SHIPPING":
      return { color: "#fcec03", backgroundColor: "#bae7ff" };
    case "DELIVERED":
      return { color: "green", backgroundColor: "#d3f261" };
    case "COMPLETED":
      return { color: "purple", backgroundColor: "#efdbff" };
    case "CANCELED":
      return { color: "red", backgroundColor: "#ffccc7" };
    case "PAYMENT_EXPIRED":
      return { color: "red", backgroundColor: "#ffccc7" };
    case "PAYMENT_FAILED":
      return { color: "red", backgroundColor: "#ffccc7" };
    case "RECEIVED":
      return { color: "green", backgroundColor: "#d3f261" };
    default:
      return { color: "default", backgroundColor: "#f0f0f0" };
  }
};

export const OrdersShow = () => {
  const translate = useTranslate();
  const { queryResult } = useShow<OrderDto>();
  const { data, isLoading } = queryResult;
  const record = data?.data;
  const [modalVisible, setModalVisible] = useState(false);
  const [actionType, setActionType] = useState("");
  const [actionSuccess, setActionSuccess] = useState(false);

  // Get appropriate action button based on order status
  const getStatusAction = () => {
    if (!record) return null;

    const status = record.latestStatus;

    if (status === "PREPARING") {
      return {
        text: "Mark as Ready for Pickup",
        nextStatus: "READY_FOR_PICKUP",
        color: "blue",
      };
    } else if (status === "READY_FOR_PICKUP") {
      return {
        text: "Mark as Picked Up",
        nextStatus: "PICKED_UP",
        color: "purple",
      };
    } else if (status === "SHIPPING") {
      return {
        text: "Mark as Delivered",
        nextStatus: "DELIVERED",
        color: "green",
      };
    }
    return null;
  };

  const statusAction = getStatusAction();

  // Handle status change
  const handleStatusChange = async () => {
    setActionSuccess(false);
    try {
      let response;
      switch (record?.latestStatus) {
        case "PREPARING":
          response = await api.pickUpOrder({ orderId: record?.orderId || -1 });
          break;
        case "READY_FOR_PICKUP":
          response = await api.shipOrder({ orderId: record?.orderId || -1 });
          break;
        case "SHIPPING":
          response = await api.deliverOrder({ orderId: record?.orderId || -1 });
          break;
      }

      if (response) {
        setActionSuccess(true);
        message.success(`Order status updated to ${statusAction?.nextStatus}`);
        queryResult.refetch();
      }
    } catch (error) {
      message.error("Failed to update order status");
    }

    setModalVisible(false);
  };

  // Show confirmation modal
  const showConfirmModal = (type: string) => {
    setActionType(type);
    setModalVisible(true);
  };

  const ConfirmationModal = () => {
    return (
      <Modal
        title="Confirm Status Change"
        open={modalVisible}
        onOk={handleStatusChange}
        onCancel={() => setModalVisible(false)}
        okText="Confirm"
        cancelText="Cancel"
        okButtonProps={{ loading: actionSuccess }}
      >
        <p>Are you sure you want to update this order to "{actionType}"?</p>
        <p>This action cannot be undone.</p>
      </Modal>
    );
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-64">
        <Spin size="large" tip="Loading order details..." />
      </div>
    );
  }

  const { color, backgroundColor } = getStatusColor(record?.latestStatus);

  // Check for discount property safely
  const hasDiscount =
    record &&
    typeof record === "object" &&
    "discount" in record &&
    typeof record.discount === "number" &&
    record.discount > 0;

  // Check for shipping fee property safely
  const hasShippingFee =
    record &&
    typeof record === "object" &&
    "shippingFee" in record &&
    typeof record.shippingFee === "number" &&
    record.shippingFee > 0;

  return (
    <Show
      isLoading={isLoading}
      title={<Title level={3}>Order #{record?.orderId}</Title>}
      headerButtons={
        statusAction ? (
          <Button
            type="primary"
            size="large"
            style={{ backgroundColor: statusAction.color }}
            onClick={() => showConfirmModal(statusAction.text)}
          >
            {statusAction.text}
          </Button>
        ) : (
          <></>
        )
      }
    >
      <ConfirmationModal />

      <Row gutter={[24, 24]}>
        <Col xs={24} lg={16}>
          <Card title="Order Information" bordered={false}>
            <Row gutter={[16, 16]}>
              <Col span={24}>
                <Tag
                  color={color}
                  style={{
                    padding: "6px 12px",
                    fontSize: "16px",
                    backgroundColor,
                  }}
                >
                  Status: {record?.latestStatus || "N/A"}
                </Tag>
              </Col>
            </Row>

            <Descriptions
              column={{ xs: 1, sm: 2 }}
              bordered
              style={{ marginTop: 16 }}
            >
              <Descriptions.Item label={translate("Order ID")} span={2}>
                #{record?.orderId || "N/A"}
              </Descriptions.Item>

              <Descriptions.Item label={translate("Customer")} span={2}>
                {record?.account ? (
                  <Text strong>
                    {record.account.firstName} {record.account.lastName}
                  </Text>
                ) : (
                  "N/A"
                )}
              </Descriptions.Item>

              <Descriptions.Item label={translate("Created At")} span={2}>
                <DateField
                  value={record?.createdAt}
                  format="MMMM D, YYYY h:mm A"
                />
              </Descriptions.Item>

              <Descriptions.Item label={translate("Updated At")} span={2}>
                <DateField
                  value={record?.updatedAt}
                  format="MMMM D, YYYY h:mm A"
                />
              </Descriptions.Item>
            </Descriptions>
          </Card>

          <Card
            title="Order History"
            bordered={false}
            style={{ marginTop: 24 }}
          >
            {record?.orderStatusHistories ? (
              <Timeline mode="left">
                {record?.orderStatusHistories.map((status, index) => (
                  <Timeline.Item
                    key={index}
                    color={getStatusColor(status.state).color}
                    label={
                      <DateField
                        value={status.createdAt}
                        format="MMM D, YYYY h:mm A"
                      />
                    }
                  >
                    <Text strong>{status.state}</Text>
                  </Timeline.Item>
                ))}
              </Timeline>
            ) : (
              <Text type="secondary">No history available</Text>
            )}
          </Card>
        </Col>

        <Col xs={24} lg={8}>
          <Card title="Financial Summary" bordered={false}>
            <Space direction="vertical" style={{ width: "100%" }}>
              <Row justify="space-between">
                <Col>
                  <Text>{translate("Sub Total")}</Text>
                </Col>
                <Col>
                  <NumberField
                    value={record?.subTotal || 0}
                    options={{ style: "currency", currency: "USD" }}
                  />
                </Col>
              </Row>

              {hasDiscount && (
                <Row justify="space-between">
                  <Col>
                    <Text>{translate("Discount")}</Text>
                  </Col>
                  <Col>
                    <NumberField
                      value={-(record as any).discount}
                      options={{ style: "currency", currency: "USD" }}
                      style={{ color: "#52c41a" }}
                    />
                  </Col>
                </Row>
              )}

              {hasShippingFee && (
                <Row justify="space-between">
                  <Col>
                    <Text>{translate("Shipping Fee")}</Text>
                  </Col>
                  <Col>
                    <NumberField
                      value={(record as any).shippingFee}
                      options={{ style: "currency", currency: "USD" }}
                    />
                  </Col>
                </Row>
              )}

              <Divider style={{ margin: "12px 0" }} />

              <Row justify="space-between">
                <Col>
                  <Text strong>{translate("Final Total")}</Text>
                </Col>
                <Col>
                  <NumberField
                    value={record?.finalTotal || 0}
                    options={{ style: "currency", currency: "USD" }}
                    style={{ fontWeight: "bold", fontSize: "18px" }}
                  />
                </Col>
              </Row>
            </Space>
          </Card>

          {record?.shippingInfo && (
            <Card
              title="Shipping Information"
              bordered={false}
              style={{ marginTop: "24px" }}
            >
              <Space direction="vertical" style={{ width: "100%" }}>
                <Text strong>{record.shippingInfo.name}</Text>

                {record.shippingInfo &&
                  typeof record.shippingInfo === "object" &&
                  "phone" in record.shippingInfo && (
                    <Text>Phone: {String(record.shippingInfo.phone)}</Text>
                  )}

                {record.shippingInfo.address && (
                  <Text>{record.shippingInfo.address}</Text>
                )}

                {record.shippingInfo &&
                  typeof record.shippingInfo === "object" &&
                  "city" in record.shippingInfo &&
                  "state" in record.shippingInfo && (
                    <Text>
                      {String(record.shippingInfo.city)},
                      {String(record.shippingInfo.state)}
                      {record.shippingInfo &&
                        "zipCode" in record.shippingInfo &&
                        ` ${String(record.shippingInfo.zipCode)}`}
                    </Text>
                  )}
              </Space>
            </Card>
          )}
        </Col>
      </Row>
    </Show>
  );
};
