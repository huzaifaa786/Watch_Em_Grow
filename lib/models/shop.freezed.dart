// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'shop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return _Shop.fromJson(json);
}

/// @nodoc
class _$ShopTearOff {
  const _$ShopTearOff();

  _Shop call(
      {required String id,
      required String ownerId,
      required String name,
      required String category,
      required String fontStyle,
      required int color,
        int isFeatured = 0,
        int isBestSeller = 0,
      String description = '',
      String location = '',
      String borough = '',
      String address = '',
      int ratingCount = 0,
      double rating = 0.0,
      double lowestPrice = 0.0,
      double highestPrice = 0.0,
      bool hasService = false}) {
    return _Shop(
      id: id,
      ownerId: ownerId,
      name: name,
      category: category,
      fontStyle: fontStyle,
      color: color,
      description: description,
      location: location,
      borough: borough,
      address: address,
      ratingCount: ratingCount,
      rating: rating,
      lowestPrice: lowestPrice,
      highestPrice: highestPrice,
      hasService: hasService,
    );
  }

  Shop fromJson(Map<String, Object> json) {
    return Shop.fromJson(json);
  }
}

/// @nodoc
const $Shop = _$ShopTearOff();

/// @nodoc
mixin _$Shop {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get fontStyle => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  int get isFeatured => throw _privateConstructorUsedError;
  int get isBestSeller => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get borough => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  int get ratingCount => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  double get lowestPrice => throw _privateConstructorUsedError;
  double get highestPrice => throw _privateConstructorUsedError;
  bool get hasService => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShopCopyWith<Shop> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopCopyWith<$Res> {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) then) =
      _$ShopCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String ownerId,
      String name,
      String category,
      String fontStyle,
      int color,
      String description,
      String location,
      String borough,
      String address,
      int ratingCount,
      double rating,
      double lowestPrice,
      double highestPrice,
      bool hasService});
}

/// @nodoc
class _$ShopCopyWithImpl<$Res> implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._value, this._then);

  final Shop _value;
  // ignore: unused_field
  final $Res Function(Shop) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? ownerId = freezed,
    Object? name = freezed,
    Object? category = freezed,
    Object? fontStyle = freezed,
    Object? color = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? borough = freezed,
    Object? address = freezed,
    Object? ratingCount = freezed,
    Object? rating = freezed,
    Object? lowestPrice = freezed,
    Object? highestPrice = freezed,
    Object? hasService = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: ownerId == freezed
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      fontStyle: fontStyle == freezed
          ? _value.fontStyle
          : fontStyle // ignore: cast_nullable_to_non_nullable
              as String,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      borough: borough == freezed
          ? _value.borough
          : borough // ignore: cast_nullable_to_non_nullable
              as String,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      ratingCount: ratingCount == freezed
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      rating: rating == freezed
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      lowestPrice: lowestPrice == freezed
          ? _value.lowestPrice
          : lowestPrice // ignore: cast_nullable_to_non_nullable
              as double,
      highestPrice: highestPrice == freezed
          ? _value.highestPrice
          : highestPrice // ignore: cast_nullable_to_non_nullable
              as double,
      hasService: hasService == freezed
          ? _value.hasService
          : hasService // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$ShopCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$ShopCopyWith(_Shop value, $Res Function(_Shop) then) =
      __$ShopCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String ownerId,
      String name,
      String category,
      String fontStyle,
      int color,
      String description,
      String location,
      String borough,
      String address,
      int ratingCount,
      double rating,
      double lowestPrice,
      double highestPrice,
      bool hasService});
}

/// @nodoc
class __$ShopCopyWithImpl<$Res> extends _$ShopCopyWithImpl<$Res>
    implements _$ShopCopyWith<$Res> {
  __$ShopCopyWithImpl(_Shop _value, $Res Function(_Shop) _then)
      : super(_value, (v) => _then(v as _Shop));

  @override
  _Shop get _value => super._value as _Shop;

  @override
  $Res call({
    Object? id = freezed,
    Object? ownerId = freezed,
    Object? name = freezed,
    Object? category = freezed,
    Object? fontStyle = freezed,
    Object? color = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? borough = freezed,
    Object? address = freezed,
    Object? ratingCount = freezed,
    Object? rating = freezed,
    Object? lowestPrice = freezed,
    Object? highestPrice = freezed,
    Object? hasService = freezed,
  }) {
    return _then(_Shop(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: ownerId == freezed
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      fontStyle: fontStyle == freezed
          ? _value.fontStyle
          : fontStyle // ignore: cast_nullable_to_non_nullable
              as String,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      borough: borough == freezed
          ? _value.borough
          : borough // ignore: cast_nullable_to_non_nullable
              as String,
      address: address == freezed
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      ratingCount: ratingCount == freezed
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      rating: rating == freezed
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      lowestPrice: lowestPrice == freezed
          ? _value.lowestPrice
          : lowestPrice // ignore: cast_nullable_to_non_nullable
              as double,
      highestPrice: highestPrice == freezed
          ? _value.highestPrice
          : highestPrice // ignore: cast_nullable_to_non_nullable
              as double,
      hasService: hasService == freezed
          ? _value.hasService
          : hasService // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Shop implements _Shop {
  _$_Shop(
      {required this.id,
      required this.ownerId,
      required this.name,
      required this.category,
      required this.fontStyle,
      required this.color,
        this.isFeatured = 0,
        this.isBestSeller = 0,
      this.description = '',
      this.location = '',
      this.borough = '',
      this.address = '',
      this.ratingCount = 0,
      this.rating = 0.0,
      this.lowestPrice = 0.0,
      this.highestPrice = 0.0,
      this.hasService = false});

  factory _$_Shop.fromJson(Map<String, dynamic> json) =>
      _$_$_ShopFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String name;
  @override
  final String category;
  @override
  final String fontStyle;
  @override
  final int color;
  @override
  final int isFeatured;
  @JsonKey(defaultValue: 0)
  @override
  final int isBestSeller;
  @JsonKey(defaultValue: 0)
  @override
  final String description;
  @JsonKey(defaultValue: '')
  @override
  final String location;
  @JsonKey(defaultValue: '')
  @override
  final String borough;
  @JsonKey(defaultValue: '')
  @override
  final String address;
  @JsonKey(defaultValue: 0)
  @override
  final int ratingCount;
  @JsonKey(defaultValue: 0.0)
  @override
  final double rating;
  @JsonKey(defaultValue: 0.0)
  @override
  final double lowestPrice;
  @JsonKey(defaultValue: 0.0)
  @override
  final double highestPrice;
  @JsonKey(defaultValue: false)
  @override
  final bool hasService;

  @override
  String toString() {
    return 'Shop(id: $id, ownerId: $ownerId, name: $name, category: $category, fontStyle: $fontStyle, color: $color, description: $description, location: $location, borough: $borough, address: $address, ratingCount: $ratingCount, rating: $rating, lowestPrice: $lowestPrice, highestPrice: $highestPrice, hasService: $hasService)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Shop &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.ownerId, ownerId) ||
                const DeepCollectionEquality()
                    .equals(other.ownerId, ownerId)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.category, category) ||
                const DeepCollectionEquality()
                    .equals(other.category, category)) &&
            (identical(other.fontStyle, fontStyle) ||
                const DeepCollectionEquality()
                    .equals(other.fontStyle, fontStyle)) &&
            (identical(other.color, color) ||
                const DeepCollectionEquality().equals(other.color, color)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.location, location) ||
                const DeepCollectionEquality()
                    .equals(other.location, location)) &&
            (identical(other.borough, borough) ||
                const DeepCollectionEquality()
                    .equals(other.borough, borough)) &&
            (identical(other.address, address) ||
                const DeepCollectionEquality()
                    .equals(other.address, address)) &&
            (identical(other.ratingCount, ratingCount) ||
                const DeepCollectionEquality()
                    .equals(other.ratingCount, ratingCount)) &&
            (identical(other.rating, rating) ||
                const DeepCollectionEquality().equals(other.rating, rating)) &&
            (identical(other.lowestPrice, lowestPrice) ||
                const DeepCollectionEquality()
                    .equals(other.lowestPrice, lowestPrice)) &&
            (identical(other.highestPrice, highestPrice) ||
                const DeepCollectionEquality()
                    .equals(other.highestPrice, highestPrice)) &&
            (identical(other.hasService, hasService) ||
                const DeepCollectionEquality()
                    .equals(other.hasService, hasService)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(ownerId) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(category) ^
      const DeepCollectionEquality().hash(fontStyle) ^
      const DeepCollectionEquality().hash(color) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(borough) ^
      const DeepCollectionEquality().hash(address) ^
      const DeepCollectionEquality().hash(ratingCount) ^
      const DeepCollectionEquality().hash(rating) ^
      const DeepCollectionEquality().hash(lowestPrice) ^
      const DeepCollectionEquality().hash(highestPrice) ^
      const DeepCollectionEquality().hash(hasService);

  @JsonKey(ignore: true)
  @override
  _$ShopCopyWith<_Shop> get copyWith =>
      __$ShopCopyWithImpl<_Shop>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ShopToJson(this);
  }
}

abstract class _Shop implements Shop {
  factory _Shop(
      {required String id,
      required String ownerId,
      required String name,
      required String category,
      required String fontStyle,
      required int color,
        int isFeatured,
        int isBestSeller,
      String description,
      String location,
      String borough,
      String address,
      int ratingCount,
      double rating,
      double lowestPrice,
      double highestPrice,
      bool hasService}) = _$_Shop;

  factory _Shop.fromJson(Map<String, dynamic> json) = _$_Shop.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get ownerId => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get category => throw _privateConstructorUsedError;
  @override
  String get fontStyle => throw _privateConstructorUsedError;
  @override
  int get color => throw _privateConstructorUsedError;
  @override
  int get isFeatured => throw _privateConstructorUsedError;
  @override
  int get isBestSeller => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  String get location => throw _privateConstructorUsedError;
  @override
  String get borough => throw _privateConstructorUsedError;
  @override
  String get address => throw _privateConstructorUsedError;
  @override
  int get ratingCount => throw _privateConstructorUsedError;
  @override
  double get rating => throw _privateConstructorUsedError;
  @override
  double get lowestPrice => throw _privateConstructorUsedError;
  @override
  double get highestPrice => throw _privateConstructorUsedError;
  @override
  bool get hasService => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ShopCopyWith<_Shop> get copyWith => throw _privateConstructorUsedError;
}
