import React from 'react';
import { Form, Input, Button, Row, Col, Space } from 'antd';
import { ShippingInfoDto } from '../../../../generated';

interface AddressFormProps {
  initialValues?: ShippingInfoDto;
  onSubmit: (values: ShippingInfoDto) => void;
  onCancel: () => void;
}

const AddressForm: React.FC<AddressFormProps> = ({ 
  initialValues, 
  onSubmit, 
  onCancel 
}) => {
  const [form] = Form.useForm();

  const handleSubmit = (values: ShippingInfoDto) => {
    onSubmit(values);
  };

  return (
    <Form
      form={form}
      layout="vertical"
      initialValues={initialValues || {}}
      onFinish={handleSubmit}
    >
      <Row gutter={16}>
        <Col span={12}>
          <Form.Item
            name="name"
            label="Full Name"
            rules={[{ required: true, message: 'Please enter your full name' }]}
          >
            <Input placeholder="Full Name" />
          </Form.Item>
        </Col>
        <Col span={12}>
          <Form.Item
            name="phoneNumber"
            label="Phone Number"
            rules={[
              { required: true, message: 'Please enter your phone number' },
              { pattern: /^[0-9]+$/, message: 'Please enter a valid phone number' }
            ]}
          >
            <Input placeholder="Phone Number" />
          </Form.Item>
        </Col>
      </Row>

      <Form.Item
        name="address"
        label="Address Line"
        rules={[{ required: true, message: 'Please enter your address' }]}
      >
        <Input placeholder="Street address, house number, etc." />
      </Form.Item>

      <Row gutter={16}>
        <Col span={8}>
          <Form.Item
            name="city"
            label="City"
            rules={[{ required: true, message: 'Please enter city' }]}
          >
            <Input placeholder="City" />
          </Form.Item>
        </Col>
        <Col span={8}>
          <Form.Item
            name="district"
            label="District"
            rules={[{ required: true, message: 'Please enter district' }]}
          >
            <Input placeholder="District" />
          </Form.Item>
        </Col>
        <Col span={8}>
          <Form.Item
            name="ward"
            label="Ward"
            rules={[{ required: true, message: 'Please enter ward' }]}
          >
            <Input placeholder="Ward" />
          </Form.Item>
        </Col>
      </Row>

      <div className="flex justify-end mt-4">
        <Space>
          <Button onClick={onCancel}>
            Cancel
          </Button>
          <Button type="primary" htmlType="submit">
            {initialValues ? 'Update Address' : 'Add Address'}
          </Button>
        </Space>
      </div>
    </Form>
  );
};

export default AddressForm; 