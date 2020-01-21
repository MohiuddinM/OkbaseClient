import 'package:okbase_client/src/data/datasources/documents_api.dart';
import 'package:okbase_client/src/domain/entities/change.dart';
import 'package:okbase_client/src/domain/entities/document.dart';
import 'package:okbase_client/src/domain/entities/query.dart';
import 'package:okbase_client/src/core/result.dart';
import 'package:okbase_client/src/domain/repositories/documents_repository.dart';

import 'offline_documents_repository.dart';

class OnlineDocumentsRepository implements DocumentsRepository {
  final DocumentsApi _api;
  final OfflineDocumentsRepository _offlineDocumentsRepository;

  OnlineDocumentsRepository({DocumentsApi api, OfflineDocumentsRepository offlineDocumentsRepository})
      : _api = api,
        _offlineDocumentsRepository = offlineDocumentsRepository;

  @override
  Future<Result<Document>> create(Document document) {
    return null;
  }

  @override
  Future<Result<Document>> delete(String id) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<Result<List<Document>>> find(Query query) {
    // TODO: implement find
    return null;
  }

  @override
  Future<Result<Document>> get(String id) {
    // TODO: implement get
    return null;
  }

  @override
  Future<Result<List<Document>>> getAll({DateTime createdAfter, DateTime createdBefore, DateTime modifiedAfter, DateTime modifiedBefore, bool ignoreDeleted = true}) {
    // TODO: implement getAll
    return null;
  }

  @override
  Future<Result<List<DocumentChange>>> getChanges({DateTime madeAfter, DateTime madeBefore}) {
    // TODO: implement getChanges
    return null;
  }

  @override
  Future<Result<Document>> update(Document document) {
    // TODO: implement update
    return null;
  }
}
