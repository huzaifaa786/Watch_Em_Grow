// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Order _$_$_OrderFromJson(Map<String, dynamic> json) {
  return _$_Order(
    orderId: json['orderId'] as String,
    paymentId: json['paymentId'] as String?,
    captureId: json['captureId'] as String?,
    bookkingId: json['bookkingId'] as String?,
    type: _$enumDecode(_$OrderTypeEnumMap, json['type']),
    paymentMethod: _$enumDecode(_$MPaymentMethodEnumMap, json['paymentMethod']),
    userId: json['userId'] as String,
    shopId: json['shopId'] as String,
    service: ShopService.fromJson(json['service'] as Map<String, dynamic>),
    time: json['time'] as int,
    status: _$enumDecode(_$OrderStatusEnumMap, json['status']),
    bookingStart: json['bookingStart'] as int?,
    bookingEnd: json['bookingEnd'] as int?,
    name: json['name'] as String?,
    address: json['address'] as String?,
    paymentIntent: json['paymentIntent'] as String?,
    postCode: json['postCode'] as String?,
    rate: json['rate'] as int?,
    selectedSize: json['selectedSize'] as int?,
  );
}

Map<String, dynamic> _$_$_OrderToJson(_$_Order instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'paymentId': instance.paymentId,
      'captureId': instance.captureId,
      'bookkingId': instance.bookkingId,
      'type': _$OrderTypeEnumMap[instance.type],
      'paymentMethod': _$MPaymentMethodEnumMap[instance.paymentMethod],
      'userId': instance.userId,
      'shopId': instance.shopId,
      'service': instance.service.toJson(),
      'time': instance.time,
      'status': _$OrderStatusEnumMap[instance.status],
      'bookingStart': instance.bookingStart,
      'bookingEnd': instance.bookingEnd,
      'name': instance.name,
      'address': instance.address,
      'paymentIntent': instance.paymentIntent,
      'postCode': instance.postCode,
      'rate': instance.rate,
      'selectedSize': instance.selectedSize,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$OrderTypeEnumMap = {
  OrderType.product: 0,
  OrderType.service: 1,
};

const _$MPaymentMethodEnumMap = {
  MPaymentMethod.stripe: 0,
  MPaymentMethod.paypal: 1,
};

const _$OrderStatusEnumMap = {
  OrderStatus.progress: 0,
  OrderStatus.refunded: 1,
  OrderStatus.refundRequested: 2,
  OrderStatus.completed: 3,
  OrderStatus.bookRequested: 4,
  OrderStatus.bookApproved: 5,
  OrderStatus.bookCancelled: 6,
  OrderStatus.refundCaseOpened: 7,
  OrderStatus.refundCaseClosed: 8,
};
