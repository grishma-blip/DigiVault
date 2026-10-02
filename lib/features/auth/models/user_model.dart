class UserModel {
  final String id;
  final String fullName;
  final String gender;
  final String dob;
  final String mobileNumber;
  final String email;
  final String aadhaarLast4;
  final bool isBiometricEnabled;
  final bool isPinSet;
  final String securityPin;
  final bool isPremium;
  final double usedStorageMb;
  final double totalStorageMb;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.fullName,
    this.gender = 'Male',
    this.dob = '21/11/2005',
    required this.mobileNumber,
    required this.email,
    required this.aadhaarLast4,
    this.isBiometricEnabled = true,
    this.isPinSet = true,
    this.securityPin = '1234',
    this.isPremium = false,
    this.usedStorageMb = 142.5,
    this.totalStorageMb = 1024.0, // 1 GB free
    this.avatarUrl = '',
  });

  UserModel copyWith({
    String? fullName,
    String? gender,
    String? dob,
    String? mobileNumber,
    String? email,
    bool? isBiometricEnabled,
    bool? isPinSet,
    String? securityPin,
    bool? isPremium,
    double? usedStorageMb,
    double? totalStorageMb,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      aadhaarLast4: aadhaarLast4,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isPinSet: isPinSet ?? this.isPinSet,
      securityPin: securityPin ?? this.securityPin,
      isPremium: isPremium ?? this.isPremium,
      usedStorageMb: usedStorageMb ?? this.usedStorageMb,
      totalStorageMb: totalStorageMb ?? this.totalStorageMb,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'gender': gender,
    'dob': dob,
    'mobileNumber': mobileNumber,
    'email': email,
    'aadhaarLast4': aadhaarLast4,
    'isBiometricEnabled': isBiometricEnabled,
    'isPinSet': isPinSet,
    'securityPin': securityPin,
    'isPremium': isPremium,
    'usedStorageMb': usedStorageMb,
    'totalStorageMb': totalStorageMb,
    'avatarUrl': avatarUrl,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] ?? '',
    fullName: json['fullName'] ?? 'Grishma Thakare',
    gender: json['gender'] ?? 'Male',
    dob: json['dob'] ?? '21/11/2005',
    mobileNumber: json['mobileNumber'] ?? '',
    email: json['email'] ?? '',
    aadhaarLast4: json['aadhaarLast4'] ?? '9812',
    isBiometricEnabled: json['isBiometricEnabled'] ?? true,
    isPinSet: json['isPinSet'] ?? true,
    securityPin: json['securityPin'] ?? '1234',
    isPremium: json['isPremium'] ?? false,
    usedStorageMb: (json['usedStorageMb'] as num?)?.toDouble() ?? 142.5,
    totalStorageMb: (json['totalStorageMb'] as num?)?.toDouble() ?? 1024.0,
    avatarUrl: json['avatarUrl'] ?? '',
  );
}
