// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookkingService _$BookkingServiceFromJson(Map<String, dynamic> json) {
  return BookkingService(
    id: json['id'] as String?,
    email: json['email'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    placeAddress: json['placeAddress'] as String?,
    bookingStart:
        BookingUtil.timeStampToDateTime(json['bookingStart'] as Timestamp),
    bookingEnd:
        BookingUtil.timeStampToDateTime(json['bookingEnd'] as Timestamp),
    placeId: json['placeId'] as String?,
    userId: json['userId'] as String?,
    userName: json['userName'] as String?,
    serviceName: json['serviceName'] as String?,
    serviceDuration: json['serviceDuration'] as int?,
    servicePrice: json['servicePrice'] as int?,
    depositAmount: json['depositAmount'] as double?,
    totalAmount: json['totalAmount'] as double?,
    approved: json['approved'] as bool? ?? false,
    serviceId: json['serviceId'] as String?,
    extraServ : json['extraServ'] as List?,
  );
}

Map<String, dynamic> _$BookkingServiceToJson(BookkingService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'placeId': instance.placeId,
      'serviceName': instance.serviceName,
      'approved': instance.approved,
      'serviceId': instance.serviceId,
      'serviceDuration': instance.serviceDuration,
      'servicePrice': instance.servicePrice,
      'extraServ': instance.extraServ?.map((e) => e.toJson()).toList(),
      'depositAmount': instance.depositAmount,
      'totalAmount': instance.totalAmount,
      'bookingStart': BookingUtil.dateTimeToTimeStamp(instance.bookingStart),
      'bookingEnd': BookingUtil.dateTimeToTimeStamp(instance.bookingEnd),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'placeAddress': instance.placeAddress,
    };
