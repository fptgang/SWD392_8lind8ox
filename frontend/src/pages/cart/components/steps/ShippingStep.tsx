// components/steps/ShippingStep.tsx
import React from "react";
import { Button, Form, Input, Select, Typography, Space } from "antd";
import { ShippingInfoDto } from "../../../../generated";
import { StepBaseProps } from "../../types";

const { Title } = Typography;

interface ShippingStepProps extends StepBaseProps {
  form: FormInstance;
  onShippingUpdate: (info: ShippingInfoDto) => Promise<void>;
}

export const ShippingStep: React.FC<ShippingStepProps> = ({
  form,
  onShippingUpdate,
  onPrevious,
  onNext,
}) => {
  const handleSubmit = async () => {
    try {
      const values = await form.validateFields([
        "shippingInfo.name",
        "shippingInfo.phoneNumber",
        "shippingInfo.address",
        "shippingInfo.city",
        "shippingInfo.district",
        "shippingInfo.ward",
      ]);

      await onShippingUpdate(values.shippingInfo);
      onNext?.();
    } catch (error) {
      // Form validation error handled by Ant Design
    }
  };

  return (
    <div className="space-y-6">
      <Title level={4}>Shipping Information</Title>

      <Form.Item
        name={["shippingInfo", "name"]}
        label="Full Name"
        rules={[
          { required: true, message: "Please enter your name" },
          { min: 2, message: "Name must be at least 2 characters" },
        ]}
      >
        <Input placeholder="Enter full name" />
      </Form.Item>

      <Form.Item
        name={["shippingInfo", "phoneNumber"]}
        label="Phone Number"
        rules={[
          { required: true, message: "Please enter phone number" },
          {
            pattern: /^[0-9]{10}$/,
            message: "Please enter a valid phone number",
          },
        ]}
      >
        <Input placeholder="Enter phone number" />
      </Form.Item>

      <Form.Item
        name={["shippingInfo", "address"]}
        label="Address"
        rules={[
          { required: true, message: "Please enter address" },
          { min: 5, message: "Address must be at least 5 characters" },
        ]}
      >
        <Input.TextArea placeholder="Enter shipping address" rows={3} />
      </Form.Item>

      <Form.Item
        name={["shippingInfo", "city"]}
        label="City"
        rules={[{ required: true, message: "Please select city" }]}
      >
        <Select placeholder="Select city">
          <Select.Option value="Ho Chi Minh">Ho Chi Minh</Select.Option>
          <Select.Option value="Hanoi">Hanoi</Select.Option>
          <Select.Option value="Da Nang">Da Nang</Select.Option>
        </Select>
      </Form.Item>

      <Form.Item
        name={["shippingInfo", "district"]}
        label="District"
        rules={[{ required: true, message: "Please enter district" }]}
      >
        <Input placeholder="Enter district" />
      </Form.Item>

      <Form.Item
        name={["shippingInfo", "ward"]}
        label="Ward"
        rules={[{ required: true, message: "Please enter ward" }]}
      >
        <Input placeholder="Enter ward" />
      </Form.Item>

      <Space className="flex justify-between">
        <Button onClick={onPrevious}>Back to Voucher</Button>
        <Button type="primary" onClick={handleSubmit}>
          Review Order
        </Button>
      </Space>
    </div>
  );
};
