class DocumentModel {
  final String id;
  final String title;
  final String category;
  final String issuerName;
  final String issuerLogoUrl;
  final String rawDocumentNumber;
  final String maskedDocumentNumber;
  final String holderName;
  final String issueDate;
  final String expiryDate;
  final String status; // VERIFIED, PENDING SYNC, EXPIRING SOON, EXPIRED
  final String checksum;
  final bool isFavorite;
  final double fileSizeMb;
  final String fileType;
  final String qrPayload;
  final Map<String, dynamic> digitalSignatureInfo;

  DocumentModel({
    required this.id,
    required this.title,
    required this.category,
    required this.issuerName,
    required this.issuerLogoUrl,
    required this.rawDocumentNumber,
    required this.maskedDocumentNumber,
    required this.holderName,
    required this.issueDate,
    required this.expiryDate,
    this.status = 'VERIFIED',
    required this.checksum,
    this.isFavorite = false,
    required this.fileSizeMb,
    this.fileType = 'PDF',
    required this.qrPayload,
    required this.digitalSignatureInfo,
  });

  DocumentModel copyWith({
    String? title,
    String? category,
    String? status,
    bool? isFavorite,
    String? expiryDate,
  }) {
    return DocumentModel(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      issuerName: issuerName,
      issuerLogoUrl: issuerLogoUrl,
      rawDocumentNumber: rawDocumentNumber,
      maskedDocumentNumber: maskedDocumentNumber,
      holderName: holderName,
      issueDate: issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      checksum: checksum,
      isFavorite: isFavorite ?? this.isFavorite,
      fileSizeMb: fileSizeMb,
      fileType: fileType,
      qrPayload: qrPayload,
      digitalSignatureInfo: digitalSignatureInfo,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'issuerName': issuerName,
    'issuerLogoUrl': issuerLogoUrl,
    'rawDocumentNumber': rawDocumentNumber,
    'maskedDocumentNumber': maskedDocumentNumber,
    'holderName': holderName,
    'issueDate': issueDate,
    'expiryDate': expiryDate,
    'status': status,
    'checksum': checksum,
    'isFavorite': isFavorite,
    'fileSizeMb': fileSizeMb,
    'fileType': fileType,
    'qrPayload': qrPayload,
    'digitalSignatureInfo': digitalSignatureInfo,
  };

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? 'Identity',
    issuerName: json['issuerName'] ?? '',
    issuerLogoUrl: json['issuerLogoUrl'] ?? '',
    rawDocumentNumber: json['rawDocumentNumber'] ?? '',
    maskedDocumentNumber: json['maskedDocumentNumber'] ?? '',
    holderName: json['holderName'] ?? '',
    issueDate: json['issueDate'] ?? '',
    expiryDate: json['expiryDate'] ?? '',
    status: json['status'] ?? 'VERIFIED',
    checksum: json['checksum'] ?? '',
    isFavorite: json['isFavorite'] ?? false,
    fileSizeMb: (json['fileSizeMb'] as num?)?.toDouble() ?? 1.2,
    fileType: json['fileType'] ?? 'PDF',
    qrPayload: json['qrPayload'] ?? '',
    digitalSignatureInfo: Map<String, dynamic>.from(json['digitalSignatureInfo'] ?? {}),
  );
}
