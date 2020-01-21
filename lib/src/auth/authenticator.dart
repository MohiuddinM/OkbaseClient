abstract class Authenticator {
  String get type;
  Future<String> get token;

  Future<bool> login();
  Future<bool> logout();
  Future<bool> refresh();

  bool get isAuthenticated;
}