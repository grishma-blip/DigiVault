import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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
                    const Icon(Icons.gavel_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Governed by Rule 9A of Information Technology (Preservation and Retention of Information) Rules 2016',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'DigiLocker Terms of Service & Legal Framework',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Effective Date: October 2026',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              _buildSection(
                context,
                title: '1. Legal Validity of Digital Documents',
                content:
                    'Per Rule 9A of the Information Technology (Preservation and Retention of Information by Intermediaries Providing Digital Locker Facilities) Rules 2016, documents issued into DigiLocker are treated at par with original physical documents.',
              ),
              _buildSection(
                context,
                title: '2. Citizen Responsibilities',
                content:
                    'You are responsible for maintaining the confidentiality of your 6-digit Security PIN and OTP credentials. Any action taken via your authenticated session shall be deemed authorized by you.',
              ),
              _buildSection(
                context,
                title: '3. Issuer Integration & Verification Seals',
                content:
                    'Documents fetched directly from authorized issuers carry SHA-256 PKI digital signatures. Alteration, tampering, or misrepresentation of digital credentials constitutes a punishable offense under Indian Penal Code and IT Act provisions.',
              ),
              _buildSection(
                context,
                title: '4. Storage & Fair Usage Terms',
                content:
                    'Basic accounts receive 1 GB of free secure cloud vault storage. Additional storage up to 6 GB is available via the Premium Vault plan (₹99/year). Storage is intended solely for personal official certificates and documents.',
              ),
              _buildSection(
                context,
                title: '5. Limitation of Liability',
                content:
                    'DigiLocker provides e-document storage and sharing enablement. Issuer departments remain responsible for the accuracy and issuance status of their respective certificates.',
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
