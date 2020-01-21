import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:okbase_client/src/core/network_errors.dart';
import 'package:okbase_client/src/data/models/document_model.dart';
import 'package:okbase_client/src/auth/authenticator.dart';
import 'package:okbase_client/src/domain/entities/change.dart';
import 'package:okbase_client/src/domain/entities/document.dart';
import 'package:okbase_client/src/domain/entities/document_store.dart';
import 'package:okbase_client/src/domain/entities/query.dart';
import 'package:okbase_client/src/core/result.dart';

class DocumentsApi implements DocumentStore {
  final Authenticator _authenticator;
  final String host, userAgent, _baseUrl;

  DocumentsApi(this.host, this.userAgent, {Authenticator authenticator})
      : _authenticator = authenticator,
        _baseUrl = host + '/documents';

  Future<List<DocumentChange>> getChanges({DateTime madeAfter, DateTime madeBefore}) async {
    final response = await http.get(
      host + '/document-changes/all',
      headers: {
        'user-agent': userAgent,
        'Authorization': await _authenticator.token,
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return <DocumentChange>[];
      }

      final changes = (jsonDecode(response.body) as List).map((map) => DocumentChange.fromJson(map)).toList(growable: false);

      return changes;
    } else {
      throw NetworkError(response.statusCode);
    }
  }

  @override
  Future<DocumentModel> getById(String id) async {
    final response = await http.get(
      _baseUrl + '/' + id,
      headers: {
        'user-agent': userAgent,
        'Authorization': await _authenticator.token,
      },
    );

    if (response.statusCode == 200) {
      return DocumentModel.fromJson(jsonDecode(response.body));
    } else {
      throw NetworkError(response.statusCode);
    }
  }

  @override
  Future<List<DocumentModel>> getAll({DateTime createdAfter, DateTime createdBefore, DateTime modifiedAfter, DateTime modifiedBefore, bool ignoreDeleted = true}) async {
    final response = await http.get(
      _baseUrl,
      headers: {
        'user-agent': userAgent,
        'Authorization': await _authenticator.token,
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return <DocumentModel>[];
      }

      final documents = (jsonDecode(response.body) as List).map((map) => DocumentModel.fromJson(map)).toList(growable: false);

      return documents;
    } else {
      throw NetworkError(response.statusCode);
    }
  }

  @override
  Future<void> store(DocumentModel document) async {
    final response = await http.post(
      _baseUrl,
      body: document.toJsonString(),
      headers: {
        'user-agent': userAgent,
        'Authorization': await _authenticator.token,
      },
    );

    if (response.statusCode == 200) {
      return DocumentModel.fromJsonString(response.body);
    } else {
      return response.statusCode.toString();
    }
  }

  @override
  Future<void> update(DocumentModel document) async {
    final response = await http.put(
      _baseUrl + '/' + document.id,
      body: document.toJsonString(),
      headers: {
        'user-agent': userAgent,
        'Authorization': await _authenticator.token,
      },
    );

    if (response.statusCode != 200) {
      throw NetworkError(response.statusCode);
    }
  }

  @override
  Future<void> delete(String id, {shadowDelete = true}) async {
    final response = await http.delete(
      _baseUrl + '/$id',
      headers: {
        'user-agent': userAgent,
        'Authorization': await _authenticator.token,
      },
    );

    if (response.statusCode != 200) {
      throw NetworkError(response.statusCode);
    }
  }

  @override
  Future<Result<List<Document>>> find(Query query) {
    Query('dtcs').where('cleared', '=', false);
    return null;
  }
}
