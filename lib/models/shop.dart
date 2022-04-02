import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop.freezed.dart';
part 'shop.g.dart';

@freezed
class Shop with _$Shop {
  factory Shop({
    required String id,
    required String ownerId,
    required String name,
    required String category,
    required String fontStyle,
    required int color,
    @Default(0) int isFeatured,
    @Default(0) int isBestSeller,
    @Default('') String description,
    @Default('') String location,
    @Default('') String borough,
    @Default('') String address,
    @Default(0) int ratingCount,
    @Default(0.0) double rating,
    @Default(0.0) double lowestPrice,
    @Default(0.0) double highestPrice,
    @Default(false) bool hasService,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}
