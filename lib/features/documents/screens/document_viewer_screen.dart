import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/document_model.dart';

class DocumentViewerScreen extends StatelessWidget {
  final DocumentModel document;

  const DocumentViewerScreen({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Official Dark Canvas Mode
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: Text(document.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download Encrypted PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading official DigiLocker cryptographically signed PDF...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print_rounded),
            tooltip: 'Print Certificate',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preparing document for secure printing...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Verification Status Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.white.withOpacity(0.08),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.tertiaryContainer, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'DIGILOCKER VERIFIED • ${document.issuerName.toUpperCase()}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SHA-256: ${document.checksum.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),

            // Interactive Document Image / Canvas Preview
            Expanded(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 3.5,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 25,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Official Document Certificate Layout
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Government Emblem & Official Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          document.issuerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: AppColors.primary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'GOVERNMENT OF INDIA • DIGITAL INDIA REPOSITORY',
                                          style: TextStyle(fontSize: 9, color: AppColors.textSecondary, letterSpacing: 0.5, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 28),
                                  ),
                                ],
                              ),
                              const Divider(height: 28, thickness: 1.5),

                              Center(
                                child: Text(
                                  document.title.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Document Details Grid
                              _buildDocRow('Name of Citizen', document.holderName),
                              const SizedBox(height: 10),
                              if (document.category == 'Identity') ...[
                                _buildDocRow('Date of Birth (DOB)', '21/11/2005'),
                                const SizedBox(height: 10),
                                _buildDocRow('Gender', 'Male / पुरुष'),
                                const SizedBox(height: 10),
                              ],
                              _buildDocRow('Document Number', document.maskedDocumentNumber, isMono: true),
                              const SizedBox(height: 10),
                              _buildDocRow('Date of Issuance', document.issueDate),
                              const SizedBox(height: 10),
                              _buildDocRow('Validity / Expiry', document.expiryDate),
                              const SizedBox(height: 24),

                              // Bottom Certificate Authority Stamp
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Digitally Signed by:', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                        const SizedBox(height: 2),
                                        Text(
                                          document.issuerName,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text('Timestamp: ${document.issueDate}', style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.tertiaryContainer,
                                      border: Border.all(color: AppColors.tertiary, width: 1.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified_rounded, color: AppColors.tertiary, size: 16),
                                        SizedBox(width: 4),
                                        Text('DIGILOCKER SIGNED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Watermark Overlay
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Center(
                              child: Transform.rotate(
                                angle: -0.4,
                                child: Text(
                                  'DIGILOCKER VERIFIED • GOVT OF INDIA',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary.withOpacity(0.06),
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocRow(String label, String value, {bool isMono = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: isMono ? 'monospace' : null,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
