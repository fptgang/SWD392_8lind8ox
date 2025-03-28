import 'package:mobile/data/mapper/account_mapper.dart';
import 'package:mobile/data/models/account_model.dart';
import 'package:mobile/data/models/transaction_model.dart';
import 'package:mobile/utils/enum/enum.dart';
import 'package:openapi/api.dart';

class TransactionMapper {
  static TransactionModel toModel(TransactionDto? dto) {
    if (dto == null) {
      return TransactionModel(
        transactionId: null,
        account: null,
        type: TransactionType.ORDER,
        paymentMethod: PaymentMethod.INTERNAL_WALLET,
        createdAt: DateTime.now(),
        amount: 0,
        oldBalance: 0,
        newBalance: 0,
        orderId: null,
        status: TransactionStatusEnum.PENDING,
      );
    }

    return TransactionModel(
      transactionId: dto.transactionId,
      account: dto.account != null ? AccountMapper.toModel(dto.account!) : null,
      type: _mapDtoType(dto.type ?? TransactionDtoTypeEnum.ORDER),
      paymentMethod: _mapDtoPaymentMethod(dto.paymentMethod ?? TransactionDtoPaymentMethodEnum.INTERNAL_WALLET),
      createdAt: dto.createdAt ?? DateTime.now(),
      amount: dto.amount ?? 0,
      oldBalance: dto.oldBalance ?? 0,
      newBalance: dto.newBalance ?? 0,
      orderId: dto.orderId,
      status: _mapDtoStatus(dto.status ?? TransactionDtoStatusEnum.PENDING),
    );
  }

  static TransactionType _mapDtoType(TransactionDtoTypeEnum dtoType) {
    switch (dtoType) {
      case TransactionDtoTypeEnum.DEPOSIT:
        return TransactionType.DEPOSIT;
      case TransactionDtoTypeEnum.ORDER:
        return TransactionType.ORDER;
      default:
        return TransactionType.ORDER;
    }
  }

  static PaymentMethod _mapDtoPaymentMethod(TransactionDtoPaymentMethodEnum dtoMethod) {
    switch (dtoMethod) {
      case TransactionDtoPaymentMethodEnum.PAYPAL:
        return PaymentMethod.PAYPAL;
      case TransactionDtoPaymentMethodEnum.VNPAY:
        return PaymentMethod.VNPAY;
      case TransactionDtoPaymentMethodEnum.INTERNAL_WALLET:
        return PaymentMethod.INTERNAL_WALLET;
      default:
        return PaymentMethod.INTERNAL_WALLET;
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
        return TransactionStatusEnum.PENDING;
    }
  }

  static TransactionDto toDto(TransactionModel? model) {
    if (model == null) {
      return TransactionDto(
        transactionId: null,
        account: null,
        type: TransactionDtoTypeEnum.ORDER,
        paymentMethod: TransactionDtoPaymentMethodEnum.INTERNAL_WALLET,
        createdAt: DateTime.now(),
        amount: 0,
        oldBalance: 0,
        newBalance: 0,
        orderId: null,
        status: TransactionDtoStatusEnum.PENDING,
      );
    }

    return TransactionDto(
      transactionId: model.transactionId,
      account: model.account != null ? AccountMapper.toDto(model.account!) : null,
      type: _mapModelType(model.type ?? TransactionType.ORDER),
      paymentMethod: _mapModelPaymentMethod(model.paymentMethod ?? PaymentMethod.INTERNAL_WALLET),
      createdAt: model.createdAt ?? DateTime.now(),

      amount: model.amount ?? 0,
      oldBalance: model.oldBalance ?? 0,
      newBalance: model.newBalance ?? 0,
      orderId: model.orderId,
      status: _mapModelStatus(model.status ?? TransactionStatusEnum.PENDING),
    );
  }

  static TransactionDtoTypeEnum _mapModelType(TransactionType modelType) {
    switch (modelType) {
      case TransactionType.DEPOSIT:
        return TransactionDtoTypeEnum.DEPOSIT;
      case TransactionType.ORDER:
        return TransactionDtoTypeEnum.ORDER;
      default:
        return TransactionDtoTypeEnum.ORDER;
    }
  }

  static TransactionDtoPaymentMethodEnum _mapModelPaymentMethod(PaymentMethod modelMethod) {
    switch (modelMethod) {
      case PaymentMethod.PAYPAL:
        return TransactionDtoPaymentMethodEnum.PAYPAL;
      case PaymentMethod.VNPAY:
        return TransactionDtoPaymentMethodEnum.VNPAY;
      case PaymentMethod.INTERNAL_WALLET:
        return TransactionDtoPaymentMethodEnum.INTERNAL_WALLET;
      default:
        return TransactionDtoPaymentMethodEnum.INTERNAL_WALLET;
    }
  }

  static TransactionDtoStatusEnum _mapModelStatus(TransactionStatusEnum model) {
    switch (model) {
      case TransactionStatusEnum.PENDING:
        return TransactionDtoStatusEnum.PENDING;
      case TransactionStatusEnum.SUCCESS:
        return TransactionDtoStatusEnum.SUCCESS;
      case TransactionStatusEnum.FAILED:
        return TransactionDtoStatusEnum.FAILED;
      default:
        return TransactionDtoStatusEnum.PENDING;
    }
  }
}

