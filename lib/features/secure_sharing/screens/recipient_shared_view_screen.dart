import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/share_provider.dart';
import '../../documents/providers/document_provider.dart';

class RecipientSharedViewScreen extends StatefulWidget {
  final String shareToken;

  const RecipientSharedViewScreen({
    super.key,
    required this.shareToken,
  });

  @override
  State<RecipientSharedViewScreen> createState() => _RecipientSharedViewScreenState();
}

class _RecipientSharedViewScreenState extends State<RecipientSharedViewScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isAuthenticated = false;
  String _pinError = '';

  @override
  Widget build(BuildContext context) {
    final shareProvider = context.watch<ShareProvider>();
    final share = shareProvider.getShareByToken(widget.shareToken);

    // 1. Invalid or Revoked Token View
    if (share == null || !share.isValid) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Shared Document Access')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.block_rounded, size: 56, color: AppColors.error),
                ),
                const SizedBox(height: 20),
                Text(
                  'Access Denied or Revoked',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  share == null
                      ? 'The requested share token is invalid or does not exist.'
                      : 'The owner of this document has revoked access or the link duration has expired.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Close Window',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. PIN Protection Prompt View
    if (share.isPasswordProtected && !_isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('PIN Protected Share')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_person_rounded, size: 56, color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Enter Access PIN',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'This shared credential requires a 4-digit PIN configured by the owner. Demo PIN: ${share.accessPin}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 28),

                TextField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, letterSpacing: 12, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '••••',
                    errorText: _pinError.isEmpty ? null : _pinError,
                  ),
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: 'Authorize Access',
                  onPressed: () {
                    if (_pinController.text == share.accessPin) {
                      shareProvider.incrementAccessCount(share.id);
                      setState(() => _isAuthenticated = true);
                    } else {
                      setState(() => _pinError = 'Incorrect PIN. Try demo PIN "${share.accessPin}".');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. Authorized Shared Document Viewer View
    final docProvider = context.watch<DocumentProvider>();
    final targetDoc = docProvider.allDocuments.firstWhere(
      (d) => d.id == share.documentId,
      orElse: () => docProvider.allDocuments.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: Text(share.recipientLabel),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.tertiaryContainer,
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.tertiary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AUTHORIZED VIEW ONLY • Expires in ${share.expiresAt.difference(DateTime.now()).inHours} Hours',
                      style: const TextStyle(color: AppColors.tertiary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            targetDoc.title.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary),
                          ),
                          Text(
                            targetDoc.issuerName,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const Divider(height: 24),
                          Text('Holder: ${targetDoc.holderName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Doc Number: ${targetDoc.maskedDocumentNumber}', style: const TextStyle(fontFamily: 'monospace')),
                          const SizedBox(height: 6),
                          Text('Checksum: ${targetDoc.checksum}', style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                        ],
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Center(
                            child: Transform.rotate(
                              angle: -0.4,
                              child: Text(
                                'SHARED VIA DIGIVAULT • VIEW ONLY',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary.withOpacity(0.1),
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
          ],
        ),
      ),
    );
  }
}
