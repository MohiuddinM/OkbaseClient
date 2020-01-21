
import 'package:okbase_client/src/data/models/permission_model.dart';
import 'package:okbase_client/src/domain/entities/change.dart';
import 'package:okbase_client/src/domain/entities/permission.dart';
import 'package:okbase_client/src/core/result.dart';
import 'package:okbase_client/src/domain/entities/user.dart';
import 'package:okbase_client/src/domain/repositories/permissions_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sembast/sembast.dart';

class OfflinePermissionsRepository extends PermissionsRepository {
  final User _user;
  final Database _db;
  final StoreRef _store;

  OfflinePermissionsRepository(User user, Database database)
      : _user = user,
        _db = database,
        _store = StoreRef<String, Map<String, dynamic>>('${user.id}/permissions');

  final _changes = PublishSubject<PermissionChange>(sync: true);

  Stream<PermissionChange> get changeStream => _changes.stream;

  Future<Result<List<PermissionChange>>> getChanges({DateTime madeAfter, DateTime madeBefore}) async {
    try {
      final permissions = await getAll();

      if (!permissions.isError) {
        final changes = permissions.value.map((d) {
          if (d.createdAt == d.modifiedAt) {
            return PermissionChange(ChangeType.create, d.id, d.createdAt);
          } else {
            return PermissionChange(ChangeType.update, d.id, d.modifiedAt);
          }
        }).toList(growable: false);

        if (changes.isEmpty) {
          return Result.ok(<PermissionChange>[]);
        }

        return Result.ok(changes);
      } else {
        return Result.error(permissions.message);
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<Permission>> get(String id) async {
    final record = await _store.findFirst(_db, finder: Finder(filter: Filter.byKey(id)));

    if (record != null) {
      return Result.ok(PermissionModel.fromJson(record.value) as Permission);
    } else {
      return Result.error('Permission not found in database');
    }
  }

  Future<Result<List<Permission>>> getAll({DateTime createdAfter, DateTime createdBefore, DateTime modifiedAfter, DateTime modifiedBefore}) async {
    final records = await _store.find(_db);

    if (records != null) {
      return Result.ok(records.map((record) => PermissionModel.fromJson(record.value) as Permission));
    } else {
      return Result.error();
    }
  }

  Future<Result<Permission>> create(Permission permission) async {
    final key = await _store.record(permission.id).add(_db, PermissionModel.fromPermission(permission).toJson());

    if (key != null) {
      _changes.add(PermissionChange(ChangeType.create, permission.id));

      return Result.ok();
    } else {
      return Result.error();
    }
  }

  Future<Result<Permission>> update(Permission permission, {bool silentUpdate = false}) async {
    await _store.record(permission.id).update(_db, PermissionModel.fromPermission(permission).toJson());

    final got = await get(permission.id);

    if (permission == got.value && !silentUpdate) {
      _changes.add(PermissionChange(ChangeType.update, permission.id));
    }

    return got;
  }

  Future<Result<Permission>> delete(String id) async {
    final permission = await get(id);

    if (permission.isError) {
      return permission;
    }

    if (!permission.value.isActive) {
      return Result.ok(permission.value);
    }

    return update(permission.value.copyWith(isActive: false, modifiedAt: DateTime.now().toUtc()));
  }

  @override
  Future<Result<List<Permission>>> find() {
    // TODO: implement find
    return null;
  }
}
