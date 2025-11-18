import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onehaven_caregiver_app/data/models/member.dart';

final cacheServiceProvider = Provider((ref) => CacheService());

class CacheService {
  CacheService._();

  static final instance = CacheService._();

  factory CacheService() => instance;

  late Box<dynamic> hiveBox;

  Future<void> openMemberBox(String boxName) async {
    hiveBox = await Hive.openBox<MembersList>(boxName);
  }

  Future<void> init() async {
    await openMemberBox('Members');
    debugPrint('opened');
  }

  dynamic get(String key) {
    return hiveBox.get(key, defaultValue: [] as List<Member>);
  }

  Future<void> set(String? key, dynamic data) async {
    await hiveBox.put(key, data);
  }

  Future<void> clear() async {
    await hiveBox.clear();
  }
}
