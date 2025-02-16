// import 'package:openapi/api.dart';
//
// class OrderStatusMapper {
//   static OrderStatusHistoryEnum toModel(OrderDtoStatusEnum dto) {
//     switch(dto) {
//       case OrderDtoStatusEnum.CREATED:
//         return OrderStatusHistoryEnum.CREATED;
//       case OrderDtoStatusEnum.PAID:
//         return OrderStatusHistoryEnum.PAID;
//       case OrderDtoStatusEnum.PACKAGED:
//         return OrderStatusHistoryEnum.PACKAGED;
//       case OrderDtoStatusEnum.SHIPPED:
//         return OrderStatusHistoryEnum.SHIPPED;
//       case OrderDtoStatusEnum.DELIVERED:
//         return OrderStatusHistoryEnum.DELIVERED;
//       case OrderDtoStatusEnum.CANCELLED:
//         return OrderStatusHistoryEnum.CANCELLED;
//       default:
//         return OrderStatusHistoryEnum.CREATED;
//     }
//   }
//
//   static OrderStatusHistoryEnum toModel(OrderStatusHistoryDtoStateEnum dto) {
//     switch(dto) {
//       case OrderStatusHistoryDtoStateEnum.CREATED:
//         return OrderStatusHistoryEnum.CREATED;
//       case OrderStatusHistoryDtoStateEnum.PAID:
//         return OrderStatusHistoryEnum.PAID;
//       case OrderStatusHistoryDtoStateEnum.PACKAGED:
//         return OrderStatusHistoryEnum.PACKAGED;
//       case OrderStatusHistoryDtoStateEnum.SHIPPED:
//         return OrderStatusHistoryEnum.SHIPPED;
//       case OrderStatusHistoryDtoStateEnum.DELIVERED:
//         return OrderStatusHistoryEnum.DELIVERED;
//       case OrderStatusHistoryDtoStateEnum.CANCELLED:
//         return OrderStatusHistoryEnum.CANCELLED;
//       default:
//         return OrderStatusHistoryEnum.CREATED;
//     }
//   }
// }