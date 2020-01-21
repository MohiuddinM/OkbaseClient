import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:okbase_client/src/auth/authenticator.dart';
import 'package:synchronized/synchronized.dart';

import '../logger.dart';

class JwtAuthenticator implements Authenticator {
  static final _log = OkbaseLogger('JwtAuthenticator');
  final _lock = Lock();

  String _token, _tokenType;
  DateTime _expiresAt;

  final String host, userAgent;

  // {'email': '', 'password': '', 'remember': false}
  final Future<Map<String, Object>> Function() credentialsCallback;

  JwtAuthenticator(this.host, this.userAgent, {this.credentialsCallback});

  @override
  Future<String> get token async {
    if (isAuthenticated) {
      return _tokenType + ' ' + _token;
    } else {
      final success = await refresh();

      if (success) {
        return _tokenType + ' ' + _token;
      } else {
        throw ArgumentError('Error while fetching token');
      }
    }
  }

  @override
  String get type => 'jwt';

  @override
  bool get isAuthenticated => _token != null && _tokenType != null && DateTime.now().toUtc().isBefore(_expiresAt);

  @override
  Future<bool> login() async {
    _log.info('trying to log in');
    return _lock.synchronized(() async {
      if (isAuthenticated) {
        return true;
      }

      final creds = await credentialsCallback();
      final email = creds['email'] ?? '';
      final password = creds['password'] ?? '';

      if (email == null || password == null) {
        return false;
      }

      http.Response response;

      try {
        response = await http.post(
          host + '/login',
          body: jsonEncode({'email': email, 'password': password}),
          headers: {'user-agent': userAgent},
        );
      } catch (e) {
        _log.warning('error while logging in: ' + e.toString());
        return false;
      }

      if (response.statusCode == 200) {
        _log.info('successfully logged in');
        _tokenType = 'Bearer';
        _token = response.body;
        _expiresAt = DateTime.now().toUtc().add(Duration(days: 1));
      }

      return response.statusCode == 200;
    });
  }

  @override
  Future<bool> logout() async {
    _log.info('trying to logout');
    return _lock.synchronized(() async {
      if (!isAuthenticated) {
        return true;
      }

      http.Response response;

      try {
        response = await http.get(
          host + '/logout',
          headers: {
            'user-agent': userAgent,
            'Authorization': await token,
          },
        );
      } catch (e) {
        return false;
      }

      if (response.statusCode == 200) {
        _token = null;
        _tokenType = null;
        _expiresAt = null;
      }

      return response.statusCode == 200;
    });
  }

  @override
  Future<bool> refresh() => login();
}
