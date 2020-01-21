import 'package:okbase_client/src/data/models/document_model.dart';
import 'package:okbase_client/src/domain/entities/change.dart';
import 'package:okbase_client/src/domain/entities/document.dart';
import 'package:okbase_client/src/domain/entities/document_store.dart';
import 'package:okbase_client/src/domain/entities/query.dart';
import 'package:okbase_client/src/core/result.dart';
import 'package:okbase_client/src/domain/repositories/documents_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../logger.dart';

class OfflineDocumentsRepository implements DocumentsRepository {
  final DocumentStore _store;

  static const _log = OkbaseLogger('OfflineDocumentRepository');

  OfflineDocumentsRepository(DocumentStore store) : _store = store;

  final _changes = PublishSubject<DocumentChange>(sync: true);

  Stream<DocumentChange> get changeStream => _changes.stream;

  Future<Result<List<DocumentChange>>> getChanges({DateTime madeAfter, DateTime madeBefore}) async {
    try {
      final documents = await getAll();

      if (!documents.isError) {
        final changes = documents.value.map((d) {
          if (d.isDeleted) {
            return DocumentChange(ChangeType.delete, d.id, d.modifiedAt);
          } else if (d.createdAt == d.modifiedAt) {
            return DocumentChange(ChangeType.create, d.id, d.createdAt);
          } else {
            return DocumentChange(ChangeType.update, d.id, d.modifiedAt);
          }
        }).toList(growable: false);

        if (changes.isEmpty) {
          return Result.ok(<DocumentChange>[]);
        }

        return Result.ok(changes);
      } else {
        return Result.error(documents.message);
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<Document>> get(String id) async {
    try {
      return Result.ok(await _store.getById(id));
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<List<Document>>> getAll({DateTime createdAfter, DateTime createdBefore, DateTime modifiedAfter, DateTime modifiedBefore, bool ignoreDeleted = true}) async {
    try {
      return Result.ok(await _store.getAll(ignoreDeleted: ignoreDeleted));
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<Document>> create(Document document) async {
    await _store.store(DocumentModel.fromDocument(document));
    final got = await get(document.id);

    if (document == got.value) {
      _changes.add(DocumentChange(ChangeType.create, document.id));
    }

    return got;
  }

  Future<Result<Document>> update(Document document, {bool silentUpdate = false}) async {
    await _store.update(DocumentModel.fromDocument(document));

    final got = await get(document.id);

    if (document == got.value && !silentUpdate) {
      _changes.add(DocumentChange(document.isDeleted ? ChangeType.delete : ChangeType.update, document.id));
    }

    return got;
  }

  Future<Result<Document>> delete(String id) async {
    final document = await get(id);

    if (document.isError) {
      return document;
    }

    if (document.value.isDeleted) {
      return Result.ok(document.value);
    }

    return update(Document.copyFrom(other: document.value, deleted: true, modifiedAt: DateTime.now().toUtc(), content: <String, Object>{}));
  }

  @override
  Future<Result<List<Document>>> find(Query query) {
    // TODO: implement find
    return null;
  }
}
