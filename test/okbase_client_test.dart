import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:okbase_client/okbase_client.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Smoke Tests', () {
    setUp(() {

      final dbFile = File('okbase-database.db');
      if (dbFile.existsSync()) {
        dbFile.deleteSync();
      }
    });

    test('Smoke Test', () async {
      //todo: test permissions
      OkbaseConfig config = OkbaseConfig(host: 'http://localhost:8888', userAgent: 'Okbase (Flutter)');

      final anonBase = OkbaseClient(config: config);
      final user1 = User(id: Uuid().v1(), email: 'user1@test.com', password: 'supers3cr3t', role: 'User');
      final user2 = User(id: Uuid().v1(), email: 'user2@test.com', password: 'supers3cr3t', role: 'User');

      expect(await anonBase.createUser(user1), 200);
      expect(await anonBase.createUser(user2), 200);

      final user1base = OkbaseClient(user: user1, config: config);
      final user2base = OkbaseClient(user: user2, config: config);

      await user1base.initialize();
      await user2base.initialize();

      final user1document1 = DocumentModel(Uuid().v1(), user1.id, 'todos',  const {'title': 'User1 Task 1', 'when': 'in morning'},  DateTime.now().toUtc(),  DateTime.now().toUtc(), false);
      final user1document2 = DocumentModel(Uuid().v1(), user1.id, 'todos',  const {'title': 'User1 Task 2', 'when': 'in morning'},  DateTime.now().toUtc(),  DateTime.now().toUtc(), false);

      final user2document1 = DocumentModel(Uuid().v1(), user2.id, 'todos',  const {'title': 'User2 Task 1', 'when': 'in morning'},  DateTime.now().toUtc(),  DateTime.now().toUtc(), false);
      final user2document2 = DocumentModel(Uuid().v1(), user2.id, 'todos',  const {'title': 'User2 Task 2', 'when': 'in morning'},  DateTime.now().toUtc(),  DateTime.now().toUtc(), false);

      await user1base.localDocuments.create(user1document1);
      await user1base.localDocuments.create(user1document2);

      await user2base.localDocuments.create(user2document1);
      await user2base.localDocuments.create(user2document2);

      await Future.delayed(Duration(seconds: 2));

//      expect((await user1base.documents.getAll()).value.length, 2);
//      expect((await user1base.documents.get(user1document1.id)).value, user1document1);
//
//      expect((await user2base.documents.getAll()).value.length, 2);
//      expect((await user2base.documents.get(user2document1.id)).value, user2document1);

      await user1base.localDocuments.update(user1document1.copyWith(content: const {'title': 'User1 Task 1', 'when': 'in evening'}));
      await user1base.localDocuments.update(user1document2.copyWith(content: const {'title': 'User1 Task 2', 'when': 'in evening'}));

      await user2base.localDocuments.update(user2document1.copyWith(content: const {'title': 'User2 Task 1', 'when': 'in evening'}));
      await user2base.localDocuments.update(user2document2.copyWith(content: const {'title': 'User2 Task 2', 'when': 'in evening'}));

      await Future.delayed(Duration(seconds: 2));

//      expect((await user1base.documents.get(user1document1.id)).value.content, jsonEncode(const {'title': 'User1 Task 1', 'when': 'in evening'}));
//      expect((await user1base.documents.get(user1document2.id)).value.content, jsonEncode(const {'title': 'User1 Task 2', 'when': 'in evening'}));
//
//      expect((await user2base.documents.get(user2document1.id)).value.content, jsonEncode(const {'title': 'User2 Task 1', 'when': 'in evening'}));
//      expect((await user2base.documents.get(user2document2.id)).value.content, jsonEncode(const {'title': 'User2 Task 2', 'when': 'in evening'}));

      await user1base.localDocuments.delete(user1document1.id);
      await user1base.localDocuments.delete(user1document2.id);

      await user2base.localDocuments.delete(user2document1.id);
      await user2base.localDocuments.delete(user2document2.id);

      await Future.delayed(Duration(milliseconds: 2000));

//      expect((await user1base.documents.getAll()).value.where((doc) => !doc.isDeleted).length, 0);
//      expect((await user2base.documents.getAll()).value.where((doc) => !doc.isDeleted).length, 0);


    });
  });
}
