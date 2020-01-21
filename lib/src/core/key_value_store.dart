abstract class KeyValueStore {
  Future<String> getString(String key, {String def});

  Future<bool> setString(String key, String value);

  Future<bool> getBool(String key, {bool def});

  Future<bool> setBool(String key, bool value);
}
