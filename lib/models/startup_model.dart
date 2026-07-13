class StartupModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String founderUid;
  final bool verified;
  final String? logoUrl;
  final DateTime createdAt;

  StartupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.founderUid,
    this.verified = false,
    this.logoUrl,
    required this.createdAt,
  });

  factory StartupModel.fromMap(Map<String, dynamic> map, String id) {
    return StartupModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      founderUid: map['founderUid'] ?? '',
      verified: map['verified'] ?? false,
      logoUrl: map['logoUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'founderUid': founderUid,
      'verified': verified,
      'logoUrl': logoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}