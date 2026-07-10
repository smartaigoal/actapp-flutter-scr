import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String? id;
  final String name;
  final String phone;
  final String photo;
  final String? email;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;

  const UserModel({
    this.id,
    required this.name,
    required this.phone,
    required this.photo,
    this.email,
    required this.createdAt,
    required this.lastLogin,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson(data).copyWith(id: doc.id);
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? photo,
    String? email,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, photo, email, createdAt, lastLogin, isActive];
}
