import React, { useState } from "react";
import {
  Typography,
  Badge,
  Space,
  notification,
  Modal,
  Button,
  Descriptions,
  Card,
} from "antd";
import {
  ClockCircleOutlined,
  CheckCircleOutlined,
  CloseCircleOutlined,
  DeleteOutlined,
} from "@ant-design/icons";
import { motion } from "framer-motion";
import { format, formatDistanceToNow } from "date-fns";
import { useUpdate } from "@refinedev/core";
import { NotificationDto } from "../../../generated";
import api from "../../config/openapi-config";
import { on } from "events";

const { Text } = Typography;

interface NotificationItemProps {
  noti: NotificationDto;
  onMarkAsRead?: () => void;
}

const NotificationItem: React.FC<NotificationItemProps> = ({
  noti,
  onMarkAsRead,
}) => {
  const [showDetailModal, setShowDetailModal] = useState(false);
  const handleMarkAsRead = () => {
    try {
      if (noti.notificationId && !noti.isRead) {
        api
          .updateNotification({
            notificationId: noti.notificationId,
            notificationDto: {
              isRead: true,
            },
          })
          .then(() => {
            onMarkAsRead && onMarkAsRead();
          });

        if (onMarkAsRead) {
          onMarkAsRead();
        }
      }
    } catch (error) {
      notification.error({
        message: "Error updating notification",
        description:
          error instanceof Error ? error.message : "An unknown error occurred",
      });
    }
  };

  const handleItemClick = () => {
    setShowDetailModal(true);
    if (!noti.isRead) {
      handleMarkAsRead();
    }
  };

  return (
    <>
      <motion.div layout>
        <Card
          className={`mb-3 cursor-pointer transition-shadow ${
            !noti.isRead ? "border-blue-300" : ""
          }`}
          hoverable
          bordered
          onClick={handleItemClick}
        >
          <div className="flex items-start gap-3">
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-2">
                {!noti.isRead && <Badge dot status="processing" color="blue" />}
                <Text strong={!noti.isRead} className="block">
                  {noti.message}
                </Text>
              </div>
              <Space className="mt-2" size="small">
                <ClockCircleOutlined className="text-gray-400" />
                <Text type="secondary" className="text-sm">
                  {noti.createdAt &&
                    formatDistanceToNow(new Date(noti.createdAt), {
                      addSuffix: true,
                    })}
                </Text>
              </Space>
            </div>
            {!noti.isRead && (
              <CheckCircleOutlined className="text-gray-400 mt-1" />
            )}
          </div>
        </Card>
      </motion.div>

      <Modal
        title="Notification Details"
        open={showDetailModal}
        onCancel={() => setShowDetailModal(false)}
        footer={[
          <Button
            key="close"
            icon={<CloseCircleOutlined />}
            onClick={() => setShowDetailModal(false)}
          >
            Close
          </Button>,
        ]}
        width={600}
        centered
        destroyOnClose
      >
        <div className="p-4">
          <Descriptions bordered column={1}>
            <Descriptions.Item label="Message">
              <Text strong className="text-base">
                {noti.message}
              </Text>
            </Descriptions.Item>

            <Descriptions.Item label="Created At">
              <Space>
                <ClockCircleOutlined />
                {noti.createdAt &&
                  format(new Date(noti.createdAt), "MMM d, yyyy h:mm a")}
              </Space>
            </Descriptions.Item>

            <Descriptions.Item label="Last Updated">
              <Space>
                <ClockCircleOutlined />
                {noti.updatedAt &&
                  format(new Date(noti.updatedAt), "MMM d, yyyy h:mm a")}
              </Space>
            </Descriptions.Item>

            <Descriptions.Item label="Status">
              <Badge
                status={noti.isRead ? "default" : "processing"}
                text={noti.isRead ? "Read" : "Unread"}
              />
            </Descriptions.Item>
          </Descriptions>

          {noti.accountId && (
            <div className="mt-4 text-right">
              <Text type="secondary" className="text-xs">
                Account ID: {noti.accountId}
              </Text>
            </div>
          )}
        </div>
      </Modal>
    </>
  );
};

export default NotificationItem;
