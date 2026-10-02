class ShareModel {
  final String id;
  final String documentId;
  final String documentTitle;
  final String issuerName;
  final String shareToken;
  final String recipientLabel;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int accessCount;
  final int maxAccessLimit;
  final bool allowDownload;
  final bool enforceWatermark;
  final bool isPasswordProtected;
  final String accessPin;
  final String status; // ACTIVE, EXPIRED, REVOKED

  ShareModel({
    required this.id,
    required this.documentId,
    required this.documentTitle,
    required this.issuerName,
    required this.shareToken,
    this.recipientLabel = 'Public Share Link',
    required this.createdAt,
    required this.expiresAt,
    this.accessCount = 0,
    this.maxAccessLimit = 10,
    this.allowDownload = false,
    this.enforceWatermark = true,
    this.isPasswordProtected = false,
    this.accessPin = '',
    this.status = 'ACTIVE',
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt) || status == 'EXPIRED';
  bool get isRevoked => status == 'REVOKED';
  bool get isValid => !isExpired && !isRevoked;

  ShareModel copyWith({
    String? status,
    int? accessCount,
  }) {
    return ShareModel(
      id: id,
      documentId: documentId,
      documentTitle: documentTitle,
      issuerName: issuerName,
      shareToken: shareToken,
      recipientLabel: recipientLabel,
      createdAt: createdAt,
      expiresAt: expiresAt,
      accessCount: accessCount ?? this.accessCount,
      maxAccessLimit: maxAccessLimit,
      allowDownload: allowDownload,
      enforceWatermark: enforceWatermark,
      isPasswordProtected: isPasswordProtected,
      accessPin: accessPin,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'documentId': documentId,
    'documentTitle': documentTitle,
    'issuerName': issuerName,
    'shareToken': shareToken,
    'recipientLabel': recipientLabel,
    'createdAt': createdAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'accessCount': accessCount,
    'maxAccessLimit': maxAccessLimit,
    'allowDownload': allowDownload,
    'enforceWatermark': enforceWatermark,
    'isPasswordProtected': isPasswordProtected,
    'accessPin': accessPin,
    'status': status,
  };

  factory ShareModel.fromJson(Map<String, dynamic> json) => ShareModel(
    id: json['id'] ?? '',
    documentId: json['documentId'] ?? '',
    documentTitle: json['documentTitle'] ?? '',
    issuerName: json['issuerName'] ?? '',
    shareToken: json['shareToken'] ?? '',
    recipientLabel: json['recipientLabel'] ?? 'Shared Link',
    createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().add(const Duration(days: 1)).toIso8601String()),
    accessCount: json['accessCount'] ?? 0,
    maxAccessLimit: json['maxAccessLimit'] ?? 10,
    allowDownload: json['allowDownload'] ?? false,
    enforceWatermark: json['enforceWatermark'] ?? true,
    isPasswordProtected: json['isPasswordProtected'] ?? false,
    accessPin: json['accessPin'] ?? '',
    status: json['status'] ?? 'ACTIVE',
  );
}
