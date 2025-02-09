import {
  BellOutlined,
  CarFilled,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
} from "@ant-design/icons";
import { useTranslate } from "@refinedev/core";
import { Tag } from "antd";
import { OrderDtoStatusEnum } from "../../../../generated";

type OrderStatusProps = {
  status: OrderDtoStatusEnum;
};

export const OrderStatus: React.FC<OrderStatusProps> = ({ status }) => {
  const t = useTranslate();
  let color;
  let icon;

  switch (status) {
    case OrderDtoStatusEnum.Pending:
      color = "orange";
      icon = <ClockCircleOutlined />;
      break;
 
    case OrderDtoStatusEnum.Completed:
      color = "green";
      icon = <CheckCircleOutlined />;
      break;
    case OrderDtoStatusEnum.Canceled:
      color = "red";
      icon = <CloseCircleOutlined />;
      break;
  }

  return (
    <Tag color={color} icon={icon}>
      {t(`enum.orderStatuses.${status}`)}
    </Tag>
  );
};
