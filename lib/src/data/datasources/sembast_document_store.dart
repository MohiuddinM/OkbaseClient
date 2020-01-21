import 'package:okbase_client/src/data/models/document_model.dart';
import 'package:okbase_client/src/domain/entities/change.dart';
import 'package:okbase_client/src/domain/entities/document_store.dart';
import 'package:okbase_client/src/domain/entities/user.dart';
import 'package:sembast/sembast.dart';

import '../../logger.dart';
import '../../exceptions.dart' as exceptions;

class SembastDocumentStore implements DocumentStore {
  final StoreRef _store;
  final Database _db;

  static const _log = OkbaseLogger('SembastDocumentStore');

  SembastDocumentStore(User user, Database database)
      : _db = database,
        _store = StoreRef<String, Map<String, dynamic>>('${user.id}/documents');

  @override
  Future<void> delete(String id, {shadowDelete = true}) async {
    final document = await getById(id);

    if (!document.isDeleted) {
      return update(document.copyWith(deleted: true, modifiedAt: DateTime.now().toUtc(), content: {}));
    }
  }

  @override
  Future<List<DocumentModel>> getAll({bool ignoreDeleted = true}) async {
    final records = await _store.find(_db);

    if (records == null) {
      throw exceptions.DatabaseException();
    }

    return records.map((record) => DocumentModel.fromJson(record.value)).where((d) => !d.isDeleted || !ignoreDeleted).toList(growable: false);
  }

  @override
  Future<DocumentModel> getById(String id) async {
    final record = await _store.findFirst(_db, finder: Finder(filter: Filter.byKey(id)));

    if (record == null) {
      throw exceptions.NotFoundException();
    }

    return DocumentModel.fromJson(record.value);
  }

  @override
  Future<void> store(DocumentModel document) async {
    await _store.record(document.id).add(_db, document.toJson());
    final got = await getById(document.id);

    if (document != got) {
      throw exceptions.DatabaseException();
    }
  }

  @override
  Future<void> update(DocumentModel document) async {
    await _store.record(document.id).update(_db, document.toJson());

    final got = await getById(document.id);

    if (document != got) {
      throw exceptions.DatabaseException();
    }
  }

  @override
  Future<List<DocumentChange>> getChanges({DateTime madeAfter, DateTime madeBefore}) async {
    final documents = await getAll();

    final changes = documents.map((d) {
      if (d.isDeleted) {
        return DocumentChange(ChangeType.delete, d.id, d.modifiedAt);
      } else if (d.createdAt == d.modifiedAt) {
        return DocumentChange(ChangeType.create, d.id, d.createdAt);
      } else {
        return DocumentChange(ChangeType.update, d.id, d.modifiedAt);
      }
    }).toList(growable: false);

    if (changes.isEmpty) {
      return <DocumentChange>[];
    }

    return changes;
  }
}
