import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChangeType {
  static const create = 'c';
  static const read = 'r';
  static const update = 'u';
  static const delete = 'd';
}

class DocumentChange extends Equatable {
  final String type, documentId;
  final DateTime timestamp;

  DocumentChange(this.type, this.documentId, [this.timestamp]);

  factory DocumentChange.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('createdAt')) {
      return DocumentChange(ChangeType.create, map['documentId'], DateTime.fromMillisecondsSinceEpoch(map['createdAt'], isUtc: true));
    } else if (map.containsKey('modifiedAt')) {
      return DocumentChange(ChangeType.update, map['documentId'], DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'], isUtc: true));
    } else if (map.containsKey('deletedAt')) {
      return DocumentChange(ChangeType.delete, map['documentId'], DateTime.fromMillisecondsSinceEpoch(map['deletedAt'], isUtc: true));
    } else {
      throw Exception('Invalid Document Event');
    }
  }

  factory DocumentChange.fromJsonString(String json) => DocumentChange.fromJson(jsonDecode(json));

  @override
  List<Object> get props => [type, documentId, timestamp];
}

class PermissionChange extends Equatable {
  final String type, permissionId;
  final DateTime timestamp;

  PermissionChange(this.type, this.permissionId, [this.timestamp]);

  factory PermissionChange.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('createdAt')) {
      return PermissionChange(ChangeType.create, map['permissionId'], DateTime.fromMillisecondsSinceEpoch(map['createdAt'], isUtc: true));
    } else if (map.containsKey('modifiedAt')) {
      return PermissionChange(ChangeType.update, map['permissionId'], DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'], isUtc: true));
    } else if (map.containsKey('deletedAt')) {
      return PermissionChange(ChangeType.delete, map['permissionId'], DateTime.fromMillisecondsSinceEpoch(map['deletedAt'], isUtc: true));
    } else {
      throw Exception('Invalid Document Event');
    }
  }

  factory PermissionChange.fromJsonString(String json) => PermissionChange.fromJson(jsonDecode(json));

  @override
  List<Object> get props => [type, permissionId, timestamp];
}
