import 'package:flutter/material.dart';
import 'storage_service.dart';

class SubscriptionService extends ChangeNotifier {
  final StorageService _storage;
  SubscriptionService(this._storage);

  bool get isSubscribed => _storage.isSubscribed;
  String get username => _storage.username ?? 'guest';

  Future<void> subscribe() async {
    // В продакшене здесь — вызов платежного провайдера / GooglePlay / AppStore
    // В этом репозитории: эмуляция — подписка включается локально
    await _storage.setSubscribed(true);
    notifyListeners();
  }

  Future<void> unsubscribe() async {
    await _storage.setSubscribed(false);
    notifyListeners();
  }

  Future<void> setUsername(String name) async {
    await _storage.setUsername(name);
    notifyListeners();
  }
}
