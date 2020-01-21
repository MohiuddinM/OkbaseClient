import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:okbase_client/okbase_client.dart';

class Todo extends Equatable {
  final String id, userId, task;
  final DateTime dueDateTime, modifiedAt, createdAt;
  final bool isDeleted;

  Todo(this.id, this.userId, this.task, this.dueDateTime, this.modifiedAt, this.createdAt, this.isDeleted);

  @override
  List<Object> get props => [id, userId, task, dueDateTime, modifiedAt, createdAt, isDeleted];
}

class TodoDocument extends Todo implements Document {
  TodoDocument(id, userId, task, dueDateTime, modifiedAt, createdAt, isDeleted) : super(id, userId, task, dueDateTime, modifiedAt, createdAt, isDeleted);

  TodoDocument copyWith({String id, String userId, String task, DateTime dueDateTime, DateTime modifiedAt, DateTime createdAt, bool isDeleted}) {
    return TodoDocument(
      id ?? this.id,
      userId ?? this.userId,
      task ?? this.task,
      dueDateTime ?? this.dueDateTime,
      modifiedAt ?? this.modifiedAt,
      createdAt ?? this.createdAt,
      isDeleted ?? this.isDeleted,
    );
  }

  factory TodoDocument.fromDocument(Document document) {
    return TodoDocument(
      document.id,
      document.userId,
      document.content['task'],
      DateTime.parse(document.content['dueDateTime']),
      document.modifiedAt,
      document.createdAt,
      document.isDeleted,
    );
  }

//  factory ToDoDocument.fromJson(Map<String, Object> map) {
//    return ToDoDocument(
//
//    )
//  }

  Map<String, Object> toJson() {
    return {
      'task': task,
      'dueDateTime': dueDateTime.toIso8601String(),
    };
  }

  @override
  String get collection => 'todos';

  @override
  Map<String, Object> get content => toJson();
}

void main() {
  group('Local Database Tests', () {
    setUp(() {});

    test('Local Database Test', () async {
      final dbFile = File('okbase-database.db');
      if (dbFile.existsSync()) {
        dbFile.deleteSync();
      }

      final u1 = User(id: uuid.v4(), email: 'muhammad.mohiuddin@live.com', password: 'supers3cr3t', role: 'User');
      final u2 = User(id: uuid.v4(), email: 'muhammad.mohiuddin@live.com', password: 'supers3cr3t', role: 'User');

      OkbaseConfig config = OkbaseConfig(host: 'http://localhost:8888', userAgent: 'Okbase (Flutter)');

      final b1 = OkbaseClient(user: u1, config: config);
      final b2 = OkbaseClient(user: u2, config: config);
      await b1.initialize();
      await b2.initialize();

      final u1t1 = TodoDocument(uuid.v4(), u1.id, 'User1 Task1', DateTime.now(), DateTime.now().toUtc(), DateTime.now().toUtc(), false);
      final u1t2 = TodoDocument(uuid.v4(), u1.id, 'User1 Task2', DateTime.now(), DateTime.now().toUtc(), DateTime.now().toUtc(), false);
      final u2t1 = TodoDocument(uuid.v4(), u2.id, 'User2 Task1', DateTime.now(), DateTime.now().toUtc(), DateTime.now().toUtc(), false);
      final u2t2 = TodoDocument(uuid.v4(), u2.id, 'User2 Task2', DateTime.now(), DateTime.now().toUtc(), DateTime.now().toUtc(), false);

      await b1.localDocuments.create(u1t1);
      await b1.localDocuments.create(u1t2);
      await b2.localDocuments.create(u2t1);
      await b2.localDocuments.create(u2t2);

      expect((await b1.localDocuments.getAll()).value.length, 2);
      expect((await b2.localDocuments.getAll()).value.length, 2);
      expect(TodoDocument.fromDocument((await b1.localDocuments.get(u1t1.id)).value), u1t1);
      expect(TodoDocument.fromDocument((await b2.localDocuments.get(u2t1.id)).value), u2t1);

      final updatedDoc = u1t1.copyWith(task: 'User1 Task 3');
      await b1.localDocuments.update(updatedDoc);
      expect(TodoDocument.fromDocument((await b1.localDocuments.get(u1t1.id)).value), updatedDoc);
      await b1.localDocuments.delete(u1t1.id);
      await b1.localDocuments.delete(u1t2.id);

      expect((await b1.localDocuments.getAll()).value.length, 0);
      expect((await b1.localDocuments.getAll(ignoreDeleted: false)).value.length, 2);
    });
  });
}
