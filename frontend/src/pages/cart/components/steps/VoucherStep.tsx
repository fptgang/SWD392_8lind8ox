// components/steps/VoucherStep.tsx
import React, { useState } from "react";
import { Button, Form, Input, Space, Typography, message } from "antd";
import { FormInstance } from "antd/lib/form";
import { StepBaseProps } from "../../types";

const { Title, Text } = Typography;

export interface VoucherStepProps {
  form: FormInstance;
  onVoucherUpdate: (code: string) => Promise<void>;
  onNext?: () => true | Promise<{}> | void | Promise<any>;
  onPrevious?: () => true | Promise<{}> | void | Promise<any>;
}

export const VoucherStep: React.FC<VoucherStepProps> = ({
  form,
  onVoucherUpdate,
  onNext,
  onPrevious,
}) => {
  const [voucherCode, setVoucherCode] = useState<string>("");
  const [isValidating, setIsValidating] = useState<boolean>(false);

  const handleCodeChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setVoucherCode(e.target.value);
  };

  const handleApplyVoucher = async () => {
    if (!voucherCode.trim()) {
      message.warning("Please enter a voucher code");
      return;
    }

    setIsValidating(true);
    try {
      await onVoucherUpdate(voucherCode);
      form.setFieldsValue({ voucherCode });
      message.success("Voucher applied successfully!");
    } catch (error) {
      message.error("Invalid or expired voucher code");
    } finally {
      setIsValidating(false);
    }
  };

  const handleContinue = () => {
    // Continue to next step even if no voucher is applied
    onNext?.();
  };

  return (
    <div className="space-y-6">
      <Title level={4}>Apply Voucher (Optional)</Title>
      <Text className="text-gray-600 block mb-6">
        If you have a promotional code, enter it below to receive a discount on your order.
      </Text>

      <div className="flex items-end space-x-2 mb-8">
        <Form.Item
          className="flex-grow mb-0"
          name="voucherCode"
          label="Voucher Code"
        >
          <Input
            placeholder="Enter voucher code"
            onChange={handleCodeChange}
            value={voucherCode}
            disabled={isValidating}
          />
        </Form.Item>
        <Button
          type="primary"
          onClick={handleApplyVoucher}
          loading={isValidating}
          className="mb-0"
        >
          Apply
        </Button>
      </div>

      <Space className="flex justify-between mt-8">
        <Button onClick={onPrevious}>Back to Cart</Button>
        <Button type="primary" onClick={handleContinue}>
          Continue to Shipping
        </Button>
      </Space>
    </div>
  );
};
