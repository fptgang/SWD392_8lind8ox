export interface StepBaseProps {
  onNext?: () => true | Promise<{}> | void | Promise<any>;
  onPrevious?: () => true | Promise<{}> | void | Promise<any>;
}

export interface CartSummary {
  itemCount: number;
  subtotal: number;
  savings: number;
  voucherDiscount: number;
  finalTotal: number;
}

// Mock type definitions for generated types
export interface ShippingInfoDto {
  shippingInfoId?: number;
  name: string;
  phoneNumber: string;
  address: string;
  city: string;
  district: string;
  ward: string;
}

export interface VoucherDto {
  voucherId?: number;
  code: string;
  discountRate?: number;
  limitAmount?: number;
  isUsed?: boolean;
} 