import React from "react";
import {
  Popover,
  Badge,
  Button,
  Typography,
  Divider,
  Empty,
  Tag,
  List,
  Space,
  notification,
} from "antd";
import {
  NotificationOutlined,
  ClockCircleOutlined,
  DeleteOutlined,
  CheckCircleOutlined,
  ArrowRightOutlined,
  BellOutlined,
} from "@ant-design/icons";
import { Link } from "react-router";
import { motion, AnimatePresence } from "framer-motion";
import { formatDistanceToNow } from "date-fns";
import { NotificationDto } from "../../../../generated";
import { useList, useSubscription } from "@refinedev/core";
import { parseJwt } from "../../../utils/parse-jwt";

const { Text, Title } = Typography;

interface NotificationItemProps {
  noti: NotificationDto;
}

const NotificationItem: React.FC<NotificationItemProps> = ({ noti }) => {
  const handleMarkAsRead = () => {
    try {
      if (noti.notificationId) {
      }
    } catch (error) {
      notification.error({
        message: "Error updating notification",
        description:
          error instanceof Error ? error.message : "An unknown error occurred",
      });
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: -10 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -10 }}
      className="py-3 border-b border-gray-100"
    >
      <div className="flex items-start gap-3">
        <div className="flex-1 min-w-0" onClick={handleMarkAsRead}>
          <div className="flex items-center gap-2">
            {!noti.isRead && <Badge dot status="processing" color="blue" />}
            <Text strong={!noti.isRead} className="block truncate">
              {noti.message}
            </Text>
          </div>
          <Space className="mt-1" size="small">
            <ClockCircleOutlined className="text-gray-400" />
            <Text type="secondary" className="text-xs">
              {noti.createdAt &&
                formatDistanceToNow(new Date(noti.createdAt), {
                  addSuffix: true,
                })}
            </Text>
          </Space>
        </div>
      </div>
    </motion.div>
  );
};

interface NotificationSummaryProps {
  totalCount: number;
}

const NotificationSummary: React.FC<NotificationSummaryProps> = ({
  totalCount,
}) => (
  <div className="p-4 rounded-lg">
    <div className="flex justify-between mb-4">
      <Text strong>Total Notifications</Text>
      <Tag>{totalCount}</Tag>
    </div>

    <Divider className="my-2" />

    <div className="flex justify-between gap-2">
      <Link to="/notifications">
        <Button type="default" block icon={<ArrowRightOutlined />}>
          View All
        </Button>
      </Link>
    </div>
  </div>
);

export const NotificationPopover: React.FC = () => {
  // These would typically come from a notifications context/hook

  const [pageSize, setPageSize] = React.useState(10);

  const jwtPayload = parseJwt(localStorage.getItem("refine-auth") ?? "");
  const email = jwtPayload?.email || jwtPayload?.sub || "";

  const { data, isLoading, isError, refetch } = useList<NotificationDto>({
    resource: "notifications",
    pagination: {
      pageSize,
    },
  });

  useSubscription({
    channel: email ? `noti/${email}` : "",
    onLiveEvent: (event) => {
      console.log("New notification", event);
      refetch();
    },
  });

  const notifications = data?.data ?? [];
  const total = data?.total ?? 0;

  const notificationContent = (
    <div className="w-[380px] max-h-[550px]">
      <div className="px-4 py-3 border-b">
        <Space className="w-full justify-between">
          <Title level={5} className="m-0">
            Notifications
          </Title>
        </Space>
      </div>

      <div
        className="max-h-[320px] overflow-y-auto px-4"
        onScroll={(e) => {
          const target = e.target as HTMLDivElement;
          if (target.scrollHeight - target.scrollTop === target.clientHeight) {
            setPageSize((prev) => prev + 10);
          }
        }}
      >
        {/* <AnimatePresence> */}
        {notifications.length === 0 ? (
          <Empty
            image={Empty.PRESENTED_IMAGE_SIMPLE}
            description="No notifications"
            className="py-8"
          />
        ) : (
          notifications.map((notification) => (
            <NotificationItem
              key={notification.notificationId}
              noti={notification}
            />
          ))
        )}
        {/* </AnimatePresence> */}
      </div>

      {notifications.length > 0 && (
        <>
          <Divider className="my-2" />
          <div className="px-4">
            <NotificationSummary totalCount={total} />
          </div>
        </>
      )}
    </div>
  );

  return (
    <Popover
      placement="bottomRight"
      trigger="click"
      content={notificationContent}
      overlayClassName="notification-popover"
      arrow={false}
    >
      <Badge
        size="default"
        dot={notifications.filter((n) => !n.isRead).length > 0}
      >
        <Button
          type="text"
          icon={<BellOutlined className="text-xl" />}
          className="flex items-center justify-center h-10 w-10"
        />
      </Badge>
    </Popover>
  );
};

export default NotificationPopover;
