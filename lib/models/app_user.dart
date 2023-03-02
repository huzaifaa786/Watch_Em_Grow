import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  factory AppUser({
    required String id,
    String? email,
    required String? token,
    @Default('buyer') String userType,
    @Default('') String shopId,
    String? referCode,
    @Default('') String username,
    @Default('') String fullName,
    @Default('') String phoneNumber,
    @Default('') String gender,
    @Default('') String dateOfBirth,
    @Default(0) int followers,
    @Default(0) int following,
    @Default('') String imageId,
    @Default('') String imageUrl,
    @Default(0) int skip,
    @Default(0) int purchases,
    @Default(0) int referrals,
    @Default(0.0) double earnByRef,
    @Default(0.0) double earnBySell,
    @Default('') String address,
    @Default('') String postCode,
    @Default(false) bool isPremium,
    List<String>? chatIds,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
