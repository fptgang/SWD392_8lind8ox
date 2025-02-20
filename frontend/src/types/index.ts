// types/index.ts
import { ShippingInfoDto } from "../../generated";

export interface CartSummary {
  itemCount: number;
  subtotal: number;
  savings: number;
  voucherDiscount: number;
  finalTotal: number;
}

export interface StepBaseProps {
  onPrevious?: () => void;
  onNext?: () => void;
}

export interface CheckoutFormData {
  voucherCode?: string;
  shippingInfo: ShippingInfoDto;
}
