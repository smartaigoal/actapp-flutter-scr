// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) => NotificationModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'read': instance.read,
      'createdAt': instance.createdAt.toIso8601String(),
    };

// Hive adapter (minimal)
import 'package:hive/hive.dart';

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 7;

  @override
  NotificationModel read(BinaryReader reader) {
    final map = <String, dynamic>{};
    final len = reader.readInt();
    for (var i = 0; i < len; i++) {
      final key = reader.readString();
      final value = reader.read();
      map[key] = value;
    }
    return NotificationModel.fromJson(Map<String, dynamic>.from(map));
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    final json = obj.toJson();
    writer.writeInt(json.length);
    json.forEach((key, value) {
      writer.writeString(key);
      writer.write(value);
    });
  }
}
