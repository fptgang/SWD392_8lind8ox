import React from 'react';
import { useOne, useUpdate } from '@refinedev/core';
import { Card, Col, Row, Typography, Space, Button, Form, Input, Avatar, message } from 'antd';
import { UserOutlined, EditOutlined, SaveOutlined } from '@ant-design/icons';
import { AccountDto } from '../../../../generated';

const { Title, Text } = Typography;

const CustomerProfile: React.FC = () => {
  const [form] = Form.useForm();
  const [isEditing, setIsEditing] = React.useState(false);

  const { data, isLoading } = useOne<AccountDto>({
    resource: 'accounts',
    id: 'me',
  });

  const { mutate } = useUpdate();

  React.useEffect(() => {
    if (data?.data) {
      form.setFieldsValue({
        firstName: data.data.firstName,
        lastName: data.data.lastName,
        email: data.data.email,
        phone: data.data.phone,
      });
    }
  }, [data?.data, form]);

  const handleSubmit = async (values: any) => {
    try {
      await mutate({
        resource: 'accounts',
        id: 'me',
        values: values,
      });
      message.success('Profile updated successfully');
      setIsEditing(false);
    } catch (error) {
      message.error('Failed to update profile');
    }
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="mb-8">
        <Title level={2}>My Profile</Title>
        <Text className="text-gray-600">
          Manage your personal information and account settings
        </Text>
      </div>

      <Row gutter={[24, 24]}>
        <Col xs={24} md={8}>
          <Card>
            <div className="text-center">
              <Avatar
                size={120}
                icon={<UserOutlined />}
                className="mb-4"
              />
              <Title level={4}>
                {data?.data?.firstName} {data?.data?.lastName}
              </Title>
              <Text type="secondary">{data?.data?.email}</Text>
            </div>
          </Card>
        </Col>

        <Col xs={24} md={16}>
          <Card
            title="Personal Information"
            extra={
              !isEditing ? (
                <Button
                  type="primary"
                  icon={<EditOutlined />}
                  onClick={() => setIsEditing(true)}
                >
                  Edit Profile
                </Button>
              ) : null
            }
          >
            <Form
              form={form}
              layout="vertical"
              onFinish={handleSubmit}
              disabled={!isEditing}
            >
              <Row gutter={16}>
                <Col xs={24} sm={12}>
                  <Form.Item
                    name="firstName"
                    label="First Name"
                    rules={[{ required: true, message: 'First name is required' }]}
                  >
                    <Input />
                  </Form.Item>
                </Col>
                <Col xs={24} sm={12}>
                  <Form.Item
                    name="lastName"
                    label="Last Name"
                    rules={[{ required: true, message: 'Last name is required' }]}
                  >
                    <Input />
                  </Form.Item>
                </Col>
              </Row>

              <Form.Item
                name="email"
                label="Email"
                rules={[
                  { required: true, message: 'Email is required' },
                  { type: 'email', message: 'Please enter a valid email' },
                ]}
              >
                <Input disabled />
              </Form.Item>

              <Form.Item
                name="phone"
                label="Phone Number"
                rules={[{ required: true, message: 'Phone number is required' }]}
              >
                <Input />
              </Form.Item>

              {isEditing && (
                <Form.Item className="text-right">
                  <Space>
                    <Button onClick={() => setIsEditing(false)}>Cancel</Button>
                    <Button type="primary" icon={<SaveOutlined />} htmlType="submit">
                      Save Changes
                    </Button>
                  </Space>
                </Form.Item>
              )}
            </Form>
          </Card>
        </Col>
      </Row>
    </div>
  );
};

export default CustomerProfile;