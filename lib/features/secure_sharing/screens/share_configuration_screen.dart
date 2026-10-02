import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../documents/models/document_model.dart';
import '../providers/share_provider.dart';
import 'share_confirmation_screen.dart';

class ShareConfigurationScreen extends StatefulWidget {
  final DocumentModel document;

  const ShareConfigurationScreen({
    super.key,
    required this.document,
  });

  @override
  State<ShareConfigurationScreen> createState() => _ShareConfigurationScreenState();
}

class _ShareConfigurationScreenState extends State<ShareConfigurationScreen> {
  final TextEditingController _recipientController = TextEditingController(text: 'HDFC Bank KYC Verification');
  final TextEditingController _pinController = TextEditingController();

  int _selectedDurationHours = 24;
  bool _allowDownload = false;
  bool _enforceWatermark = true;
  bool _isPasswordProtected = true;

  void _onGenerateShare() async {
    final provider = context.read<ShareProvider>();
    final share = await provider.createShare(
      document: widget.document,
      recipientLabel: _recipientController.text,
      durationHours: _selectedDurationHours,
      allowDownload: _allowDownload,
      enforceWatermark: _enforceWatermark,
      isPasswordProtected: _isPasswordProtected,
      accessPin: _pinController.text,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ShareConfirmationScreen(share: share),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShareProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Configure Secure Share'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Document Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.document.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            'NO. ${widget.document.maskedDocumentNumber}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Recipient / Purpose Label',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _recipientController,
                decoration: const InputDecoration(
                  labelText: 'Recipient Name or Purpose',
                  hintText: 'e.g. Bank KYC / Employer HR',
                  prefixIcon: Icon(Icons.business_rounded),
                ),
              ),
              const SizedBox(height: 24),

              // Access Expiry Duration Selector
              Text(
                'Access Duration Expiry',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildChoiceChip('1 Hour', 1),
                  _buildChoiceChip('24 Hours', 24),
                  _buildChoiceChip('7 Days', 168),
                  _buildChoiceChip('Permanent', 0),
                ],
              ),
              const SizedBox(height: 24),

              // Access Permissions & Security
              Text(
                'Permissions & Access Security',
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
                    SwitchListTile(
                      title: const Text('Enforce Anti-Tamper Watermark', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Overlay "DIGIVAULT VERIFIED" watermark across document canvas'),
                      value: _enforceWatermark,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _enforceWatermark = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Allow Document Download', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Permit recipient to download raw PDF copy'),
                      value: _allowDownload,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _allowDownload = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Password Access Protection', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Require 4-digit PIN to open share link'),
                      value: _isPasswordProtected,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _isPasswordProtected = val),
                    ),
                    if (_isPasswordProtected) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          decoration: const InputDecoration(
                            labelText: '4-Digit Access PIN',
                            counterText: '',
                            prefixIcon: Icon(Icons.key_rounded),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: 'Generate Secure Share Link',
                isLoading: provider.isLoading,
                icon: Icons.link_rounded,
                onPressed: _onGenerateShare,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, int hours) {
    final isSelected = _selectedDurationHours == hours;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedDurationHours = hours),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
