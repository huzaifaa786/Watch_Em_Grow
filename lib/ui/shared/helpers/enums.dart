import 'package:json_annotation/json_annotation.dart';

enum AlertType {
  success,
  info,
  warning,
  error,
}

enum NetworkState {
  offline,
  online,
}

enum OrderType {
  @JsonValue(0)
  product,
  @JsonValue(1)
  service
}

enum OrderStatus {
  @JsonValue(0)
  progress,
  @JsonValue(1)
  refunded,
  @JsonValue(2)
  refundRequested,
  @JsonValue(3)
  completed,
  @JsonValue(4)
  bookRequested,
  @JsonValue(5)
  bookApproved,
  @JsonValue(6)
  bookCancelled,
  @JsonValue(7)
  refundCaseOpened,
  @JsonValue(8)
  refundCaseClosed
}

extension OrderStatusExt on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.progress:
        return 'PROGRESS';
      case OrderStatus.refunded:
        return 'REFUNDED';
      case OrderStatus.refundRequested:
        return 'REFUND REQUESTED';
      case OrderStatus.completed:
        return 'COMPLETED';
      case OrderStatus.bookRequested:
        return 'BOOK REQUESTED';
      case OrderStatus.bookApproved:
        return 'BOOK APPROVED';
      case OrderStatus.bookCancelled:
        return 'CANCELLED';
      case OrderStatus.refundCaseOpened:
        return 'REFUND CASE OPENED';
      case OrderStatus.refundCaseClosed:
        return 'REFUND CASE CLOSED';
      default:
        return '';
    }
  }
}
