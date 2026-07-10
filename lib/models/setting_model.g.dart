// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

SettingModel _$SettingModelFromJson(Map<String, dynamic> json) => SettingModel(
      id: json['id'] as String?,
      key: json['key'] as String,
      value: json['value'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$SettingModelToJson(SettingModel instance) => <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
    };

import 'package:hive/hive.dart';

class SettingModelAdapter extends TypeAdapter<SettingModel> {
  @override
  final int typeId = 5;

  @override
  SettingModel read(BinaryReader reader) {
    final map = <String, dynamic>{};
    final len = reader.readInt();
    for (var i = 0; i < len; i++) {
      final key = reader.readString();
      final value = reader.read();
      map[key] = value;
    }
    return SettingModel.fromJson(Map<String, dynamic>.from(map));
  }

  @override
  void write(BinaryWriter writer, SettingModel obj) {
    final json = obj.toJson();
    writer.writeInt(json.length);
    json.forEach((key, value) {
      writer.writeString(key);
      writer.write(value);
    });
  }
}
