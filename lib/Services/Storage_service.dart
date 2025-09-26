import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? get username => _prefs.getString('username');
  Future<void> setUsername(String v) => _prefs.setString('username', v);

  bool get isSubscribed => _prefs.getBool('is_subscribed') ?? false;
  Future<void> setSubscribed(bool v) => _prefs.setBool('is_subscribed', v);

  Future<void> clearAll() => _prefs.clear();
}
