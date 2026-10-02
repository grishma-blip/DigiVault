import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.12)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Compliant with IT Act 2000 & Digital Personal Data Protection Act (DPDP) 2023',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'DigiLocker Document Wallet Privacy Policy',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Last Updated: October 2026',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              _buildSection(
                context,
                title: '1. Information We Collect',
                content:
                    'To provide e-document vault services, DigiLocker collects official identity metadata (such as Aadhaar e-KYC reference, Mobile Number, and URN numbers) solely for authenticating your identity with registered government issuers (UIDAI, MoRTH, CBSE, Income Tax Department).',
              ),
              _buildSection(
                context,
                title: '2. Document Cryptography & Storage Security',
                content:
                    'All issued documents stored in your vault are encrypted using AES-256 bit encryption at rest and TLS 1.3 in transit. DigiLocker does not sell, rent, or monetize citizen data to any third party.',
              ),
              _buildSection(
                context,
                title: '3. Time-Bound Consent Sharing',
                content:
                    'When you share a document via a time-bound access token, only the specified recipient can view the document within the selected validity window. Access automatically expires upon timer completion, and access logs are recorded in your security audit center.',
              ),
              _buildSection(
                context,
                title: '4. Biometric & Device Security',
                content:
                    'Local security credentials such as your 6-digit Security PIN and biometric hashes (Fingerprint/Face Unlock) remain strictly stored within your device hardware security enclave (Android Keystore / iOS Keychain). They are never transmitted to remote servers.',
              ),
              _buildSection(
                context,
                title: '5. Citizen Rights & Data Deletion',
                content:
                    'You retain full sovereignty over your digital vault. You may unlink issued documents, revoke shared link tokens, or delete your account data at any time through the Security Center.',
              ),
              _buildSection(
                context,
                title: '6. Grievance Redressal Officer',
                content:
                    'For privacy inquiries or grievance escalation under DPDP Act rules, contact the Data Protection Officer at dpo@digilocker.gov.in.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
