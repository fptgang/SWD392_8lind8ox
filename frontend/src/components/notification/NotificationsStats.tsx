import React from "react";
import { Card, Statistic, Divider, Progress, Typography } from "antd";
import { BellOutlined, CheckCircleOutlined } from "@ant-design/icons";

const { Text } = Typography;

interface NotificationStatsProps {
  total: number;
  unread: number;
}

const NotificationStats: React.FC<NotificationStatsProps> = ({
  total,
  unread,
}) => {
  // Calculate read percentage
  const readPercentage =
    total > 0 ? Math.round(((total - unread) / total) * 100) : 0;

  return (
    <Card bordered={false}>
      <Statistic
        title="Total Notifications"
        value={total}
        prefix={<BellOutlined />}
      />

      <Divider />

      <Statistic
        title="Unread Notifications"
        value={unread}
        valueStyle={{ color: "#1890ff" }}
      />

      <Divider />

      <div>
        <div className="flex justify-between mb-2">
          <Text strong>Read Status</Text>
          <Text>{readPercentage}% read</Text>
        </div>
        <Progress percent={readPercentage} size="small" />
      </div>

      <Divider />

      <div className="text-center text-gray-500 text-sm">
        <CheckCircleOutlined className="mr-1" />
        <span>
          {unread === 0
            ? "You're all caught up!"
            : `You have ${unread} unread notification${
                unread !== 1 ? "s" : ""
              }`}
        </span>
      </div>
    </Card>
  );
};

export default NotificationStats;
