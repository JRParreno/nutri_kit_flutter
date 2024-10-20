import 'dart:convert';

import 'package:nutri_kit/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.pk,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.profilePk,
    required super.age,
    super.profilePhoto,
  });

  factory UserModel.empty() {
    return UserModel(
      pk: '',
      username: '',
      firstName: '',
      lastName: '',
      email: '',
      profilePk: '',
      age: -1,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pk': pk,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profilePk': profilePk,
      'profilePhoto': profilePhoto,
      'age': age,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      pk: map['pk'] as String,
      username: map['username'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      profilePk: map['profilePk'] as String,
      profilePhoto: map['profilePhoto'] ?? '',
      age: map['age'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
