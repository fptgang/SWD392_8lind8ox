abstract class VoucherEvent {}

class SelectVoucher extends VoucherEvent {
  final String vouchers;

  SelectVoucher(this.vouchers);
}

class GetVouchers extends VoucherEvent {}

class GetVoucherById extends VoucherEvent {
  final int id;

  GetVoucherById(this.id);
}