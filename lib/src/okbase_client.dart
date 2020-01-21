import 'package:http/http.dart' as http;
import 'package:okbase_client/src/logger.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:uuid/uuid.dart';

import 'auth/jwt_authenticator.dart';
import 'data/datasources/documents_api.dart';
import 'data/datasources/sembast_document_store.dart';
import 'data/models/user_model.dart';
import 'data/repositories/offline_documents_repository.dart';
import 'data/repositories/online_documents_repository.dart';
import 'auth/authenticator.dart';
import 'domain/entities/user.dart';
import 'domain/repositories/documents_repository.dart';
import 'domain/repositories/permissions_repository.dart';
import 'okbase_config.dart';



final uuid = Uuid();

class OkbaseClient {
  static const _log = OkbaseLogger('OkbaseClient');

  Authenticator _authenticator;
  final User user;
  final OkbaseConfig config;
  PermissionsRepository permissions;
  PermissionsRepository localPermissions;
  DocumentsRepository documents;
  DocumentsRepository localDocuments;

//  SyncService _syncService;

  OkbaseClient({this.user, this.config}) {
    if (user != null) {
      _authenticator = JwtAuthenticator(config.host, config.userAgent, credentialsCallback: () async => {'email': user.email, 'password': user.password});
    }
  }

  Future<bool> initialize() async {
    try {
      String dbPath = 'okbase-database.db';
      DatabaseFactory dbFactory = databaseFactoryIo;

      final db = await dbFactory.openDatabase(dbPath);
      final dbStore = SembastDocumentStore(user, db);

      final documentsApi = DocumentsApi(config.host, config.userAgent, authenticator: _authenticator);

//      localPermissions = LocalPermissions(user, db);
      final offlineDocumentsRepository = OfflineDocumentsRepository(dbStore);
      localDocuments = offlineDocumentsRepository;
      documents = OnlineDocumentsRepository(api: documentsApi, offlineDocumentsRepository: offlineDocumentsRepository);
//      onlinePermissions = OnlinePermissions(user, _authenticator, config.host, config.userAgent);
//      _syncService = SyncService(user, db, config.host, localDocuments, onlineDocuments, localPermissions, onlinePermissions);

//      await _syncService.initialize();

      return true;
    } catch (e) {
      return false;
    }

//    _authenticator.login();
  }

  Future<int> createUser(User newUser) async {
    assert(user == null);

    print(UserModel.fromUser(newUser).toJsonString());

    http.Response response;

    try {
      response = await http.post(
        config.host + '/user',
        body: UserModel.fromUser(newUser).toJsonString(),
        headers: {'user-agent': config.userAgent},
      );
    } catch (e) {
      _log.fine('user creation failed: ${e.toString()}');
      print('failed: ' + e.toString());
      return 0;
    }

    if (response.statusCode == 200) {
      _log.fine('user creating successful');
    } else {
      print(response.body);
    }

    return response.statusCode;
  }

  Future<int> forgotPassword(String email) async {
    var response;

    try {
      response = await http.post(
        config.host + '/password/request-reset',
        body: {'email': email},
        headers: {'user-agent': config.userAgent},
      );
    } catch (e) {
      return 0;
    }

    return response.statusCode;
  }

  Future<int> resetPassword(String email, String password, String resetToken) async {
    if (password == null || resetToken == null) throw new ArgumentError.notNull('Password or ResetToken');

    var response;
    try {
      response = await http.post(
        config.host + '/password/reset',
        body: {'email': email, 'password': password, 'resetToken': resetToken},
        headers: {'user-agent': config.userAgent},
      );
    } catch (e) {
      return 0;
    }

    return response.statusCode;
  }
}
