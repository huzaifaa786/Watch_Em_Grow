// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Notification _$_$_NotificationFromJson(Map<String, dynamic> json) {
  return _$_Notification(
    title: json['title'] as String,
    body: json['body'] as String,
    sound: json['orderId'] != null ? json['orderId'] : json['userId'] as String,
    time: json['time'] as int,
    id: json['id'] as int,
    read: json['read'] as bool,
  );
}

Map<String, dynamic> _$_$_NotificationToJson(_$_Notification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'sound': instance.sound,
      'time': instance.time,
      'id': instance.id,
      'read': instance.read,
    };
