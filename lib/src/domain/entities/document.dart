import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Document extends Equatable {
  final String id, userId, collection;
  final DateTime modifiedAt, createdAt;
  final Map<String, Object> content;
  final bool isDeleted;

  Document(this.id, this.userId, this.collection, this.content, this.modifiedAt, this.createdAt, this.isDeleted);

  factory Document.copyFrom({@required Document other, String id, String userId, String collection, Map<String, Object> content, bool deleted, DateTime modifiedAt, DateTime createdAt}) {
    return Document(
      id ?? other.id,
      userId ?? other.userId,
      collection ?? other.collection,
      content ?? other.content,
      modifiedAt ?? other.modifiedAt,
      createdAt ?? other.createdAt,
      deleted ?? other.isDeleted,
    );
  }

  @override
  List<Object> get props => [id, userId, collection, content, modifiedAt, createdAt, isDeleted];
}