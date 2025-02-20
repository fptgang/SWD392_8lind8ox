import React from "react";
import { Badge, Space } from "antd";
import {
  ClockCircleOutlined,
  CheckCircleOutlined,
  InfoCircleOutlined,
} from "@ant-design/icons";
import { useTranslation } from "@refinedev/core";
import { OrderStatusHistoryDto } from "../../../../../generated";

interface OrderStatusBadgeProps {
  histories: OrderStatusHistoryDto[];
}

export const OrderStatusBadge: React.FC<OrderStatusBadgeProps> = ({
  histories = [],
}) => {
  const { translate } = useTranslation();

  const getLatestStatus = (): string => {
    if (!histories || histories.length === 0) return "PENDING";

    const sortedHistories = [...histories].sort(
      (a, b) =>
        new Date(b.createdAt ?? "").getTime() -
        new Date(a.createdAt ?? "").getTime()
    );

    return sortedHistories[0].state ?? "PENDING";
  };

  const status = getLatestStatus();

  const statusMap: Record<
    string,
    { color: string; text: string; icon: React.ReactNode }
  > = {
    CREATED: {
      color: "processing",
      text: translate("orders.statuses.created", "Created"),
      icon: <ClockCircleOutlined className="text-blue-500" />,
    },
    COURIER_ACCEPTED: {
      color: "processing",
      text: translate("orders.statuses.courierAccepted", "Courier Accepted"),
      icon: <ClockCircleOutlined className="text-blue-500" />,
    },
    SHIPPING: {
      color: "processing",
      text: translate("orders.statuses.shipping", "Shipping"),
      icon: <ClockCircleOutlined className="text-blue-500" />,
    },
    DELIVERED: {
      color: "success",
      text: translate("orders.statuses.delivered", "Delivered"),
      icon: <CheckCircleOutlined className="text-green-500" />,
    },
    RECEIVED: {
      color: "success",
      text: translate("orders.statuses.received", "Received"),
      icon: <CheckCircleOutlined className="text-green-500" />,
    },
    COMPLETED: {
      color: "success",
      text: translate("orders.statuses.completed", "Completed"),
      icon: <CheckCircleOutlined className="text-green-500" />,
    },
  };

  const { color, text, icon } = statusMap[status] || {
    color: "default",
    text: status,
    icon: <InfoCircleOutlined />,
  };

  return (
    <Space>
      {icon}
      <Badge status={color as any} text={text} />
    </Space>
  );
};
