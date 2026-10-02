import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../models/share_model.dart';
import 'recipient_shared_view_screen.dart';

class ShareConfirmationScreen extends StatelessWidget {
  final ShareModel share;

  const ShareConfirmationScreen({
    super.key,
    required this.share,
  });

  @override
  Widget build(BuildContext context) {
    final shareUrl = 'https://digivault.app/v/${share.shareToken}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Share Link Created'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Success Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.tertiary),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 56, color: AppColors.tertiary),
                    SizedBox(height: 12),
                    Text(
                      'Secure Share Active',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.tertiary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Encrypted token generated with active access restrictions.',
                      style: TextStyle(fontSize: 12, color: AppColors.tertiary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // QR Code Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: shareUrl,
                      version: QrVersions.auto,
                      size: 180.0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Scan to Open Shared Credential',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),

                    // Link Container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              shareUrl,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Share URL copied to clipboard!')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Test Link as Recipient Button
              CustomButton(
                text: 'Test Link as Recipient',
                icon: Icons.open_in_browser_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipientSharedViewScreen(shareToken: share.shareToken),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              CustomButton(
                text: 'Done',
                isOutlined: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
