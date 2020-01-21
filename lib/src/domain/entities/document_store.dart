import 'package:okbase_client/src/data/models/document_model.dart';

import 'change.dart';

abstract class DocumentStore {
  Future<List<DocumentModel>> getAll({bool ignoreDeleted});

  Future<DocumentModel> getById(String id);

  Future<void> store(DocumentModel document);

  Future<void> delete(String id, {shadowDelete = true});

  Future<void> update(DocumentModel document);

  Future<List<DocumentChange>> getChanges({DateTime madeAfter, DateTime madeBefore});
}
