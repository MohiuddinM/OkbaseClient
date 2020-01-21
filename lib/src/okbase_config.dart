import 'package:meta/meta.dart';

import 'domain/entities/document.dart';
import 'domain/entities/permission.dart';

class OkbaseConfig {
  final String host, userAgent;
  final bool offlineOnly, onlineOnly;
  final Document Function(Document, Document) documentConflictCallback;
  final Permission Function(Permission, Permission) permissionConflictCallback;

  OkbaseConfig({@required this.host, this.userAgent = 'Okbase', this.offlineOnly = false, this.onlineOnly = false, documentConflictCallback, permissionConflictCallback})
      : this.documentConflictCallback = (documentConflictCallback ?? (local, remote) => remote),
        this.permissionConflictCallback = (permissionConflictCallback ?? (local, remote) => remote);
}
