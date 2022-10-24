// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookkingService _$BookkingServiceFromJson(Map<String, dynamic> json) {
  return BookkingService(
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
    depositAmount: json['depositAmount'] as int?,
    serviceId: json['serviceId'] as String?,
  );
}

Map<String, dynamic> _$BookkingServiceToJson(BookkingService instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'placeId': instance.placeId,
      'serviceName': instance.serviceName,
      'serviceId': instance.serviceId,
      'serviceDuration': instance.serviceDuration,
      'servicePrice': instance.servicePrice,
      'depositAmount': instance.depositAmount,
      'bookingStart': BookingUtil.dateTimeToTimeStamp(instance.bookingStart),
      'bookingEnd': BookingUtil.dateTimeToTimeStamp(instance.bookingEnd),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'placeAddress': instance.placeAddress,
    };
