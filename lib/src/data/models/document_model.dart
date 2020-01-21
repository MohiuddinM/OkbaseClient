import 'dart:convert';

import 'package:okbase_client/src/domain/entities/document.dart';

class DocumentModel extends Document {
  DocumentModel(String id, String userId, String collection, Map<String, Object> content, DateTime modifiedAt, DateTime createdAt, bool isDeleted) : super(id, userId, collection, content, modifiedAt, createdAt, isDeleted);

  factory DocumentModel.fromDocument(Document document) {
    return DocumentModel(
      document.id,
      document.userId,
      document.collection,
      document.content,
      document.modifiedAt,
      document.createdAt,
      document.isDeleted,
    );
  }

  factory DocumentModel.fromJson(Map<String, dynamic> map) {
    return DocumentModel(
      map['id'],
      map['userId'],
      map['collection'],
      map['content'],
      DateTime.parse(map['modifiedAt']),
      DateTime.parse(map['createdAt']),
      map['isDeleted'],
    );
  }

  factory DocumentModel.fromJsonString(String json) => DocumentModel.fromJson(jsonDecode(json));

  DocumentModel copyWith({String id, String authorId, String collection, Map<String, Object> content, bool deleted, DateTime modifiedAt, DateTime createdAt}) {
    return DocumentModel(
      id ?? this.id,
      authorId ?? this.userId,
      collection ?? this.collection,
      content ?? this.content,
      modifiedAt ?? this.modifiedAt,
      createdAt ?? this.createdAt,
      deleted ?? this.isDeleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'collection': collection,
      'content': content,
      'modifiedAt': modifiedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
