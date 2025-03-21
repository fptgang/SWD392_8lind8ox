import React, { useState } from 'react';
import { useOne, useUpdate } from '@refinedev/core';
import { Card, Col, Row, Typography, Space, Button, Form, Input, message, Upload, Modal } from 'antd';
import {
  EditOutlined,
  SaveOutlined,
  PlusOutlined
} from '@ant-design/icons';
import { AccountDto } from '../../../../generated';
import type { RcFile, UploadProps } from "antd/es/upload";
import type { UploadFile } from "antd/es/upload/interface";
import ImgCrop from "antd-img-crop";
import {useNotification} from "@refinedev/core";
import {store} from "../../../store";
import {API_URL} from "../../../utils/constants";

const apiUrl = API_URL;

const { Title, Text } = Typography;

const CustomerProfile: React.FC = () => {
  const user = store.getState().auth.account;
  const token = store.getState().auth.accessToken;
  const { open } = useNotification();

  const [fileList, setFileList] = useState<UploadFile[]>([]);

  // Initialize fileList when component mounts and user is available
  React.useEffect(() => {
    if (user?.avatarUrl) {
      setFileList([{
        uid: '-1',
        name: 'avatar',
        status: 'done',
        url: user.avatarUrl,
      }]);
    }
  }, [user?.avatarUrl]);

  const [previewOpen, setPreviewOpen] = useState(false);
  const [previewImage, setPreviewImage] = useState("");
  const [previewTitle, setPreviewTitle] = useState("");

  const getBase64 = (file: RcFile): Promise<string> =>
    new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result as string);
      reader.onerror = (error) => reject(error);
    });

  const handlePreview = async (file: UploadFile) => {
    if (!file.url && !file.preview) {
      file.preview = await getBase64(file.originFileObj as RcFile);
    }

    setPreviewImage(file.url || (file.preview as string));
    setPreviewOpen(true);
    setPreviewTitle(
      file.name || file.url!.substring(file.url!.lastIndexOf("/") + 1)
    );
  };

  const handleChange: UploadProps["onChange"] = ({ fileList: newFileList }) => {
    console.log(newFileList);
    setFileList(newFileList);
  };

  const uploadButton = (
    <div>
      <PlusOutlined />
      <div style={{ marginTop: 8 }}>Upload</div>
    </div>
  );

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

      <Modal
        open={previewOpen}
        title={previewTitle}
        footer={null}
        onCancel={() => setPreviewOpen(false)}
      >
        <img alt="Preview" style={{ width: "100%" }} src={previewImage} />
      </Modal>

      <Row gutter={[24, 24]}>
        <Col xs={24} md={8}>
          <Card>
            <div className="text-center">
              <ImgCrop rotationSlider aspectSlider showReset>
                <Upload
                  action={apiUrl + "/accounts/" + user?.accountId + "/upload-avatar"}
                  method="post"
                  name="blob"
                  headers={{ Authorization: `Bearer ${token}` }}
                  listType="picture-circle"
                  fileList={fileList}
                  onPreview={handlePreview}
                  onChange={handleChange}
                >
                  {fileList.length >= 1 ? null : uploadButton}
                </Upload>
              </ImgCrop>
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