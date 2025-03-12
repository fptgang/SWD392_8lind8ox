import {
  CarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  GiftOutlined,
  ShoppingOutlined,
  StopOutlined,
} from "@ant-design/icons";
import { useTranslate } from "@refinedev/core";
import { Tag } from "antd";
import { OrderStatus } from "../../../../generated";

type OrderStatusProps = {
  status: OrderStatus;
};

export const OrderHistoryStatus: React.FC<OrderStatusProps> = ({ status }) => {
  const t = useTranslate();

  const statusConfig = {
    [OrderStatus.Created]: {
      color: "processing",
      icon: <ClockCircleOutlined />,
    },
    [OrderStatus.Preparing]: {
      color: "cyan",
      icon: <ShoppingOutlined />,
    },
    [OrderStatus.PaymentFailed]: {
      color: "error",
      icon: <StopOutlined />,
    },
    [OrderStatus.PaymentExpired]: {
      color: "warning",
      icon: <ClockCircleOutlined />,
    },
    [OrderStatus.Canceled]: {
      color: "error",
      icon: <StopOutlined />,
    },
    [OrderStatus.ReadyForPickup]: {
      color: "lime",
      icon: <GiftOutlined />,
    },
    [OrderStatus.Shipping]: {
      color: "blue",
      icon: <CarOutlined />,
    },
    [OrderStatus.Delivered]: {
      color: "geekblue",
      icon: <GiftOutlined />,
    },
    [OrderStatus.Received]: {
      color: "purple",
      icon: <CheckCircleOutlined />,
    },
    [OrderStatus.Completed]: {
      color: "success",
      icon: <CheckCircleOutlined />,
    },
  };

  const { color, icon } = statusConfig[status];

  return (
    <Tag color={color} icon={icon}>
      {t(`orders.status.${status.toLowerCase()}`)}
    </Tag>
  );
};
