class OpportunityModel {
  final String id;
  final String startupId;
  final String startupName; // denormalized so we don't refetch startup per card
  final String title;
  final String description;
  final String roleType; // e.g. "Software Development", "Design", "Marketing"
  final String commitment; // e.g. "5 hrs/week"
  final String status; // "open" | "closed"
  final DateTime createdAt;

  OpportunityModel({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.roleType,
    required this.commitment,
    this.status = 'open',
    required this.createdAt,
  });

  factory OpportunityModel.fromMap(Map<String, dynamic> map, String id) {
    return OpportunityModel(
      id: id,
      startupId: map['startupId'] ?? '',
      startupName: map['startupName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      roleType: map['roleType'] ?? '',
      commitment: map['commitment'] ?? '',
      status: map['status'] ?? 'open',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startupId': startupId,
      'startupName': startupName,
      'title': title,
      'description': description,
      'roleType': roleType,
      'commitment': commitment,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}