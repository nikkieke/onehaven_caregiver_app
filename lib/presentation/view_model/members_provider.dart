import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onehaven_caregiver_app/data/models/member.dart';
import 'package:onehaven_caregiver_app/data/services/members_service.dart';

enum MemberLoadingState { idle, loadingMembers, syncing }

class MemberState {
  MemberState({
    this.loadingState = MemberLoadingState.idle,
    this.toggle = false,
    this.memberList = const [],
    this.member,
    this.queueChanges = 0,
  });

  final List<Member>? memberList;
  final MemberLoadingState? loadingState;
  final bool? toggle;
  final Member? member;
  final int? queueChanges;

  MemberState copyWith({
    List<Member>? memberList,
    MemberLoadingState? loadingState,
    bool? toggle,
    Member? member,
    int? queueChanges,
  }) {
    return MemberState(
      memberList: memberList ?? this.memberList,
      toggle: toggle ?? this.toggle,
      loadingState: loadingState ?? this.loadingState,
      member: member ?? this.member,
      queueChanges: queueChanges ?? this.queueChanges,
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

  Future<List<Member>> updateMembersFromCache() async {
    final members = service.getMembersFromCache();
    final queuedChanges = await service.getPendingLength();
    state = state.copyWith(memberList: members, queueChanges: queuedChanges);
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

    await service.toggleScreenTime('${member.id}');
    final queuedChanges = await service.getPendingLength();
    state = state.copyWith(
      queueChanges: queuedChanges,
      memberList: updatedMembersList,
    );
  }

  Future<void> syncOfflineUpdates() async {
    state = state.copyWith(loadingState: MemberLoadingState.syncing);
    await service.syncOfflineUpdates();
    final queuedChanges = await service.getPendingLength();
    state = state.copyWith(
      loadingState: MemberLoadingState.idle,
      queueChanges: queuedChanges,
    );
  }
}

final membersListProvider = FutureProvider((ref) async {
  return await ref.read(membersStateProvider.notifier).getMembers();
});

final internetCheckerProvider = StreamProvider<bool>((ref) {
  return InternetConnectionChecker.instance.onStatusChange.map((status) {
    return status == InternetConnectionStatus.connected;
  });
});
