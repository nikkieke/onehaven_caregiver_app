import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onehaven_caregiver_app/presentation/view_model/members_provider.dart';
import 'package:onehaven_caregiver_app/presentation/widgets/status_chip.dart';

class SyncIndicator extends ConsumerStatefulWidget {
  const SyncIndicator({super.key});

  @override
  ConsumerState<SyncIndicator> createState() => _SyncIndicatorState();
}

class _SyncIndicatorState extends ConsumerState<SyncIndicator> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(membersStateProvider);
    final isSyncing = state.loadingState == MemberLoadingState.syncing;
    final queuedChanges = state.queueChanges ?? 0;
    final queued = queuedChanges > 0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          isSyncing
              ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[700]!),
                ),
              )
              : Icon(
                queued ? Icons.sync : Icons.cloud_done,
                color: queued ? Colors.orange[700] : Colors.green[700],
                size: 20,
              ),
          const SizedBox(width: 12),

          // Status text
          StatusChip(
            label: queued ? 'Queued: $queuedChanges' : 'Synced',
            bgColor: queued ? Colors.orange[100]! : Colors.green[100]!,
            textColor: queued ? Colors.orange[700]! : Colors.green[700]!,
          ),
        ],
      ),
    );
  }
}
