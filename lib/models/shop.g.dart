// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Shop _$_$_ShopFromJson(Map<String, dynamic> json) {
  return _$_Shop(
    id: json['id'] as String,
    ownerId: json['ownerId'] as String,
    name: json['name'] as String,
    category: json['category'] as String,
    fontStyle: json['fontStyle'] as String,
    color: json['color'] as int,
    isFeatured: json['isFeatured'] as int? ?? 0,
    isBestSeller: json['isBestSeller'] as int? ?? 0,
    description: json['description'] as String? ?? '',
    policy: json['policy'] as String? ?? '',
    location: json['location'] as String? ?? '',
    borough: json['borough'] as String? ?? '',
    address: json['address'] as String? ?? '',
    ratingCount: json['ratingCount'] as int? ?? 0,
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    lowestPrice: (json['lowestPrice'] as num?)?.toDouble() ?? 0.0,
    highestPrice: (json['highestPrice'] as num?)?.toDouble() ?? 0.0,
    hasService: json['hasService'] as bool? ?? false,
  );
}

Map<String, dynamic> _$_$_ShopToJson(_$_Shop instance) => <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'category': instance.category,
      'fontStyle': instance.fontStyle,
      'color': instance.color,
      'isFeatured': instance.isFeatured,
      'isBestSeller': instance.isBestSeller,
      'description': instance.description,
      'policy': instance.policy,
      'location': instance.location,
      'borough': instance.borough,
      'address': instance.address,
      'ratingCount': instance.ratingCount,
      'rating': instance.rating,
      'lowestPrice': instance.lowestPrice,
      'highestPrice': instance.highestPrice,
      'hasService': instance.hasService,
    };
