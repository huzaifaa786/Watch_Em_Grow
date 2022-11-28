import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  factory Order({
    required String orderId,
    String? paymentId,
    String? captureId,
    required OrderType type,
    required MPaymentMethod paymentMethod,
    required String userId,
    required String shopId,
    required ShopService service,
    required int time,
    required OrderStatus status,
    int? bookingStart,
    int? bookingEnd,
    String? name,
    String? address,
    String? postCode,
    int? rate,
    int? selectedSize,
    String? paymentIntent,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
