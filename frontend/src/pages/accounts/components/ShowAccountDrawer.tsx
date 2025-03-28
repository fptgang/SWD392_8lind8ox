import React from "react";
import { useOne, useNavigation, useDelete } from "@refinedev/core";
import {
  TagField,
  EmailField,
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
  Skeleton,
  Divider,
  Badge,
  Alert,
  Drawer,
  Button,
} from "antd";
import {
  UserOutlined,
  MailOutlined,
  ClockCircleOutlined,
  SafetyCertificateOutlined,
  CheckCircleOutlined,
  EyeOutlined,
  ArrowsAltOutlined,
} from "@ant-design/icons";
import { AccountDto } from "../../../../generated";
import { ROLE_COLOR_MAP } from "../../../utils/constants";
import { Link } from "react-router";

const { Title } = Typography;

interface ShowAccountsShowDrawerProps {
  accountId?: string;
  open: boolean;
  onClose: () => void;
}

export const ShowAccountsShowDrawer: React.FC<ShowAccountsShowDrawerProps> = ({
  accountId,
  open,
  onClose,
}) => {
  const { data, isLoading } = useOne<AccountDto>({
    resource: "accounts",
    id: accountId || "",
    queryOptions: {
      enabled: !!accountId,
    },
  });
  const { edit } = useNavigation();
  const { mutate: deleteMutation } = useDelete();
  const record = data?.data;

  const getRoleTag = (role: string | undefined) => {
    const colorMap: Record<string, string> = ROLE_COLOR_MAP;
    if (!role) return null;
    return (
      <Tag color={colorMap[role]} className="text-sm">
        {role.charAt(0) + role.slice(1).toLowerCase()}
      </Tag>
    );
  };

  const handleEdit = () => {
    if (record?.accountId) {
      edit("accounts", record.accountId);
    }
  };

  const handleDelete = () => {
    if (record?.accountId) {
      deleteMutation(
        {
          resource: "accounts",
          id: record.accountId,
        },
        {
          onSuccess: () => onClose(),
        }
      );
    }
  };

  // const footerContent = !record?.isVerified ? (
  const footerContent = (
    <Space>
      <Button onClick={handleEdit} disabled={!record}>
        Edit
      </Button>
      <Button onClick={handleDelete} disabled={!record} danger>
        Delete
      </Button>
    </Space>
  ) : null;

  return (
    <Drawer
      title="Account Details"
      open={open}
      onClose={onClose}
      width={800}
      footer={footerContent}
      destroyOnClose
    >
      {isLoading ? (
        <Skeleton active paragraph={{ rows: 6 }} />
      ) : (
        <Space direction="vertical" size="large" className="w-full">
          <Link
            to={`/admin/accounts/show/${accountId}`}
            style={{ textAlign: "right", display: "block", color: "#1890ff" }}
          >
            {" "}
            View account details in full screen <ArrowsAltOutlined />
          </Link>
          {/*{record?.isVerified && (*/}
          {/*  <Alert*/}
          {/*    message="Verified Account"*/}
          {/*    description="This account has been verified and cannot be modified."*/}
          {/*    type="success"*/}
          {/*    showIcon*/}
          {/*  />*/}
          {/*)}*/}
          <Card
            title={
              <Space>
                <UserOutlined className="text-blue-500" />
                <span className="font-semibold">Account Details</span>
              </Space>
            }
            className="shadow-md"
          >
            <Descriptions
              bordered
              column={{ xxl: 2, xl: 2, lg: 2, md: 1, sm: 1, xs: 1 }}
            >
              <Descriptions.Item
                label={
                  <Space>
                    <UserOutlined />
                    Full Name
                  </Space>
                }
                span={2}
              >
                {isLoading ? (
                  <Skeleton.Input active size="small" />
                ) : (
                  <span className="font-medium">
                    {record?.firstName} {record?.lastName}
                  </span>
                )}
              </Descriptions.Item>

              <Descriptions.Item
                label={
                  <Space>
                    <MailOutlined />
                    Email
                  </Space>
                }
              >
                <EmailField value={record?.email} />
              </Descriptions.Item>

              <Descriptions.Item
                label={
                  <Space>
                    <SafetyCertificateOutlined />
                    Role
                  </Space>
                }
              >
                {getRoleTag(record?.role)}
              </Descriptions.Item>

              {/*<Descriptions.Item*/}
              {/*  label={*/}
              {/*    <Space>*/}
              {/*      <CheckCircleOutlined />*/}
              {/*      Verification Status*/}
              {/*    </Space>*/}
              {/*  }*/}
              {/*  span={2}*/}
              {/*>*/}
              {/*  <Space direction="vertical">*/}
              {/*    <Badge*/}
              {/*      status={record?.isVerified ? "success" : "warning"}*/}
              {/*      text={record?.isVerified ? "Verified" : "Unverified"}*/}
              {/*    />*/}
              {/*    {record?.verifiedAt && (*/}
              {/*      <small className="text-gray-500">*/}
              {/*        Verified on{" "}*/}
              {/*        <DateField*/}
              {/*          value={record?.verifiedAt}*/}
              {/*          format="MMMM D, YYYY"*/}
              {/*        />*/}
              {/*      </small>*/}
              {/*    )}*/}
              {/*  </Space>*/}
              {/*</Descriptions.Item>*/}

              <Descriptions.Item
                label={
                  <Space>
                    <EyeOutlined />
                    Visibility
                  </Space>
                }
              >
                <BooleanField
                  value={record?.isVisible}
                  trueIcon={<CheckCircleOutlined className="text-green-500" />}
                  falseIcon={<ClockCircleOutlined className="text-gray-500" />}
                  valueLabelTrue="Visible"
                  valueLabelFalse="Hidden"
                />
              </Descriptions.Item>
            </Descriptions>
          </Card>

          <Card
            title={
              <Space>
                <ClockCircleOutlined className="text-blue-500" />
                <span className="font-semibold">System Information</span>
              </Space>
            }
            className="shadow-md"
          >
            <Descriptions
              bordered
              column={{ xxl: 2, xl: 2, lg: 2, md: 1, sm: 1, xs: 1 }}
            >
              <Descriptions.Item label="Created At">
                <DateField
                  value={record?.createdAt}
                  format="MMMM D, YYYY HH:mm:ss"
                />
              </Descriptions.Item>

              <Descriptions.Item label="Last Updated">
                <DateField
                  value={record?.updatedAt}
                  format="MMMM D, YYYY HH:mm:ss"
                />
              </Descriptions.Item>

              <Descriptions.Item label="Account ID" span={2}>
                <Tag className="font-mono">{record?.accountId}</Tag>
              </Descriptions.Item>
            </Descriptions>
          </Card>
        </Space>
      )}
    </Drawer>
  );
};
