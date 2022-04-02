// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppUser _$_$_AppUserFromJson(Map<String, dynamic> json) {
  return _$_AppUser(
    id: json['id'] as String,
    email: json['email'] as String?,
    token: json['token'] as String?,
    userType: json['userType'] as String? ?? 'buyer',
    shopId: json['shopId'] as String? ?? '',
    referCode: json['referCode'] as String?,
    username: json['username'] as String? ?? '',
    fullName: json['fullName'] as String? ?? '',
    phoneNumber: json['phoneNumber'] as String? ?? '',
    gender: json['gender'] as String? ?? '',
    dateOfBirth: json['dateOfBirth'] as String? ?? '',
    followers: json['followers'] as int? ?? 0,
    following: json['following'] as int? ?? 0,
    imageId: json['imageId'] as String? ?? '',
    imageUrl: json['imageUrl'] as String? ?? '',
    purchases: json['purchases'] as int? ?? 0,
    referrals: json['referrals'] as int? ?? 0,
    earnByRef: (json['earnByRef'] as num?)?.toDouble() ?? 0.0,
    earnBySell: (json['earnBySell'] as num?)?.toDouble() ?? 0.0,
    address: json['address'] as String? ?? '',
    postCode: json['postCode'] as String? ?? '',
    chatIds:
        (json['chatIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$_$_AppUserToJson(_$_AppUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'token': instance.token,
      'userType': instance.userType,
      'shopId': instance.shopId,
      'referCode': instance.referCode,
      'username': instance.username,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'followers': instance.followers,
      'following': instance.following,
      'imageId': instance.imageId,
      'imageUrl': instance.imageUrl,
      'purchases': instance.purchases,
      'referrals': instance.referrals,
      'earnByRef': instance.earnByRef,
      'earnBySell': instance.earnBySell,
      'address': instance.address,
      'postCode': instance.postCode,
      'chatIds': instance.chatIds,
    };
