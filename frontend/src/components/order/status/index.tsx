import { 
  ClockCircleOutlined,
  CarOutlined,
  ShoppingOutlined,
  CheckCircleOutlined,
  GiftOutlined
} from "@ant-design/icons";
import { useTranslate } from "@refinedev/core";
import { Tag } from "antd";

export enum OrderStatusEnum {
  CREATED = "CREATED",
  COURIER_ACCEPTED = "COURIER_ACCEPTED", 
  SHIPPING = "SHIPPING",
  DELIVERED = "DELIVERED",
  RECEIVED = "RECEIVED",
  COMPLETED = "COMPLETED"
}

type OrderStatusProps = {
  status: OrderStatusEnum;
};

export const OrderStatus: React.FC<OrderStatusProps> = ({ status }) => {
  const t = useTranslate();

  const statusConfig = {
    [OrderStatusEnum.CREATED]: {
      color: "processing",
      icon: <ClockCircleOutlined />
    },
    [OrderStatusEnum.COURIER_ACCEPTED]: {
      color: "cyan",
      icon: <ShoppingOutlined />
    },
    [OrderStatusEnum.SHIPPING]: {
      color: "blue",
      icon: <CarOutlined />
    },
    [OrderStatusEnum.DELIVERED]: {
      color: "geekblue",
      icon: <GiftOutlined />
    },
    [OrderStatusEnum.RECEIVED]: {
      color: "purple", 
      icon: <CheckCircleOutlined />
    },
    [OrderStatusEnum.COMPLETED]: {
      color: "success",
      icon: <CheckCircleOutlined />
    }
  };

  const { color, icon } = statusConfig[status];

  return (
    <Tag color={color} icon={icon}>
      {t(`orders.status.${status.toLowerCase()}`)}
    </Tag>
  );
};