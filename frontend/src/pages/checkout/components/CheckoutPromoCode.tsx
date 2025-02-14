// components/CheckoutPromoCode.tsx
import React, { useState } from "react";
import { Card, Input, Button, Typography, Space } from "antd";

const { Text } = Typography;

interface CheckoutPromoCodeProps {
  onValidate: (code: string) => Promise<boolean>;
  setDiscount: (discount: number) => void;
}

export const CheckoutPromoCode: React.FC<CheckoutPromoCodeProps> = ({
  onValidate,
  setDiscount,
}) => {
  const [promoCode, setPromoCode] = useState<string>("");
  const [error, setError] = useState<string>("");
  const [isValidating, setIsValidating] = useState(false);

  const handleValidation = async () => {
    if (!promoCode) {
      setError("Please enter a promotion code");
      return;
    }

    setIsValidating(true);
    try {
      const isValid = await onValidate(promoCode);
      if (!isValid) {
        setError("Invalid promotion code");
        setDiscount(0);
      } else {
        setError("");
      }
    } catch (error) {
      setError("Error validating promotion code");
      setDiscount(0);
    } finally {
      setIsValidating(false);
    }
  };

  return (
    <Card title="Promotion Code" className="shadow-sm">
      <Space className="w-full">
        <Input
          placeholder="Enter promotion code"
          value={promoCode}
          onChange={(e) => setPromoCode(e.target.value)}
          className="max-w-xs"
        />
        <Button
          type="primary"
          onClick={handleValidation}
          loading={isValidating}
        >
          Apply
        </Button>
      </Space>
      {error && (
        <Text type="danger" className="block mt-2">
          {error}
        </Text>
      )}
    </Card>
  );
};
