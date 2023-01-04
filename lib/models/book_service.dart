import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mipromo/ui/service/booking_util.dart';
part 'book_service.g.dart';

@JsonSerializable(explicitToJson: true)
class BookkingService {
  /// The generated code assumes these values exist in JSON.
  final String? id;
  final String? userId;
  final String? ownerId;
  final String? userName;
  final String? placeId;
  final String? serviceName;
  final String? serviceId;
  final int? serviceDuration;
  final int? servicePrice;
  final List? extraServ;
  final int? extraServPrice;
  final double?  depositAmount;
  @Default(false) bool? approved;

  //Because we are storing timestamp in Firestore, we need a converter for DateTime
  /* static DateTime timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now()); //To TimeStamp
  }*/
  @JsonKey(
      fromJson: BookingUtil.timeStampToDateTime,
      toJson: BookingUtil.dateTimeToTimeStamp)
  final DateTime? bookingStart;
  @JsonKey(
      fromJson: BookingUtil.timeStampToDateTime,
      toJson: BookingUtil.dateTimeToTimeStamp)
  final DateTime? bookingEnd;
  final String? email;
  final String? phoneNumber;
  final String? placeAddress;

  BookkingService(
      {
      this.id,
      this.email,
      this.phoneNumber,
      this.placeAddress,
      this.bookingStart,
      this.bookingEnd,
      this.placeId,
      this.userId,
      this.ownerId,
      this.userName,
      this.serviceName,
      this.approved,
      this.extraServ,
      this.extraServPrice,
      this.serviceDuration,
      this.servicePrice,
      this.depositAmount,
      this.serviceId});

  /// Connect the generated [_$SportBookingFromJson] function to the `fromJson`
  /// factory.
  factory BookkingService.fromJson(Map<String, dynamic> json) =>
      _$BookkingServiceFromJson(json);

  /// Connect the generated [_$SportBookingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BookkingServiceToJson(this);
}
