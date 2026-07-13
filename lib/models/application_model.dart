class ApplicationModel {
  final String id;
  final String opportunityId;
  final String opportunityTitle;
  final String studentUid;
  final String studentName;
  final String coverNote;
  final String status; // "pending" | "accepted" | "rejected"
  final DateTime appliedAt;

  ApplicationModel({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.studentUid,
    required this.studentName,
    required this.coverNote,
    this.status = 'pending',
    required this.appliedAt,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map, String id) {
    return ApplicationModel(
      id: id,
      opportunityId: map['opportunityId'] ?? '',
      opportunityTitle: map['opportunityTitle'] ?? '',
      studentUid: map['studentUid'] ?? '',
      studentName: map['studentName'] ?? '',
      coverNote: map['coverNote'] ?? '',
      status: map['status'] ?? 'pending',
      appliedAt: map['appliedAt'] != null
          ? DateTime.parse(map['appliedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'studentUid': studentUid,
      'studentName': studentName,
      'coverNote': coverNote,
      'status': status,
      'appliedAt': appliedAt.toIso8601String(),
    };
  }
}