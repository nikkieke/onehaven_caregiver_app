import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onehaven_caregiver_app/core/cache_service.dart';
import 'package:onehaven_caregiver_app/core/network_service.dart';
import 'package:onehaven_caregiver_app/data/models/member.dart';

final membersServiceProvider = Provider(
  (ref) => MembersService(
    networkService: ref.watch(networkServiceProvider),
    cacheService: ref.watch(cacheServiceProvider),
  ),
);

class MembersService {
  const MembersService({
    required this.networkService,
    required this.cacheService,
  });

  final NetworkService networkService;
  final CacheService cacheService;

  List<Member> getMembersFromCache() {
    try {
      final value = cacheService.get('members') as MembersList;
      return value.members ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Member>> getMembers() async {
    try {
      final response = await networkService.request(
        path: '/members',
        method: RequestMethod.get,
      );
      final res = response.data as List<dynamic>;
      final memberList = res.map((e) => Member.fromJson(e)).toList();

      final list = MembersList(members: memberList);

      //update cache
      await cacheService.set('members', list);

      return memberList;
    } catch (e) {
      if (e == '${DioExceptionType.connectionError}') {
        final saved = getMembersFromCache();
        if (saved.isNotEmpty) {
          return saved;
        } else {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
  }

  Future<bool> toggleScreenTime(String memberId) async {
    try {
      await networkService.request(
        path: '/toggleScreenTime/$memberId',
        method: RequestMethod.put,
      );

      // To update the cache with new data
      await getMembers();

      return true;
    } catch (e) {
      if (e == '${DioExceptionType.connectionError}') {
        await updateCacheWhenOffline(memberId);
        return true;
      } else {
        rethrow;
      }
    }
  }

  Future<void> updateCacheWhenOffline(String memberId) async {
    final members = getMembersFromCache();
    final updatedMembersList =
        members.map((e) {
          if (e.id == memberId) {
            return e.copyWith(
              screenTimeEnabled: !e.screenTimeEnabled!,
              status: e.status == 'active' ? 'inactive' : 'active',
            );
          }
          return e;
        }).toList();

    await queueUpdates(memberId);
    final list = MembersList(members: updatedMembersList);
    await cacheService.set('members', list);
  }

  Future<void> queueUpdates(String id) async {
    //get list from cache
    final pendingList = await getPendingList();

    void addNewItem() {
      final pendingItem = {'id': id, 'update': true} as Map<String, dynamic>;
      pendingList.add(pendingItem);
    }

    void updateSavedItem(Map<String, dynamic> item) {
      item['update'] = !item['update'];
      final index = pendingList.indexWhere((e) => e['id'] == item['id']);
      pendingList[index] = item;
    }

    if (pendingList.isEmpty) {
      addNewItem();
    } else {
      // check if it is a saved item
      final list = pendingList.where((e) => e['id'] == id).toList();
      list.isEmpty ? addNewItem() : updateSavedItem(list.first);
    }

    cacheService.setPending('Pending', pendingList);
  }

  Future<void> syncOfflineUpdates() async {
    //get list from cache
    final pendingList = await getPendingList();

    if (pendingList.isEmpty) return;

    final successful = <Map<String, dynamic>>[];

    for (final item in pendingList) {
      if (item['update'] == true) {
        try {
          await toggleScreenTime(item['id']);
          successful.add(item);
        } catch (e) {
          debugPrint('failed to sync item ${item['id']}: $e');
        }
      } else {
        //save unnecessary updates in successful
        successful.add(item);
      }
    }

    final remaining =
        pendingList.where((e) => !successful.contains(e)).toList();
    await cacheService.setPending('Pending', remaining);
  }

  Future<List<Map<String, dynamic>>> getPendingList() async {
    final list = await cacheService.getPending('Pending') as List<dynamic>;

    final List<Map<String, dynamic>> pendingList = [];

    for (final item in list) {
      pendingList.add(Map<String, dynamic>.from(item));
    }
    return pendingList;
  }

  Future<int> getPendingLength() async {
    final list = await getPendingList();
    return list.isEmpty ? 0 : list.length;
  }
}
