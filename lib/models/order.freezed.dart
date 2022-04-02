// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
class _$OrderTearOff {
  const _$OrderTearOff();

  _Order call(
      {required String orderId,
      String? paymentId,
      String? captureId,
      required OrderType type,
      required String userId,
      required String shopId,
      required ShopService service,
      required int time,
      required OrderStatus status,
      String? name,
      String? address,
      String? postCode,
      int? rate,
      int? selectedSize}) {
    return _Order(
      orderId: orderId,
      paymentId: paymentId,
      captureId: captureId,
      type: type,
      userId: userId,
      shopId: shopId,
      service: service,
      time: time,
      status: status,
      name: name,
      address: address,
      postCode: postCode,
      rate: rate,
      selectedSize: selectedSize,
    );
  }

  Order fromJson(Map<String, Object> json) {
    return Order.fromJson(json);
  }
}

/// @nodoc
const $Order = _$OrderTearOff();

/// @nodoc
mixin _$Order {
  String get orderId => throw _privateConstructorUsedError;
  String? get paymentId => throw _privateConstructorUsedError;
  String? get captureId => throw _privateConstructorUsedError;
  OrderType get type => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get shopId => throw _privateConstructorUsedError;
  ShopService get service => throw _privateConstructorUsedError;
  int get time => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get postCode => throw _privateConstructorUsedError;
  int? get rate => throw _privateConstructorUsedError;
  int? get selectedSize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res>;
  $Res call(
      {String orderId,
      String? paymentId,
      String? captureId,
      OrderType type,
      String userId,
      String shopId,
      ShopService service,
      int time,
      OrderStatus status,
      String? name,
      String? address,
      String? postCode,
      int? rate,
      int? selectedSize});

  $ShopServiceCopyWith<$Res> get service;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res> implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  final Order _value;
  // ignore: unused_field
  final $Res Function(Order) _then;

  @override
  $Res call({
    Object? orderId = freezed,
    Object? paymentId = freezed,
    Object? captureId = freezed,
    Object? type = freezed,
    Object? userId = freezed,
    Object? shopId = freezed,
    Object? service = freezed,
    Object? time = freezed,
    Object? status = freezed,
    Object? name = freezed,
    Object? address = freezed,
    Object? postCode = freezed,
    Object? rate = freezed,
    Object? selectedSize = freezed,
  }) {
    return _then(_value.copyWith(
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: paymentId == freezed
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      captureId: captureId == freezed
          ? _value.captureId
          : captureId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OrderType,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: shopId == freezed
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      service: service == freezed
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ShopService,
      time: time == freezed
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      postCode: postCode == freezed
          ? _value.postCode
          : postCode // ignore: cast_nullable_to_non_nullable
              as String?,
      rate: rate == freezed
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedSize: selectedSize == freezed
          ? _value.selectedSize
          : selectedSize // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  @override
  $ShopServiceCopyWith<$Res> get service {
    return $ShopServiceCopyWith<$Res>(_value.service, (value) {
      return _then(_value.copyWith(service: value));
    });
  }
}

/// @nodoc
abstract class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) then) =
      __$OrderCopyWithImpl<$Res>;
  @override
  $Res call(
      {String orderId,
      String? paymentId,
      String? captureId,
      OrderType type,
      String userId,
      String shopId,
      ShopService service,
      int time,
      OrderStatus status,
      String? name,
      String? address,
      String? postCode,
      int? rate,
      int? selectedSize});

  @override
  $ShopServiceCopyWith<$Res> get service;
}

/// @nodoc
class __$OrderCopyWithImpl<$Res> extends _$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(_Order _value, $Res Function(_Order) _then)
      : super(_value, (v) => _then(v as _Order));

  @override
  _Order get _value => super._value as _Order;

  @override
  $Res call({
    Object? orderId = freezed,
    Object? paymentId = freezed,
    Object? captureId = freezed,
    Object? type = freezed,
    Object? userId = freezed,
    Object? shopId = freezed,
    Object? service = freezed,
    Object? time = freezed,
    Object? status = freezed,
    Object? name = freezed,
    Object? address = freezed,
    Object? postCode = freezed,
    Object? rate = freezed,
    Object? selectedSize = freezed,
  }) {
    return _then(_Order(
      orderId: orderId == freezed
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: paymentId == freezed
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      captureId: captureId == freezed
          ? _value.captureId
          : captureId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OrderType,
      userId: userId == freezed
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: shopId == freezed
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      service: service == freezed
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as ShopService,
      time: time == freezed
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      postCode: postCode == freezed
          ? _value.postCode
          : postCode // ignore: cast_nullable_to_non_nullable
              as String?,
      rate: rate == freezed
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedSize: selectedSize == freezed
          ? _value.selectedSize
          : selectedSize // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Order implements _Order {
  _$_Order(
      {required this.orderId,
      this.paymentId,
      this.captureId,
      required this.type,
      required this.userId,
      required this.shopId,
      required this.service,
      required this.time,
      required this.status,
      this.name,
      this.address,
      this.postCode,
      this.rate,
      this.selectedSize});

  factory _$_Order.fromJson(Map<String, dynamic> json) =>
      _$_$_OrderFromJson(json);

  @override
  final String orderId;
  @override
  final String? paymentId;
  @override
  final String? captureId;
  @override
  final OrderType type;
  @override
  final String userId;
  @override
  final String shopId;
  @override
  final ShopService service;
  @override
  final int time;
  @override
  final OrderStatus status;
  @override
  final String? name;
  @override
  final String? address;
  @override
  final String? postCode;
  @override
  final int? rate;
  @override
  final int? selectedSize;

  @override
  String toString() {
    return 'Order(orderId: $orderId, paymentId: $paymentId, captureId: $captureId, type: $type, userId: $userId, shopId: $shopId, service: $service, time: $time, status: $status, name: $name, address: $address, postCode: $postCode, rate: $rate, selectedSize: $selectedSize)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Order &&
            (identical(other.orderId, orderId) ||
                const DeepCollectionEquality()
                    .equals(other.orderId, orderId)) &&
            (identical(other.paymentId, paymentId) ||
                const DeepCollectionEquality()
                    .equals(other.paymentId, paymentId)) &&
            (identical(other.captureId, captureId) ||
                const DeepCollectionEquality()
                    .equals(other.captureId, captureId)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.shopId, shopId) ||
                const DeepCollectionEquality().equals(other.shopId, shopId)) &&
            (identical(other.service, service) ||
                const DeepCollectionEquality()
                    .equals(other.service, service)) &&
            (identical(other.time, time) ||
                const DeepCollectionEquality().equals(other.time, time)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.address, address) ||
                const DeepCollectionEquality()
                    .equals(other.address, address)) &&
            (identical(other.postCode, postCode) ||
                const DeepCollectionEquality()
                    .equals(other.postCode, postCode)) &&
            (identical(other.rate, rate) ||
                const DeepCollectionEquality().equals(other.rate, rate)) &&
            (identical(other.selectedSize, selectedSize) ||
                const DeepCollectionEquality()
                    .equals(other.selectedSize, selectedSize)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(orderId) ^
      const DeepCollectionEquality().hash(paymentId) ^
      const DeepCollectionEquality().hash(captureId) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(shopId) ^
      const DeepCollectionEquality().hash(service) ^
      const DeepCollectionEquality().hash(time) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(address) ^
      const DeepCollectionEquality().hash(postCode) ^
      const DeepCollectionEquality().hash(rate) ^
      const DeepCollectionEquality().hash(selectedSize);

  @JsonKey(ignore: true)
  @override
  _$OrderCopyWith<_Order> get copyWith =>
      __$OrderCopyWithImpl<_Order>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_OrderToJson(this);
  }
}

abstract class _Order implements Order {
  factory _Order(
      {required String orderId,
      String? paymentId,
      String? captureId,
      required OrderType type,
      required String userId,
      required String shopId,
      required ShopService service,
      required int time,
      required OrderStatus status,
      String? name,
      String? address,
      String? postCode,
      int? rate,
      int? selectedSize}) = _$_Order;

  factory _Order.fromJson(Map<String, dynamic> json) = _$_Order.fromJson;

  @override
  String get orderId => throw _privateConstructorUsedError;
  @override
  String? get paymentId => throw _privateConstructorUsedError;
  @override
  String? get captureId => throw _privateConstructorUsedError;
  @override
  OrderType get type => throw _privateConstructorUsedError;
  @override
  String get userId => throw _privateConstructorUsedError;
  @override
  String get shopId => throw _privateConstructorUsedError;
  @override
  ShopService get service => throw _privateConstructorUsedError;
  @override
  int get time => throw _privateConstructorUsedError;
  @override
  OrderStatus get status => throw _privateConstructorUsedError;
  @override
  String? get name => throw _privateConstructorUsedError;
  @override
  String? get address => throw _privateConstructorUsedError;
  @override
  String? get postCode => throw _privateConstructorUsedError;
  @override
  int? get rate => throw _privateConstructorUsedError;
  @override
  int? get selectedSize => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$OrderCopyWith<_Order> get copyWith => throw _privateConstructorUsedError;
}
