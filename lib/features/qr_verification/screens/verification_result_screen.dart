import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

class VerificationResultScreen extends StatelessWidget {
  final String rawPayload;
  final Map<String, dynamic> verificationResult;

  const VerificationResultScreen({
    super.key,
    required this.rawPayload,
    required this.verificationResult,
  });

  @override
  Widget build(BuildContext context) {
    final bool isValid = verificationResult['isValid'] ?? false;
    final docType = verificationResult['documentType'] ?? 'Government Credential';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('QR Verification Result'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Result Card Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isValid ? AppColors.tertiaryContainer : AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isValid ? AppColors.tertiary : AppColors.error,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isValid ? Icons.verified_user_rounded : Icons.gpp_bad_rounded,
                      size: 56,
                      color: isValid ? AppColors.tertiary : AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isValid ? 'Authentic $docType' : 'Verification Failed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isValid ? AppColors.tertiary : AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isValid
                          ? 'X.509 PKI Digital Signature Verified Against National Root CA'
                          : 'Cryptographic checksum mismatch or unauthenticated issuer key.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isValid ? AppColors.tertiary : AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (isValid) ...[
                Text(
                  'Verified Credential Attributes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildAttrRow('Credential Category', docType),
                      const Divider(height: 1),
                      _buildAttrRow('Document ID / Ref', verificationResult['documentId'] ?? '-'),
                      const Divider(height: 1),
                      _buildAttrRow('Citizen Holder', verificationResult['holder'] ?? '-'),
                      const Divider(height: 1),
                      _buildAttrRow('Issuer Department', verificationResult['issuer'] ?? '-'),

                      if (verificationResult.containsKey('vehicleClass')) ...[
                        const Divider(height: 1),
                        _buildAttrRow('Authorized Vehicle Class', verificationResult['vehicleClass']),
                      ],
                      if (verificationResult.containsKey('dob')) ...[
                        const Divider(height: 1),
                        _buildAttrRow('Date of Birth', verificationResult['dob']),
                      ],
                      if (verificationResult.containsKey('gender')) ...[
                        const Divider(height: 1),
                        _buildAttrRow('Gender', verificationResult['gender']),
                      ],
                      if (verificationResult.containsKey('fatherName')) ...[
                        const Divider(height: 1),
                        _buildAttrRow("Father's Name", verificationResult['fatherName']),
                      ],
                      if (verificationResult.containsKey('cgpa')) ...[
                        const Divider(height: 1),
                        _buildAttrRow('Cumulative Grade (CGPA)', verificationResult['cgpa']),
                      ],
                      if (verificationResult.containsKey('issueDate')) ...[
                        const Divider(height: 1),
                        _buildAttrRow('Issue Date', verificationResult['issueDate']),
                      ],
                      if (verificationResult.containsKey('expiryDate')) ...[
                        const Divider(height: 1),
                        _buildAttrRow('Expiry Date', verificationResult['expiryDate']),
                      ],

                      const Divider(height: 1),
                      _buildAttrRow('SHA-256 Digest Hash', verificationResult['hash'] ?? '-', isMono: true),
                      const Divider(height: 1),
                      _buildAttrRow('Signature Protocol', verificationResult['signatureAlgorithm'] ?? '-'),
                      const Divider(height: 1),
                      _buildAttrRow('Root CA Authority', verificationResult['caIssuer'] ?? '-'),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),

              CustomButton(
                text: 'Back to Scanner',
                onPressed: () => Navigator.pop(context),
                icon: Icons.check_circle_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttrRow(String label, String value, {bool isMono = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: isMono ? 'monospace' : null,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
