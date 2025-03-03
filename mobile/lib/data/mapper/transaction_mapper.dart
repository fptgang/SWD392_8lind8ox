import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

class TransactionMapper {
  static TransactionModel toModel(TransactionDto dto) {
    return TransactionModel(
      transactionId: dto.transactionId!,
      accountId: dto.accountId!,
      type: _mapDtoType(dto.type!),
      paymentMethod: _mapDtoPaymentMethod(dto.paymentMethod!),
      createdAt: dto.createAt!,
      amount: dto.amount!,
      oldBalance: dto.oldBalance!,
      newBalance: dto.newBalance!,
      orderId: dto.orderId!,
      success: dto.status == TransactionDtoStatusEnum.SUCCESS,
    );
  }

  static TransactionType _mapDtoType(TransactionDtoTypeEnum dtoType) {
    switch (dtoType) {
      case TransactionDtoTypeEnum.DEPOSIT:
        return TransactionType.DEPOSIT;
      case TransactionDtoTypeEnum.ORDER:
        return TransactionType.ORDER;
      default:
        throw Exception('Unknown transaction type: $dtoType');
    }
  }

  static PaymentMethod _mapDtoPaymentMethod(
      TransactionDtoPaymentMethodEnum dtoMethod) {
    switch (dtoMethod) {
      case TransactionDtoPaymentMethodEnum.PAYPAL:
        return PaymentMethod.PAYPAL;
      case TransactionDtoPaymentMethodEnum.VNPAY:
        return PaymentMethod.VNPAY;
      default:
        throw Exception('Unknown payment method: $dtoMethod');
    }
  }
}
