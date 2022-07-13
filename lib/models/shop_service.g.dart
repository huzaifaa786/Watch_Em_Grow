// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ShopService _$_$_ShopServiceFromJson(Map<String, dynamic> json) {
  return _$_ShopService(
    id: json['id'] as String,
    shopId: json['shopId'] as String,
    ownerId: json['ownerId'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    type: json['type'] as String,
    time: json['time'] as int?,
    duration: json['duration'] as int?,
    startHour: json['startHour'] as int?,
    endHour: json['endHour'] as int?,
    imageId1: json['imageId1'] as String?,
    imageUrl1: json['imageUrl1'] as String?,
    imageId2: json['imageId2'] as String?,
    imageUrl2: json['imageUrl2'] as String?,
    imageId3: json['imageId3'] as String?,
    imageUrl3: json['imageUrl3'] as String?,
    videoUrl: json['videoUrl'] as String?,
    description: json['description'] as String?,
    rating: (json['rating'] as num?)?.toDouble(),
    sizes: (json['sizes'] as List<dynamic>?)?.map((e) => e as String).toList(),
    bookingNote: json['bookingNote'] as String?,
  );
}

Map<String, dynamic> _$_$_ShopServiceToJson(_$_ShopService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopId': instance.shopId,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'price': instance.price,
      'type': instance.type,
      'time': instance.time,
      'duration': instance.duration,
      'startHour': instance.startHour,
      'endHour': instance.endHour,
      'imageId1': instance.imageId1,
      'imageUrl1': instance.imageUrl1,
      'imageId2': instance.imageId2,
      'imageUrl2': instance.imageUrl2,
      'imageId3': instance.imageId3,
      'imageUrl3': instance.imageUrl3,
      'videoUrl': instance.videoUrl,
      'description': instance.description,
      'rating': instance.rating,
      'sizes': instance.sizes,
      'bookingNote': instance.bookingNote,
    };
