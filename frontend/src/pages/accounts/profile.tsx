import React, {useState} from 'react';
import {
  Button,
  Card,
  Col,
  Empty,
  Form,
  Input,
  message,
  Modal,
  Row,
  Spin,
  Typography,
  Upload
} from 'antd';
import {EditOutlined, PlusOutlined, SaveOutlined} from '@ant-design/icons';
import {useGetIdentity, useOne, useUpdate} from '@refinedev/core';
import {AccountDto} from '../../../generated';
import type {RcFile, UploadProps} from "antd/es/upload";
import type {UploadFile} from "antd/es/upload/interface";
import ImgCrop from "antd-img-crop";
import {store} from "../../store";
import {API_URL} from "../../utils/constants";

const {Title, Text} = Typography;

const apiUrl = API_URL;

const ProfilePage: React.FC = () => {
  const token = store.getState().auth.accessToken;
  const {data: user, isLoading} = useGetIdentity<AccountDto>();
  const [fileList, setFileList] = useState<UploadFile[]>([]);
  const {data: data} = useOne<AccountDto>({
    resource: 'accounts',
    id: user?.accountId,
  });

  React.useEffect(() => {
    if (user?.avatarUrl) {
      setFileList([{
        uid: '-1',
        name: 'avatar',
        status: 'done',
        url: user.avatarUrl,
      }]);
    }
  }, [user]);

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

  const handleChange: UploadProps["onChange"] = ({fileList: newFileList}) => {
    console.log(newFileList);
    setFileList(newFileList);
  };

  const uploadButton = (
    <div>
      <PlusOutlined/>
      <div style={{marginTop: 8}}>Upload</div>
    </div>
  );

  const [isEditing, setIsEditing] = useState(false);
  const {mutate: updateProfile} = useUpdate({
    resource: 'accounts',
  });
  const [form] = Form.useForm();

  if (isLoading) {
    return <Card><Spin size="large"/></Card>;
  }

  if (!user) {
    return <Card><Empty description="User not found"/></Card>;
  }

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
      await updateProfile({
        resource: 'accounts',
        id: displayUser?.accountId,
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
      <div style={{textAlign: 'center', marginBottom: 24}}>
        <ImgCrop rotationSlider aspectSlider showReset>
          <Upload
            action={apiUrl + "/accounts/" + user?.accountId + "/upload-avatar"}
            method="post"
            name="blob"
            headers={{Authorization: `Bearer ${token}`}}
            listType="picture-circle"
            fileList={fileList}
            onPreview={handlePreview}
            onChange={handleChange}
          >
            {fileList.length >= 1 ? null : uploadButton}
          </Upload>
        </ImgCrop>
        {!isEditing && (
          <div>
            <Title level={2} style={{marginBottom: 8}}>
              {displayUser?.firstName} {displayUser?.lastName}
            </Title>
            <Text type="secondary">{displayUser?.email}</Text>
          </div>
        )}
      </div>

      <Modal
        open={previewOpen}
        title={previewTitle}
        footer={null}
        onCancel={() => setPreviewOpen(false)}
      >
        <img alt="Preview" style={{width: "100%"}} src={previewImage}/>
      </Modal>

      {isEditing ? (
        <Form
          form={form}
          layout="vertical"
          initialValues={{
            firstName: displayUser?.firstName,
            lastName: displayUser?.lastName,
            email: displayUser?.email,
          }}
          style={{maxWidth: 600, margin: '0 auto'}}
        >
          <Row gutter={16}>
            <Col xs={24} sm={12}>
              <Form.Item
                name="firstName"
                label="First Name"
                rules={[{
                  required: true,
                  message: 'Please enter your first name'
                }]}
              >
                <Input/>
              </Form.Item>
            </Col>
            <Col xs={24} sm={12}>
              <Form.Item
                name="lastName"
                label="Last Name"
                rules={[{
                  required: true,
                  message: 'Please enter your last name'
                }]}
              >
                <Input/>
              </Form.Item>
            </Col>
          </Row>

          <Form.Item
            name="email"
            label="Email"
            rules={[{
              required: true,
              type: 'email',
              message: 'Please enter a valid email'
            }]}
          >
            <Input disabled/>
          </Form.Item>


          <div style={{display: 'flex', justifyContent: 'flex-end', gap: 8}}>
            <Button onClick={() => setIsEditing(false)}>Cancel</Button>
            <Button type="primary" icon={<SaveOutlined/>} onClick={handleSave}>
              Save Changes
            </Button>
          </div>
        </Form>
      ) : (
        <div>
          <div style={{
            display: 'flex',
            justifyContent: 'flex-end',
            marginBottom: 24
          }}>
            <Button type="primary" icon={<EditOutlined/>} onClick={handleEdit}>
              Edit Profile
            </Button>
          </div>

          <Row gutter={[16, 16]}>
            <Col xs={24} sm={12}>
              <Text type="secondary"
                    style={{display: 'block', marginBottom: 4}}>
                First Name
              </Text>
              <Text strong>{displayUser?.firstName}</Text>
            </Col>
            <Col xs={24} sm={12}>
              <Text type="secondary"
                    style={{display: 'block', marginBottom: 4}}>
                Last Name
              </Text>
              <Text strong>{displayUser?.lastName}</Text>
            </Col>
            <Col xs={24}>
              <Text type="secondary"
                    style={{display: 'block', marginBottom: 4}}>
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