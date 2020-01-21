import 'dart:convert';

import 'package:okbase_client/src/domain/entities/user.dart';

class UserModel extends User {
  UserModel({String id, String email, String password, String role}) : super(id: id, email: email, password: password, role: role);

  factory UserModel.fromUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      password: user.password,
      role: user.role,
    );
  }

  factory UserModel.fromJson(Map<String, String> map) {
    return UserModel(id: map['id'], email: map['email'], password: map['password'], role: map['role']);
  }

  factory UserModel.fromJsonString(String json) => UserModel.fromJson(jsonDecode(json));

  Map<String, String> toJson() {
    final map = <String, String>{};
    map['id'] = id;
    map['role'] = role;
    map['password'] = password;
    map['email'] = email;
    return map;
  }

  String toJsonString() => jsonEncode(toJson());
}
