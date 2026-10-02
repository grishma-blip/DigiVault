class PartnerApiModel {
  final String id;
  final String partnerName;
  final String logoUrl;
  final String purpose;
  final String grantedPermissions;
  final DateTime authorizedAt;
  final DateTime expiresAt;
  final bool isApproved;
  final int totalRequestsHandled;

  PartnerApiModel({
    required this.id,
    required this.partnerName,
    required this.logoUrl,
    required this.purpose,
    required this.grantedPermissions,
    required this.authorizedAt,
    required this.expiresAt,
    this.isApproved = true,
    this.totalRequestsHandled = 0,
  });

  PartnerApiModel copyWith({bool? isApproved}) {
    return PartnerApiModel(
      id: id,
      partnerName: partnerName,
      logoUrl: logoUrl,
      purpose: purpose,
      grantedPermissions: grantedPermissions,
      authorizedAt: authorizedAt,
      expiresAt: expiresAt,
      isApproved: isApproved ?? this.isApproved,
      totalRequestsHandled: totalRequestsHandled,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'partnerName': partnerName,
    'logoUrl': logoUrl,
    'purpose': purpose,
    'grantedPermissions': grantedPermissions,
    'authorizedAt': authorizedAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'isApproved': isApproved,
    'totalRequestsHandled': totalRequestsHandled,
  };

  factory PartnerApiModel.fromJson(Map<String, dynamic> json) => PartnerApiModel(
    id: json['id'] ?? '',
    partnerName: json['partnerName'] ?? '',
    logoUrl: json['logoUrl'] ?? '',
    purpose: json['purpose'] ?? '',
    grantedPermissions: json['grantedPermissions'] ?? '',
    authorizedAt: DateTime.parse(json['authorizedAt'] ?? DateTime.now().toIso8601String()),
    expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().add(const Duration(days: 30)).toIso8601String()),
    isApproved: json['isApproved'] ?? true,
    totalRequestsHandled: json['totalRequestsHandled'] ?? 0,
  );
}
