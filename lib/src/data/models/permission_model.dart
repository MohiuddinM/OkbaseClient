import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:okbase_client/src/domain/entities/permission.dart';

class PermissionModel extends Equatable {
  final String id, documentId, grantedBy, grantedTo, grantedToRole;
  final bool canRead, canWrite, canManage, isActive;
  final DateTime expiresAt, modifiedAt, createdAt;

  PermissionModel({
    this.id,
    this.documentId,
    this.grantedBy,
    this.grantedTo,
    this.grantedToRole,
    this.canRead,
    this.canWrite,
    this.canManage,
    this.isActive,
    this.expiresAt,
    this.modifiedAt,
    this.createdAt,
  });

  factory PermissionModel.fromPermission(Permission permission) {
    return PermissionModel(
      id: permission.id,
      documentId: permission.documentId,
      grantedBy: permission.grantedBy,
      grantedTo: permission.grantedTo,
      grantedToRole: permission.grantedToRole,
      canRead: permission.canRead,
      canWrite: permission.canWrite,
      canManage: permission.canRead,
      isActive: permission.isActive,
      expiresAt: permission.expiresAt,
      modifiedAt: permission.modifiedAt,
      createdAt: permission.createdAt,
    );
  }

  factory PermissionModel.fromJson(Map<String, dynamic> map) {
    return PermissionModel(
      id: map['type'],
      documentId: map['documentId'],
      grantedBy: map['grantedBy'],
      grantedTo: map['grantedTo'],
      grantedToRole: map['grantedToRole'],
      canRead: map['canRead'],
      canWrite: map['canWrite'],
      canManage: map['canManage'],
      isActive: map['isActive'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(map['expiresAt'], isUtc: true),
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'], isUtc: true),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'], isUtc: true),
    );
  }

  factory PermissionModel.fromJsonString(String json) => PermissionModel.fromJson(jsonDecode(json));

  PermissionModel copyWith({
    String id,
    String documentId,
    String grantedBy,
    String grantedTo,
    String grantedToRole,
    bool canRead,
    bool canWrite,
    bool canManage,
    bool isActive,
    DateTime expiresAt,
    DateTime modifiedAt,
    DateTime createdAt,
  }) {
    return PermissionModel(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      grantedBy: grantedBy ?? this.grantedBy,
      grantedTo: grantedTo ?? this.grantedTo,
      grantedToRole: grantedToRole ?? this.grantedToRole,
      canRead: canRead ?? this.canRead,
      canWrite: canWrite ?? this.canWrite,
      canManage: canManage ?? this.canManage,
      isActive: isActive ?? this.isActive,
      expiresAt: expiresAt ?? this.expiresAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['documentId'] = documentId;
    map['grantedBy'] = grantedBy;
    map['grantedTo'] = grantedTo;
    map['grantedToRole'] = grantedToRole;
    map['canRead'] = canRead;
    map['canWrite'] = canWrite;
    map['canManage'] = canManage;
    map['isActive'] = isActive;
    map['expiresAt'] = expiresAt.millisecondsSinceEpoch;
    map['modifiedAt'] = modifiedAt.millisecondsSinceEpoch;
    map['createdAt'] = createdAt.millisecondsSinceEpoch;
    return map;
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  List<Object> get props => [id, documentId, grantedBy, grantedTo, grantedToRole, canRead, canWrite, canManage, isActive, expiresAt, modifiedAt, createdAt];
}
