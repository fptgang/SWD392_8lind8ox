import React, { useState } from "react";
import {
  Typography,
  Card,
  Button,
  Space,
  Divider,
  Empty,
  Tag,
  Badge,
  notification,
  Tabs,
  Layout,
  Row,
  Col,
} from "antd";
import {
  BellOutlined,
  FilterOutlined,
  ReloadOutlined,
  CheckOutlined,
} from "@ant-design/icons";
import { motion } from "framer-motion";
import { useList, useUpdate, useSubscription } from "@refinedev/core";
import { NotificationDto } from "../../../generated";
import { store } from "../../store";
import NotificationItem from "../../components/notification/NotificationItem";
import NotificationStats from "../../components/notification/NotificationsStats";
import api from "../../config/openapi-config";

const { Title, Text } = Typography;
const { Content } = Layout;
const { TabPane } = Tabs;

const NotificationsPage: React.FC = () => {
  const [pageSize, setPageSize] = useState(20);
  const [activeTab, setActiveTab] = useState<string>("all");

  // Get user from store
  const user = store.getState().auth.account;
  const email = user?.email;

  // Fetch notifications
  const { data, isLoading, refetch } = useList<NotificationDto>({
    resource: "notifications",
    pagination: {
      pageSize,
    },
    filters: [
      {
        field: "isRead",
        operator: "eq",
        value: activeTab === "unread" ? false : undefined,
      },
    ],
    sorters: [
      {
        field: "createdAt",
        order: "desc",
      },
    ],
    liveMode: "off",
  });

  // Real-time notification updates
  useSubscription({
    channel: email ? `noti/${email}` : "",
    onLiveEvent: () => {
      refetch();
    },
    enabled: !!email,
  });

  const notifications = data?.data ?? [];
  const total = data?.total ?? 0;
  const unreadCount = notifications.filter((n) => !n.isRead).length;

  // Handle marking all as read
  const handleMarkAllAsRead = () => {
    const unreadNotifications = notifications.filter((n) => !n.isRead);
    if (unreadNotifications.length === 0) return;

    try {
      unreadNotifications.forEach(async (noti) => {
        if (noti.notificationId) {
          await api.updateNotification({
            notificationId: noti.notificationId,
            notificationDto: {
              isRead: true,
            },
          });
        }
      });
      refetch();
      notification.success({
        message: "Success",
        description: "All notifications marked as read",
      });

      refetch();
    } catch (error) {
      notification.error({
        message: "Error",
        description:
          error instanceof Error ? error.message : "An unknown error occurred",
      });
    }
  };

  // Handle infinite scroll
  const handleScroll = (e: React.UIEvent<HTMLDivElement>) => {
    const target = e.target as HTMLDivElement;
    if (
      target.scrollHeight - target.scrollTop === target.clientHeight &&
      notifications.length < total
    ) {
      setPageSize((prev) => prev + 20);
    }
  };

  return (
    <Layout className="site-layout-background" style={{ padding: "24px 0" }}>
      <Content style={{ padding: "0 24px" }}>
        <Row gutter={[24, 24]}>
          <Col xs={24} md={18}>
            <Card bordered={false}>
              <div className="flex justify-between items-center mb-4">
                <Space>
                  <BellOutlined style={{ fontSize: 24 }} />
                  <Title level={3} style={{ margin: 0 }}>
                    Notifications
                  </Title>
                  {unreadCount > 0 && (
                    <Badge
                      count={unreadCount}
                      style={{ backgroundColor: "#1890ff" }}
                    />
                  )}
                </Space>

                <Space>
                  <Button
                    icon={<ReloadOutlined />}
                    onClick={() => refetch()}
                    loading={isLoading}
                  >
                    Refresh
                  </Button>

                  <Button
                    type="primary"
                    icon={<CheckOutlined />}
                    onClick={handleMarkAllAsRead}
                    disabled={unreadCount === 0}
                  >
                    Mark all as read
                  </Button>
                </Space>
              </div>

              <Tabs activeKey={activeTab} onChange={setActiveTab}>
                <TabPane tab="All" key="all" />
                <TabPane
                  tab={
                    <>
                      Unread <Badge count={unreadCount} size="small" />
                    </>
                  }
                  key="unread"
                />
              </Tabs>

              <div
                className="overflow-y-auto"
                style={{ maxHeight: "calc(100vh - 300px)", padding: "0 8px" }}
                onScroll={handleScroll}
              >
                {isLoading ? (
                  <div className="flex justify-center py-12">
                    <div className="loading-spinner" />
                  </div>
                ) : notifications.length === 0 ? (
                  <Empty
                    image={Empty.PRESENTED_IMAGE_SIMPLE}
                    description={
                      activeTab === "unread"
                        ? "No unread notifications"
                        : "No notifications"
                    }
                    className="py-12"
                  />
                ) : (
                  <motion.div layout>
                    {notifications.map((notification) => (
                      <NotificationItem
                        key={notification.notificationId}
                        noti={notification}
                        onMarkAsRead={refetch}
                      />
                    ))}
                  </motion.div>
                )}
              </div>
            </Card>
          </Col>

          <Col xs={24} md={6}>
            <NotificationStats total={total} unread={unreadCount} />
          </Col>
        </Row>
      </Content>
    </Layout>
  );
};

export default NotificationsPage;
