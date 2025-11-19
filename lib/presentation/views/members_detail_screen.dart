import 'package:flutter/material.dart';
import 'package:onehaven_caregiver_app/data/models/member.dart';
import 'package:onehaven_caregiver_app/presentation/widgets/info_card.dart';

class MembersDetailScreen extends StatefulWidget {
  const MembersDetailScreen({super.key, required this.member});

  final Member member;

  @override
  State<MembersDetailScreen> createState() => _MembersDetailScreenState();
}

class _MembersDetailScreenState extends State<MembersDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Member Details'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('${widget.member.avatar}'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.member.fullName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.member.relationship}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoCard(
                    icon: Icons.person_outline,
                    label: 'Full Name',
                    value: widget.member.fullName,
                  ),
                  InfoCard(
                    icon: Icons.cake_outlined,
                    label: 'Age',
                    value: '${widget.member.age} years old',
                  ),
                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    label: 'Birth Year',
                    value: widget.member.birthYear.toString(),
                  ),
                  InfoCard(
                    icon: Icons.family_restroom,
                    label: 'Relationship',
                    value: '${widget.member.relationship}',
                  ),
                  InfoCard(
                    icon: Icons.info_outline,
                    label: 'Status',
                    value: '${widget.member.status?.toUpperCase()}',
                    valueColor:
                        widget.member.status == 'active'
                            ? Colors.teal[700]
                            : Colors.white70,
                  ),
                  InfoCard(
                    icon: Icons.screen_lock_portrait_outlined,
                    label: 'Screen Time',
                    value:
                        widget.member.screenTimeEnabled ?? false
                            ? 'Enabled'
                            : 'Disabled',
                    valueColor:
                        widget.member.screenTimeEnabled ?? false
                            ? Colors.teal[700]
                            : Colors.white70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
