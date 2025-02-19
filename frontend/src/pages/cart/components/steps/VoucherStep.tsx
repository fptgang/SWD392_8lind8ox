// components/steps/VoucherStep.tsx
import React, { useState } from "react";
import { Button, Form, Input, Typography, Space } from "antd";
import { FormInstance } from "antd/lib";
import { VoucherDto } from "../../../../../generated";
import { StepBaseProps } from "../../../../types";

const { Title } = Typography;

interface VoucherStepProps extends StepBaseProps {
  form: FormInstance;
  onVoucherUpdate: (voucher: VoucherDto) => Promise<void>;
}

export const VoucherStep: React.FC<VoucherStepProps> = ({
  form,
  onVoucherUpdate,
  onPrevious,
  onNext,
}) => {
  const [loading, setLoading] = useState(false);

  const handleVoucherValidation = async () => {
    try {
      setLoading(true);
      const values = await form.validateFields(["voucherCode"]);

      // Mock voucher validation - replace with actual API call
      if (values.voucherCode) {
        await onVoucherUpdate({
          code: values.voucherCode,
          discountRate: 10,
          limitAmount: 50,
          isUsed: false,
        });
      }

      onNext?.();
    } catch (error) {
      // Form validation error handled by Ant Design
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <Title level={4}>Apply Voucher</Title>
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
        <Input placeholder="Enter voucher code (optional)" />
      </Form.Item>
      <Space className="flex justify-between">
        <Button onClick={onPrevious}>Back to Cart</Button>
        <Button
          type="primary"
          onClick={handleVoucherValidation}
          loading={loading}
        >
          Proceed to Shipping
        </Button>
      </Space>
    </div>
  );
};
