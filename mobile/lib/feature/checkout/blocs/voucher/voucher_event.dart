abstract class VoucherEvent {}

class SelectVoucher extends VoucherEvent {
  final String vouchers;

  SelectVoucher(this.vouchers);
}

class GetVouchers extends VoucherEvent {
  final int pageKey;

  GetVouchers(this.pageKey);
}

class GetVoucherById extends VoucherEvent {
  final int id;

  GetVoucherById(this.id);
}
class GetVoucherByCode extends VoucherEvent {
  // final String code;
  final int id;

  // GetVoucherByCode(this.code);
  GetVoucherByCode(this.id);
}