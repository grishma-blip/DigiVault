import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/document_model.dart';
import '../providers/document_provider.dart';
import 'document_viewer_screen.dart';
import '../../digital_signature/screens/digital_signature_details_screen.dart';
import '../../secure_sharing/screens/share_configuration_screen.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentModel document;

  const DocumentDetailsScreen({
    super.key,
    required this.document,
  });

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  bool _showRawNumber = false;

  void _showQrCodeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.qr_code_2_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Verification QR Code'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: QrImageView(
                data: widget.document.qrPayload,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Scannable by law enforcement & authorized issuers.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Document?'),
        content: Text('Are you sure you want to remove ${widget.document.title} from your vault?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<DocumentProvider>().deleteDocument(widget.document.id);
              if (mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to library
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.document;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Credential Details'),
        actions: [
          IconButton(
            icon: Icon(
              doc.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: doc.isFavorite ? Colors.amber[700] : AppColors.textMuted,
            ),
            onPressed: () {
              context.read<DocumentProvider>().toggleFavorite(doc.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1.2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(15, 23, 42, 0.04),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 28),
                        ),
                        StatusBadge(status: doc.status),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      doc.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc.issuerName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons Row (View Fullscreen, Digital Signature, Share)
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'View Document',
                      icon: Icons.visibility_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DocumentViewerScreen(document: doc),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Share Link',
                      icon: Icons.share_rounded,
                      isOutlined: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShareConfigurationScreen(document: doc),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              CustomButton(
                text: 'View PKI Digital Signature & Certificates',
                icon: Icons.verified_rounded,
                isOutlined: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DigitalSignatureDetailsScreen(document: doc),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // QR Code Card Trigger
              GestureDetector(
                onTap: () => _showQrCodeModal(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: QrImageView(
                          data: doc.qrPayload,
                          version: QrVersions.auto,
                          size: 40.0,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Offline QR Verification Code',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Tap to expand scannable QR code',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Metadata Details Section
              Text(
                'Document Metadata',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                    _buildMetaTile(
                      context,
                      label: 'Holder Name',
                      value: doc.holderName,
                      icon: Icons.person_outline_rounded,
                    ),
                    const Divider(height: 1),
                    _buildMetaTile(
                      context,
                      label: 'Document Identifier',
                      value: _showRawNumber ? doc.rawDocumentNumber : doc.maskedDocumentNumber,
                      icon: Icons.badge_outlined,
                      trailingWidget: IconButton(
                        icon: Icon(_showRawNumber ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20),
                        onPressed: () => setState(() => _showRawNumber = !_showRawNumber),
                      ),
                    ),
                    const Divider(height: 1),
                    _buildMetaTile(
                      context,
                      label: 'Issue Date',
                      value: doc.issueDate,
                      icon: Icons.calendar_today_outlined,
                    ),
                    const Divider(height: 1),
                    _buildMetaTile(
                      context,
                      label: 'Expiry Date',
                      value: doc.expiryDate,
                      icon: Icons.event_available_outlined,
                    ),
                    const Divider(height: 1),
                    _buildMetaTile(
                      context,
                      label: 'SHA-256 Checksum',
                      value: doc.checksum,
                      icon: Icons.tag_rounded,
                      isMono: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Widget? trailingWidget,
    bool isMono = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: isMono ? 'monospace' : null,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (trailingWidget != null) trailingWidget,
        ],
      ),
    );
  }
}
