import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_service.g.dart';
part 'shop_service.freezed.dart';

@freezed
class ShopService with _$ShopService {
  factory ShopService({
    required String id,
    required String shopId,
    required String ownerId,
    required String name,
    required double price,
    required String type,
    String? imageId1,
    String? imageUrl1,
    String? imageId2,
    String? imageUrl2,
    String? imageId3,
    String? imageUrl3,
    String? videoUrl,
    String? description,
    double? rating,
    List<String>? sizes,
    String? bookingNote
  }) = _ShopService;

  factory ShopService.fromJson(Map<String, dynamic> json) =>
      _$ShopServiceFromJson(json);
}
