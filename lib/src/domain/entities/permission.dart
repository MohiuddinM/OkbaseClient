import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final String id, documentId, grantedBy, grantedTo, grantedToRole;
  final bool canRead, canWrite, canManage, isActive;
  final DateTime expiresAt, modifiedAt, createdAt;

  Permission({this.id, this.documentId, this.grantedBy, this.grantedTo, this.grantedToRole, this.canRead, this.canWrite, this.canManage, this.isActive, this.expiresAt, this.modifiedAt, this.createdAt});

  Permission copyWith({
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
    return Permission(
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

  @override
  List<Object> get props => [id, documentId, grantedBy, grantedTo, grantedToRole, canRead, canWrite, canManage, isActive, expiresAt, modifiedAt, createdAt];
}
