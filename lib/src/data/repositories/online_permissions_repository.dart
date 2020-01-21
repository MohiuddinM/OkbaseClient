import 'dart:convert';

import 'package:okbase_client/src/data/models/permission_model.dart';
import 'package:okbase_client/src/auth/authenticator.dart';
import 'package:okbase_client/src/domain/entities/change.dart';
import 'package:okbase_client/src/domain/entities/permission.dart';
import 'package:okbase_client/src/core/result.dart';
import 'package:okbase_client/src/domain/entities/user.dart';
import 'package:okbase_client/src/domain/repositories/permissions_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class OnlinePermissionsRepository extends PermissionsRepository {
  final Authenticator _authenticator;
  final User _user;
  final String _baseUrl;
  final String host, userAgent;

  OnlinePermissionsRepository(User user, Authenticator authenticator, this.host, this.userAgent)
      : _user = user,
        _authenticator = authenticator,
        _baseUrl = host + '/permissions';

  final _changes = PublishSubject<PermissionChange>(sync: true);

  Stream<PermissionChange> get changeStream => _changes.stream;

  @override
  Future<Result<List<PermissionChange>>> getChanges({DateTime madeAfter, DateTime madeBefore}) async {
    try {
      final response = await http.get(
        host + '/permissions-changes/all',
        headers: {
          'user-agent': userAgent,
          'Authorization': await _authenticator.token,
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return Result.ok(<PermissionChange>[]);
        }

        final changes = (jsonDecode(response.body) as List).map((map) => PermissionChange.fromJson(map)).toList(growable: false);

        return Result.ok(changes);
      } else {
        return Result.error(response.statusCode.toString());
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<Permission>> get(String id) async {
    try {
      final response = await http.get(
        _baseUrl + '/' + id,
        headers: {
          'user-agent': userAgent,
          'Authorization': await _authenticator.token,
        },
      );

      if (response.statusCode == 200) {
        return Result.ok(PermissionModel.fromJsonString(response.body) as Permission);
      } else {
        return Result.error(response.statusCode.toString());
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<List<Permission>>> getAll({DateTime createdAfter, DateTime createdBefore, DateTime modifiedAfter, DateTime modifiedBefore}) async {
    try {
      final response = await http.get(
        _baseUrl,
        headers: {
          'user-agent': userAgent,
          'Authorization': await _authenticator.token,
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return Result.ok(<Permission>[]);
        }

        final documents = (jsonDecode(response.body) as List).map((map) => PermissionModel.fromJsonString(response.body) as Permission).toList(growable: false);

        return Result.ok(documents);
      } else {
        return Result.error(response.statusCode.toString());
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<Permission>> create(Permission permission) async {
    try {
      final response = await http.post(
        _baseUrl,
        body: PermissionModel.fromPermission(permission).toJsonString(),
        headers: {
          'user-agent': userAgent,
          'Authorization': await _authenticator.token,
        },
      );

      if (response.statusCode == 200) {
        _changes.add(PermissionChange(ChangeType.create, permission.id));
        return Result.ok(PermissionModel.fromJsonString(response.body) as Permission);
      } else {
        return Result.error(response.statusCode.toString());
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<Permission>> update(Permission permission) async {
    try {
      final response = await http.put(
        _baseUrl + '/' + permission.id,
        body: PermissionModel.fromPermission(permission).toJsonString(),
        headers: {
          'user-agent': userAgent,
          'Authorization': await _authenticator.token,
        },
      );

      if (response.statusCode == 200) {
        return Result.ok(PermissionModel.fromJsonString(response.body) as Permission);
      } else {
        return Result.error(response.statusCode.toString());
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<Permission>> delete(String id) async {
    try {
      final response = await http.delete(
        _baseUrl + '/$id',
        headers: {
          'user-agent': userAgent,
          'Authorization': await _authenticator.token,
        },
      );

      if (response.statusCode == 200) {
        return Result.ok(PermissionModel.fromJsonString(response.body) as Permission);
      } else {
        return Result.error(response.statusCode.toString());
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<List<Permission>>> find() async {
    // TODO: implement find
    return null;
  }
}
