import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onehaven_caregiver_app/presentation/view_model/members_provider.dart';
import 'package:onehaven_caregiver_app/presentation/views/members_detail_screen.dart';
import 'package:onehaven_caregiver_app/presentation/widgets/error_widget.dart';
import 'package:onehaven_caregiver_app/presentation/widgets/loading_widget.dart';
import 'package:onehaven_caregiver_app/presentation/widgets/members_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(membersListProvider);
    final notifier = ref.read(membersStateProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Protected Members'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: provider.when(
        data: (_) {
          final members = ref.watch(membersStateProvider).memberList ?? [];
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              print('heree');
              return ref.invalidate(membersListProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return MemberCard(
                  member: member,
                  onScreenTimeToggle: (value) {
                    notifier.toggle(index);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MembersDetailScreen(member: member),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        error: (error, st) {
          print('error here ${error} st $st');
          return MemberErrorWidget(
            loadMembers: () {
              ref.invalidate(membersListProvider);
            },
          );
        },
        loading: () {
          return LoadingWidget();
        },
      ),
    );
  }
}
