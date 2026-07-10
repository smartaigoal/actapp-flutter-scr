// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'photo': instance.photo,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastLogin': instance.lastLogin.toIso8601String(),
      'isActive': instance.isActive,
    };

// Hive adapter (minimal)
import 'package:hive/hive.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 6;

  @override
  UserModel read(BinaryReader reader) {
    final map = <String, dynamic>{};
    final len = reader.readInt();
    for (var i = 0; i < len; i++) {
      final key = reader.readString();
      final value = reader.read();
      map[key] = value;
    }
    return UserModel.fromJson(Map<String, dynamic>.from(map));
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    final json = obj.toJson();
    writer.writeInt(json.length);
    json.forEach((key, value) {
      writer.writeString(key);
      writer.write(value);
    });
  }
}
