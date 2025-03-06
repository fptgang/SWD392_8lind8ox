import React, { useState } from "react";
import { Button, Form, Input, Select, Typography, Space, Divider, Collapse } from "antd";
import { FormInstance } from "antd/lib";
import { ShippingInfoDto, VoucherDto } from "../../../../../generated";
import { StepBaseProps } from "../../../../types";

const { Title } = Typography;
const { Panel } = Collapse;

interface CheckoutStepProps extends StepBaseProps {
  form: FormInstance;
  onVoucherUpdate: (voucher: VoucherDto) => Promise<void>;
  onShippingUpdate: (info: ShippingInfoDto) => Promise<void>;
}

export const CheckoutStep: React.FC<CheckoutStepProps> = ({
  form,
  onVoucherUpdate,
  onShippingUpdate,
  onPrevious,
  onNext,
}) => {
  const [voucherLoading, setVoucherLoading] = useState(false);

  const handleVoucherValidation = async () => {
    try {
      setVoucherLoading(true);
      const values = await form.validateFields(["voucherCode"]);

      if (values.voucherCode) {
        await onVoucherUpdate({
          code: values.voucherCode,
          discountRate: 10,
          limitAmount: 50,
          isUsed: false,
        });
      }
    } catch (error) {
      // Form validation error handled by Ant Design
    } finally {
      setVoucherLoading(false);
    }
  };

  const handleSubmit = async () => {
    try {
      // First validate shipping fields
      const values = await form.validateFields([
        "shippingInfo.name",
        "shippingInfo.phoneNumber",
        "shippingInfo.address",
        "shippingInfo.city",
        "shippingInfo.district",
        "shippingInfo.ward",
      ]);

      // Update shipping info
      await onShippingUpdate(values.shippingInfo);

      // If we have a voucher, ensure it's applied
      const voucher = form.getFieldValue("voucherCode");
      if (voucher && !voucherLoading) {
        await handleVoucherValidation();
      }

      // Proceed to next step
      onNext?.();
    } catch (error) {
      // Form validation error handled by Ant Design
    }
  };

  return (
    <div className="space-y-6">
      <div className="bg-gray-50 p-6 rounded-lg mb-6">
        <Title level={4}>Voucher Code (Optional)</Title>
        <Form.Item
          name="voucherCode"
          label="Voucher Code"
          className="max-w-md"
          rules={[
            {
              pattern: /^[A-Za-z0-9]{6,}$/,
              message: "Please enter a valid voucher code",
            },
          ]}
        >
          <div className="flex space-x-2">
            <Input placeholder="Enter voucher code (optional)" />
            <Button 
              onClick={handleVoucherValidation} 
              loading={voucherLoading}
              type="default"
            >
              Apply
            </Button>
          </div>
        </Form.Item>
      </div>

      <div className="bg-white p-6 rounded-lg border border-gray-200">
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

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <Form.Item
            name={["shippingInfo", "city"]}
            label="City"
            rules={[{ required: true, message: "Please select city" }]}
            className="md:col-span-1"
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
            className="md:col-span-1"
          >
            <Input placeholder="Enter district" />
          </Form.Item>

          <Form.Item
            name={["shippingInfo", "ward"]}
            label="Ward"
            rules={[{ required: true, message: "Please enter ward" }]}
            className="md:col-span-1"
          >
            <Input placeholder="Enter ward" />
          </Form.Item>
        </div>
      </div>

      <Space className="flex justify-between mt-8">
        <Button onClick={onPrevious}>Back to Cart</Button>
        <Button type="primary" onClick={handleSubmit}>
          Review Order
        </Button>
      </Space>
    </div>
  );
}; 