import 'package:hive_flutter/hive_flutter.dart';

part 'member.g.dart';

@HiveType(typeId: 1)
class Member extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? firstName;

  @HiveField(2)
  final String? lastName;

  @HiveField(3)
  final int? birthYear;

  @HiveField(4)
  final String? relationship;

  @HiveField(5)
  final String? avatar;

  @HiveField(6)
  final String? status;

  @HiveField(7)
  final bool? screenTimeEnabled;

  Member({
    this.id,
    this.firstName,
    this.lastName,
    this.birthYear = 0,
    this.relationship,
    this.avatar,
    this.status,
    this.screenTimeEnabled = false,
  });

  int get age => DateTime.now().year - (birthYear ?? 0);

  String get fullName => '$firstName $lastName';

  // From JSON
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthYear: json['birthYear'],
      relationship: json['relationship'],
      avatar: json['avatar'],
      status: json['status'],
      screenTimeEnabled: json['screenTimeEnabled'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthYear': birthYear,
      'relationship': relationship,
      'avatar': avatar,
      'status': status,
      'screenTimeEnabled': screenTimeEnabled,
    };
  }

  Member copyWith({
    String? id,
    String? firstName,
    String? lastName,
    int? birthYear,
    String? relationship,
    String? avatar,
    bool? screenTimeEnabled,
    String? status,
  }) {
    return Member(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthYear: birthYear ?? this.birthYear,
      relationship: relationship ?? this.relationship,
      avatar: avatar ?? this.avatar,
      screenTimeEnabled: screenTimeEnabled ?? this.screenTimeEnabled,
      status: status ?? this.status,
    );
  }
}

@HiveType(typeId: 2)
class MembersList {
  MembersList({this.members});

  @HiveField(0)
  final List<Member>? members;
}
