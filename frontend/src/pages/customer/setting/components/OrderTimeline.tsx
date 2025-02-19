import React from "react";
import { Timeline, Typography } from "antd";
import { BoxPlotOutlined } from "@ant-design/icons";
import { OrderStatusHistoryDto } from "../../../../../generated";

const { Text } = Typography;

interface OrderTimelineProps {
  histories: OrderStatusHistoryDto[];
}

export const OrderTimeline: React.FC<OrderTimelineProps> = ({
  histories = [],
}) => {
  const getTimelineItems = () => {
    const sortedHistories = [...histories].sort(
      (a, b) =>
        new Date(a.createdAt ?? "").getTime() -
        new Date(b.createdAt ?? "").getTime()
    );

    return sortedHistories.map((history) => ({
      children: (
        <div>
          <Text strong>{history.state}</Text>
          <br />
          <Text type="secondary">
            {new Date(history.createdAt ?? "").toLocaleString()}
          </Text>
        </div>
      ),
      dot: <BoxPlotOutlined className="text-primary" />,
    }));
  };

  return <Timeline items={getTimelineItems()} />;
};
