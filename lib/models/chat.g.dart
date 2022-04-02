// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Chat _$_$_ChatFromJson(Map<String, dynamic> json) {
  return _$_Chat(
    senderId: json['senderId'] as String,
    receiverId: json['receiverId'] as String,
    senderName: json['senderName'] as String,
    recieverName: json['recieverName'] as String,
    message: json['message'] as String,
    read: json['read'] as bool? ?? false,
    createdAt: json['createdAt'] as int,
  );
}

Map<String, dynamic> _$_$_ChatToJson(_$_Chat instance) => <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'senderName': instance.senderName,
      'recieverName': instance.recieverName,
      'message': instance.message,
      'read': instance.read,
      'createdAt': instance.createdAt,
    };
