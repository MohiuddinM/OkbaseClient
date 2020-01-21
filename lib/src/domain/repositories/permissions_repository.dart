import 'package:okbase_client/src/domain/entities/change.dart';
import 'package:okbase_client/src/domain/entities/permission.dart';
import 'package:okbase_client/src/core/result.dart';

abstract class PermissionsRepository {
  Future<Result<List<Permission>>> find();

  Future<Result<List<PermissionChange>>> getChanges({DateTime madeAfter, DateTime madeBefore});

  Future<Result<Permission>> get(String id);

  Future<Result<List<Permission>>> getAll({DateTime createdAfter, DateTime createdBefore, DateTime modifiedAfter, DateTime modifiedBefore});

  Future<Result<Permission>> create(Permission permission);

  Future<Result<Permission>> update(Permission permission);

  Future<Result<Permission>> delete(String id);
}
