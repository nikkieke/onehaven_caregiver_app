import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onehaven_caregiver_app/data/models/member.dart';
import 'package:onehaven_caregiver_app/data/services/members_service.dart';

enum MemberLoadingState { idle, loadingMembers }

class MemberState {
  MemberState({
    this.loadingState = MemberLoadingState.idle,
    this.toggle = false,
    this.memberList = const [],
    this.member,
  });

  final List<Member>? memberList;
  final MemberLoadingState? loadingState;
  final bool? toggle;
  final Member? member;

  MemberState copyWith({
    List<Member>? memberList,
    MemberLoadingState? loadingState,
    bool? toggle,
    Member? member,
  }) {
    return MemberState(
      memberList: memberList ?? memberList,
      toggle: toggle ?? toggle,
      loadingState: loadingState ?? loadingState,
      member: member ?? member,
    );
  }
}

final membersStateProvider = StateNotifierProvider(
  (ref) => MemberStateNotifier(service: ref.watch(membersServiceProvider)),
);

class MemberStateNotifier extends StateNotifier<MemberState> {
  MemberStateNotifier({required this.service}) : super(MemberState()) {
    updateMembersFromCache();
  }

  final MembersService service;

  Future<bool> isOffline() async {
    final result = await Connectivity().checkConnectivity();
    return result == ConnectivityResult.none;
  }

  Future<List<Member>> updateMembersFromCache() async {
    final offline = await isOffline();
    if (!offline) {
      await service.syncOfflineUpdates();
    }
    final members = service.getMembersFromCache();
    state = state.copyWith(memberList: members);
    return members;
  }

  Future<List<Member>> getMembers() async {
    if (state.memberList != null && state.memberList!.isEmpty) {
      final members = await service.getMembers();
      state = state.copyWith(memberList: members);
      return state.memberList!;
    } else {
      return state.memberList!;
    }
  }

  Future<void> toggle(int index) async {
    final member = state.memberList![index];
    final updatedMembersList =
        state.memberList!.map((e) {
          if (e.id == member.id) {
            return e.copyWith(
              screenTimeEnabled: !e.screenTimeEnabled!,
              status: e.status == 'active' ? 'inactive' : 'active',
            );
          }
          return e;
        }).toList();

    state = state.copyWith(memberList: updatedMembersList);
    await service.toggleScreenTime('${member.id}');
  }
}

final membersListProvider = FutureProvider((ref) async {
  return await ref.read(membersStateProvider.notifier).getMembers();
});
