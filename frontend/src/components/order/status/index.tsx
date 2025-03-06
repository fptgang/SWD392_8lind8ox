import {
  CarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  GiftOutlined,
  ShoppingOutlined,
  StopOutlined
} from "@ant-design/icons";
import {useTranslate} from "@refinedev/core";
import {Tag} from "antd";
import {OrderStatusHistoryDtoStateEnum} from "../../../../generated";

type OrderStatusProps = {
  status: OrderStatusHistoryDtoStateEnum;
};

export const OrderStatus: React.FC<OrderStatusProps> = ({status}) => {
  const t = useTranslate();

  const statusConfig = {
    [OrderStatusHistoryDtoStateEnum.Created]: {
      color: "processing",
      icon: <ClockCircleOutlined/>
    },
    [OrderStatusHistoryDtoStateEnum.CourierAccepted]: {
      color: "cyan",
      icon: <ShoppingOutlined/>
    },
    [OrderStatusHistoryDtoStateEnum.Shipping]: {
      color: "blue",
      icon: <CarOutlined/>
    },
    [OrderStatusHistoryDtoStateEnum.Delivered]: {
      color: "geekblue",
      icon: <GiftOutlined/>
    },
    [OrderStatusHistoryDtoStateEnum.Received]: {
      color: "purple",
      icon: <CheckCircleOutlined/>
    },
    [OrderStatusHistoryDtoStateEnum.Completed]: {
      color: "success",
      icon: <CheckCircleOutlined/>
    },
    [OrderStatusHistoryDtoStateEnum.Canceled]: {
      color: "error",
      icon: <StopOutlined/>
    }
  };

  const {color, icon} = statusConfig[status];

  return (
    <Tag color={color} icon={icon}>
      {t(`orders.status.${status.toLowerCase()}`)}
    </Tag>
  );
};