import 'package:okbase_client/src/domain/entities/change.dart';
import 'package:okbase_client/src/domain/entities/document.dart';
import 'package:okbase_client/src/domain/entities/query.dart';
import 'package:okbase_client/src/core/result.dart';

abstract class DocumentsRepository {
  Future<Result<List<DocumentChange>>> getChanges({DateTime madeAfter, DateTime madeBefore});

  Future<Result<List<Document>>> find(Query query);

  Future<Result<Document>> get(String id);

  Future<Result<List<Document>>> getAll({DateTime createdAfter, DateTime createdBefore, DateTime modifiedAfter, DateTime modifiedBefore, bool ignoreDeleted});

  Future<Result<Document>> create(Document document);

  Future<Result<Document>> update(Document document);

  Future<Result<Document>> delete(String id);
}