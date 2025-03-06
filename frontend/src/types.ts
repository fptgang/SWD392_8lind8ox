import { FormInstance } from "antd/lib";

export interface StepBaseProps {
  onPrevious?: () => void | Promise<any>;
  onNext?: () => void | Promise<any>;
}

export interface CartSummary {
  itemCount: number;
  subtotal: number;
  savings: number;
  voucherDiscount: number;
  finalTotal: number;
} 