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
      final value = cacheService.get('members');
      return value as List<Member>;
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

      //update cache
      await cacheService.set('members', memberList);

      return memberList;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> toggleScreenTime(String memberId) async {
    try {
      await networkService.request(
        path: '/toggleScreenTime/$memberId',
        method: RequestMethod.put,
      );
      final res = await getMembers();

      //update cache
      await cacheService.set('members', res);

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
