import 'package:mobile/data/mapper/account_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/enum/enum.dart';
import 'package:openapi/api.dart';

class TransactionMapper {
  static TransactionModel toModel(TransactionDto dto) {
    return TransactionModel(
      transactionId: dto.transactionId!,
      account: AccountMapper.toModel(dto.account ?? AccountDto()),
      type: _mapDtoType(dto.type!),
      paymentMethod: _mapDtoPaymentMethod(dto.paymentMethod!),
      createdAt: dto.createdAt!,
      amount: dto.amount!,
      oldBalance: dto.oldBalance!,
      newBalance: dto.newBalance!,
      orderId: dto.orderId!,
      status: _mapDtoStatus(dto.status ?? TransactionDtoStatusEnum.PENDING)
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

  static TransactionStatusEnum _mapDtoStatus(TransactionDtoStatusEnum dto) {
    switch (dto) {
      case TransactionDtoStatusEnum.PENDING:
        return TransactionStatusEnum.PENDING;
      case TransactionDtoStatusEnum.SUCCESS:
        return TransactionStatusEnum.SUCCESS;
      case TransactionDtoStatusEnum.FAILED:
        return TransactionStatusEnum.FAILED;
      default:
        throw Exception('Unknown transaction type: $dto');
    }
  }

  static TransactionDto toDto(TransactionModel model) {
    return TransactionDto(
      transactionId: model.transactionId!,
      account: AccountMapper.toDto(model.account ?? AccountModel()),
      type: _mapModelType(model.type!),
      paymentMethod: _mapModelPaymentMethod(model.paymentMethod!),
      createdAt: model.createdAt!,
      amount: model.amount!,
      oldBalance: model.oldBalance!,
      newBalance: model.newBalance!,
      orderId: model.orderId!,
      status: _mapModelStatus(model.status ?? TransactionStatusEnum.PENDING)
    );
  }

  static TransactionDtoTypeEnum _mapModelType(TransactionType dtoType) {
    switch (dtoType) {
      case TransactionType.DEPOSIT:
        return TransactionDtoTypeEnum.DEPOSIT;
      case TransactionType.ORDER:
        return TransactionDtoTypeEnum.ORDER;
      }
  }

  static TransactionDtoPaymentMethodEnum _mapModelPaymentMethod(
      PaymentMethod dtoMethod) {
    switch (dtoMethod) {
      case PaymentMethod.PAYPAL:
        return TransactionDtoPaymentMethodEnum.PAYPAL;
      case PaymentMethod.VNPAY:
        return TransactionDtoPaymentMethodEnum.VNPAY;
      }
  }

  static TransactionDtoStatusEnum _mapModelStatus(TransactionStatusEnum dto) {
    switch (dto) {
      case TransactionStatusEnum.PENDING:
        return TransactionDtoStatusEnum.PENDING;
      case TransactionStatusEnum.SUCCESS:
        return TransactionDtoStatusEnum.SUCCESS;
      case TransactionStatusEnum.FAILED:
        return TransactionDtoStatusEnum.FAILED;
      default:
        throw Exception('Unknown transaction type: $dto');
    }
  }
}
