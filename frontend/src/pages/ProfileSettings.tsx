import React, { useState } from 'react';
import { useGetIdentity, useUpdate } from '@refinedev/core';
import { Form, Input, Button, Tabs, Card, Avatar, Typography, message, Space } from 'antd';
import { UserOutlined, LockOutlined, WalletOutlined } from '@ant-design/icons';
import { AccountDto } from '../../generated';

const { Title, Text } = Typography;

const ProfileSettings: React.FC = () => {
  const { data: user } = useGetIdentity<AccountDto>();
  const { mutate: updateProfile } = useUpdate();
  const [form] = Form.useForm();

  const handleProfileUpdate = async (values: any) => {
    try {
      await updateProfile({
        resource: 'accounts',
        id: 'me',
        values: values,
      });
      message.success('Profile updated successfully');
    } catch (error) {
      message.error('Failed to update profile');
    }
  };

  const handlePasswordUpdate = async (values: any) => {
    try {
      await updateProfile({
        resource: 'accounts/change-password',
        id: 'me',
        values: values,
      });
      message.success('Password updated successfully');
      form.resetFields();
    } catch (error) {
      message.error('Failed to update password');
    }
  };

  const items = [
    {
      key: '1',
      label: (
        <span>
          <UserOutlined />
          Profile
        </span>
      ),
      children: (
        <Card>
          <Form
            layout="vertical"
            initialValues={{
              email: user?.email,
              firstName: user?.firstName,
              lastName: user?.lastName,
              avatarUrl: user?.avatarUrl,
            }}
            onFinish={handleProfileUpdate}
          >
            <Form.Item
              label="Email"
              name="email"
              rules={[{ required: true, type: 'email' }]}
            >
              <Input readOnly />
            </Form.Item>
            <Space direction="horizontal" size="large" style={{ display: 'flex' }}>
              <Form.Item
                label="First Name"
                name="firstName"
                rules={[{ required: true }]}
              >
                <Input />
              </Form.Item>
              <Form.Item
                label="Last Name"
                name="lastName"
                rules={[{ required: true }]}
              >
                <Input />
              </Form.Item>
            </Space>
            <Form.Item
              label="Avatar URL"
              name="avatarUrl"
            >
              <Input />
            </Form.Item>
            <Form.Item>
              <Button type="primary" htmlType="submit">
                Save Changes
              </Button>
            </Form.Item>
          </Form>
        </Card>
      ),
    },
    {
      key: '2',
      label: (
        <span>
          <LockOutlined />
          Security
        </span>
      ),
      children: (
        <Card>
          <Form
            form={form}
            layout="vertical"
            onFinish={handlePasswordUpdate}
          >
            <Form.Item
              label="Current Password"
              name="currentPassword"
              rules={[{ required: true }]}
            >
              <Input.Password />
            </Form.Item>
            <Form.Item
              label="New Password"
              name="newPassword"
              rules={[{ required: true, min: 6 }]}
            >
              <Input.Password />
            </Form.Item>
            <Form.Item
              label="Confirm New Password"
              name="confirmPassword"
              dependencies={['newPassword']}
              rules={[
                { required: true },
                ({ getFieldValue }) => ({
                  validator(_, value) {
                    if (!value || getFieldValue('newPassword') === value) {
                      return Promise.resolve();
                    }
                    return Promise.reject('Passwords do not match!');
                  },
                }),
              ]}
            >
              <Input.Password />
            </Form.Item>
            <Form.Item>
              <Button type="primary" htmlType="submit">
                Update Password
              </Button>
            </Form.Item>
          </Form>
        </Card>
      ),
    },
    {
      key: '3',
      label: (
        <span>
          <WalletOutlined />
          Wallet
        </span>
      ),
      children: (
        <Card>
          <div className="space-y-6">
            <div className="bg-gray-50 p-4 rounded-lg">
              <Title level={4}>Current Balance</Title>
              <Text className="text-3xl font-bold text-blue-600">
                ${user?.balance?.toFixed(2)}
              </Text>
              <Text className="block text-sm text-gray-500">
                Last updated: {user?.updateBalanceAt ?? 'N/A'}
              </Text>
            </div>
            <div>
              <Title level={4}>Recent Transactions</Title>
              <div className="space-y-2">
                {/* Transaction list will be implemented here */}
              </div>
            </div>
            <Space>
              <Button type="primary" className="bg-green-600">
                Deposit
              </Button>
              <Button danger>
                Withdraw
              </Button>
            </Space>
          </div>
        </Card>
      ),
    },
  ];

  return (
    <div className="container mx-auto px-4 py-8">
      <Title level={2} className="mb-8">Account Settings</Title>
      <Tabs defaultActiveKey="1" items={items} />
    </div>
  );
};

export default ProfileSettings;