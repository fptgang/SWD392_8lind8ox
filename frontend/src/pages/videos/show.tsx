import React from "react";
import { useShow, useTranslate } from "@refinedev/core";
import {
  Show,
  TagField,
  UrlField,
  TextField,
  BooleanField,
  DateField,
} from "@refinedev/antd";
import {
  Typography,
  Card,
  Descriptions,
  Space,
  Tag,
  Divider,
  Alert,
} from "antd";
import {
  UserOutlined,
  LinkOutlined,
  FileTextOutlined,
  EyeOutlined,
  ClockCircleOutlined,
  CheckCircleOutlined,
  VideoCameraOutlined,
} from "@ant-design/icons";
import { VideoDto } from "../../../generated/models/VideoDto";

const { Title, Text } = Typography;

export const VideosShow = () => {
  const translate = useTranslate();
  const { queryResult } = useShow<VideoDto>();
  const { data, isLoading } = queryResult;
  const record = data?.data;

  const getVideoEmbed = (url: string) => {
    // Handle YouTube URLs
    if (url) {
      return (
        // <iframe
        //   width="100%"
        //   height="400"
        //   src={`https://www.youtube.com/embed/${videoId}`}
        //   title="YouTube video player"
        //   frameBorder="0"
        //   allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        //   allowFullScreen
        // ></iframe>
        <video controls src={url} width="100%" height="400" />
      );
    }

    // Add support for other video platforms if needed

    // Default fallback to a simple link if we can't embed
    return (
      <Alert
        message="Video Preview Not Available"
        description={
          <Space direction="vertical">
            <Text>This video format cannot be embedded directly.</Text>
            <a href={url} target="_blank" rel="noopener noreferrer">
              <Space>
                <LinkOutlined />
                Open Video in New Tab
              </Space>
            </a>
          </Space>
        }
        type="info"
        showIcon
      />
    );
  };

  return (
    <Show isLoading={isLoading}>
      <div className="grid gap-6">
        {/* Video Player Section */}
        <Card bordered={false} className="shadow-md">
          <Title level={4}>
            <Space>
              <VideoCameraOutlined />
              Video Content
            </Space>
          </Title>
          <Divider />
          <div className="my-4">
            {record?.url ? (
              getVideoEmbed(record.url)
            ) : (
              <Alert
                message="No Video URL"
                description="This video record doesn't contain a URL."
                type="warning"
                showIcon
              />
            )}
          </div>
        </Card>

        {/* Video Details Section */}
        <Card bordered={false} className="shadow-md">
          <Title level={4}>
            <Space>
              <FileTextOutlined />
              Video Details
            </Space>
          </Title>
          <Divider />
          <Descriptions bordered column={{ xs: 1, sm: 2, md: 3 }} size="middle">
            <Descriptions.Item label="Video ID" span={1}>
              {record?.videoId}
            </Descriptions.Item>
            <Descriptions.Item label="Status" span={2}>
              <Space direction="vertical">
                <Space>
                  <Text>Visibility:</Text>
                  {record?.isVisible ? (
                    <Tag color="green">Visible</Tag>
                  ) : (
                    <Tag color="red">Hidden</Tag>
                  )}
                </Space>
                <Space>
                  <Text>Verification:</Text>
                  {record?.isVerified ? (
                    <Tag color="blue">Verified</Tag>
                  ) : (
                    <Tag color="orange">Unverified</Tag>
                  )}
                </Space>
              </Space>
            </Descriptions.Item>
            <Descriptions.Item label="URL" span={4}>
              {record?.url ? (
                <a href={record.url} target="_blank" rel="noopener noreferrer">
                  <Space>
                    <LinkOutlined />
                    {record.url.length > 200
                      ? `${record.url.substring(0, 200)}...`
                      : record.url}
                  </Space>
                </a>
              ) : (
                <Text type="secondary">No URL provided</Text>
              )}
            </Descriptions.Item>

            <Descriptions.Item label="Uploaded By" span={4}>
              {record?.account ? (
                <Space>
                  <UserOutlined />
                  {`${record.account.firstName || ""} ${
                    record.account.lastName || ""
                  }`}
                  {record.account.email && (
                    <Text type="secondary">({record.account.email})</Text>
                  )}
                </Space>
              ) : (
                <Text type="secondary">Unknown User</Text>
              )}
            </Descriptions.Item>

            <Descriptions.Item label="Slot ID" span={1}>
              {record?.slotId || <Text type="secondary">Not assigned</Text>}
            </Descriptions.Item>

            <Descriptions.Item label="Description" span={3}>
              {record?.description ? (
                <div className="whitespace-pre-wrap">{record.description}</div>
              ) : (
                <Text type="secondary">No description</Text>
              )}
            </Descriptions.Item>

            <Descriptions.Item label="Created At">
              {record?.createdAt ? (
                <DateField
                  value={record.createdAt}
                  format="MMMM DD, YYYY HH:mm:ss"
                />
              ) : (
                <Text type="secondary">Unknown</Text>
              )}
            </Descriptions.Item>

            <Descriptions.Item label="Updated At">
              {record?.updatedAt ? (
                <DateField
                  value={record.updatedAt}
                  format="MMMM DD, YYYY HH:mm:ss"
                />
              ) : (
                <Text type="secondary">Unknown</Text>
              )}
            </Descriptions.Item>
          </Descriptions>
        </Card>
      </div>
    </Show>
  );
};
