import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../documents/models/document_model.dart';
import '../../../core/widgets/custom_button.dart';

class DigitalSignatureDetailsScreen extends StatelessWidget {
  final DocumentModel document;

  const DigitalSignatureDetailsScreen({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    final sig = document.digitalSignatureInfo;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Digital Signature Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.verified_rounded, color: AppColors.tertiary, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sig['status'] ?? 'Valid Digital Signature',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.tertiary),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'X.509 Cryptographic Certificate Chain Verified',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Academic Disclaimer Callout Box (as required by prompt Phase 4.D)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.secondary, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Academic Prototype Notice: Cryptographic verification is simulated against standard X.509 PKI certificate attributes for demonstration purposes.',
                        style: TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Certificate Attributes',
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
                    _buildRow('Signer Authority', sig['signerName'] ?? '-'),
                    const Divider(height: 1),
                    _buildRow('Certificate Serial Number', sig['certificateId'] ?? '-', isMono: true),
                    const Divider(height: 1),
                    _buildRow('Cryptographic Algorithm', sig['algorithm'] ?? '-'),
                    const Divider(height: 1),
                    _buildRow('SHA-256 Fingerprint', sig['sha256Fingerprint'] ?? '-', isMono: true),
                    const Divider(height: 1),
                    _buildRow('Timestamping Authority (TSA)', sig['tsaName'] ?? '-'),
                    const Divider(height: 1),
                    _buildRow('Timestamp', sig['timestamp'] ?? '-'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isMono = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: isMono ? 'monospace' : null,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
