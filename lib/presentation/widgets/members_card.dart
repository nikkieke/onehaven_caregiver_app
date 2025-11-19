import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onehaven_caregiver_app/data/models/member.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final Function(bool) onScreenTimeToggle;
  final VoidCallback onTap;

  const MemberCard({
    super.key,
    required this.member,
    required this.onScreenTimeToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black12,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  imageUrl: "${member.avatar}",
                  imageBuilder:
                      (context, imageProvider) => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  placeholder:
                      (context, url) =>
                          CircularProgressIndicator(color: Colors.teal),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  color: Colors.grey[200],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${member.age} years old',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            member.status == 'active'
                                ? Colors.green[50]
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${member.status}'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              member.status == 'active'
                                  ? Colors.green[700]
                                  : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Screen Time',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  Switch(
                    value: member.screenTimeEnabled ?? false,
                    onChanged: (value) {
                      onScreenTimeToggle(value);
                    },
                    activeColor: Colors.teal[700],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
