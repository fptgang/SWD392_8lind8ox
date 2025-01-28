import React, { useEffect, useState } from 'react';
import { Card, Avatar, Typography, Button, Form, Input, message, Row, Col, Empty, Spin } from 'antd';
import { UserOutlined, EditOutlined, SaveOutlined } from '@ant-design/icons';
import { useGetIdentity, useOne, useUpdate } from '@refinedev/core';
import { AccountDto } from '../../../generated';
import { data } from 'react-router';

const { Title, Text } = Typography;

const ProfilePage: React.FC = () => {
  const { data: user, isLoading ,refetch} = useGetIdentity<AccountDto>();

  const [isEditing, setIsEditing] = useState(false);
  const { mutate: updateProfile } = useUpdate({
    resource: 'accounts',
  });
  const [form] = Form.useForm();

  if (isLoading) {
    return <Card><Spin size="large" /></Card>;
  }

  if (!user) {
    return <Card><Empty description="User not found" /></Card>;
  }
  const {data:data} = useOne<AccountDto>({
    resource: 'accounts',
    id: user?.accountId,
  });


  const displayUser = data?.data;
  // Add phone to initial form values
  const handleEdit = () => {
    form.setFieldsValue({
    accountId: displayUser?.accountId,
      firstName: displayUser?.firstName,
      lastName: displayUser?.lastName,
      email: displayUser?.email
    });
    setIsEditing(true);
  };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
    updateProfile({
        resource: 'accounts',
        id: displayUser?.accountId, // Use actual ID instead of 'me'
      
        values,
      });
      
      message.success('Profile updated successfully');
      setIsEditing(false);
    } catch (error) {
      console.error('Update error:', error);
      message.error('Failed to update profile');
    }
  };

  return (
    <Card>
      <div style={{ textAlign: 'center', marginBottom: 24 }}>
        <Avatar size={96} icon={<UserOutlined />} style={{ marginBottom: 16 }} />
        {!isEditing && (
          <div>
            <Title level={2} style={{ marginBottom: 8 }}>
              {displayUser?.firstName} {displayUser?.lastName}
            </Title>
            <Text type="secondary">{displayUser?.email}</Text>
          </div>
        )}
      </div>

      {isEditing ? (
        <Form
          form={form}
          layout="vertical"
          initialValues={{
            firstName: displayUser?.firstName,
            lastName: displayUser?.lastName,
            email: displayUser?.email,
          }}
          style={{ maxWidth: 600, margin: '0 auto' }}
        >
          <Row gutter={16}>
            <Col xs={24} sm={12}>
              <Form.Item
                name="firstName"
                label="First Name"
                rules={[{ required: true, message: 'Please enter your first name' }]}
              >
                <Input />
              </Form.Item>
            </Col>
            <Col xs={24} sm={12}>
              <Form.Item
                name="lastName"
                label="Last Name"
                rules={[{ required: true, message: 'Please enter your last name' }]}
              >
                <Input />
              </Form.Item>
            </Col>
          </Row>

          <Form.Item
            name="email"
            label="Email"
            rules={[{ required: true, type: 'email', message: 'Please enter a valid email' }]}
          >
            <Input disabled />
          </Form.Item>

    
          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
            <Button onClick={() => setIsEditing(false)}>Cancel</Button>
            <Button type="primary" icon={<SaveOutlined />} onClick={handleSave}>
              Save Changes
            </Button>
          </div>
        </Form>
      ) : (
        <div>
          <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: 24 }}>
            <Button type="primary" icon={<EditOutlined />} onClick={handleEdit}>
              Edit Profile
            </Button>
          </div>

          <Row gutter={[16, 16]}>
            <Col xs={24} sm={12}>
              <Text type="secondary" style={{ display: 'block', marginBottom: 4 }}>
                First Name
              </Text>
              <Text strong>{displayUser?.firstName}</Text>
            </Col>
            <Col xs={24} sm={12}>
              <Text type="secondary" style={{ display: 'block', marginBottom: 4 }}>
                Last Name
              </Text>
              <Text strong>{displayUser?.lastName}</Text>
            </Col>
            <Col xs={24}>
              <Text type="secondary" style={{ display: 'block', marginBottom: 4 }}>
                Email Address
              </Text>
              <Text strong>{displayUser?.email}</Text>
            </Col>
     
          </Row>
        </div>
      )}
    </Card>
  );
};

export default ProfilePage;