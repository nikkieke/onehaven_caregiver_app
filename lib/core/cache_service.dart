import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  CacheService._();

  static final instance = CacheService._();

  factory CacheService() => instance;

  late Box<dynamic> hiveBox;

  Future<void> openBox(String boxName) async {
    hiveBox = await Hive.openBox<dynamic>(boxName);
  }

  Future<void> init() async {
    await openBox('OneHaven');
    debugPrint('opened');
  }

  dynamic get(String key) {
    return hiveBox.get(key);
  }

  Future<void> set(String? key, dynamic data) async {
    await hiveBox.put(key, data);
  }

  Future<void> clear() async {
    await hiveBox.clear();
  }
}
