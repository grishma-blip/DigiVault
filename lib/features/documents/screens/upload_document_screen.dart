import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/document_provider.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final TextEditingController _titleController = TextEditingController(text: 'Health Insurance Policy');
  final TextEditingController _docNumController = TextEditingController(text: 'HIP-9812-4410');
  final TextEditingController _holderController = TextEditingController(text: 'Grishma Thakare');
  final TextEditingController _expiryController = TextEditingController(text: '31 Dec 2028');

  String _selectedCategory = 'Health';
  String _selectedFileName = 'health_policy_scan.pdf (1.8 MB)';
  bool _isFilePicked = true;

  void _onSave() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a document title.')),
      );
      return;
    }

    final provider = context.read<DocumentProvider>();
    final success = await provider.uploadCustomDocument(
      title: _titleController.text,
      category: _selectedCategory,
      docNumber: _docNumController.text,
      holderName: _holderController.text,
      expiryDate: _expiryController.text,
    );

    if (success && mounted) {
      Navigator.pop(context); // Close upload screen
      Navigator.pop(context); // Return to library
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custom document encrypted & stored in local vault!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upload Local Document'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Box
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isFilePicked = true;
                    _selectedFileName = 'scanned_credential_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.pdf (2.1 MB)';
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFilePicked ? Icons.task_alt_rounded : Icons.cloud_upload_rounded,
                          color: _isFilePicked ? AppColors.tertiary : AppColors.primary,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isFilePicked ? 'Selected File Ready' : 'Tap to select PDF or Image',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedFileName,
                        style: TextStyle(
                          fontSize: 12,
                          color: _isFilePicked ? AppColors.tertiary : AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Document Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Document Title',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'Identity', child: Text('Identity')),
                  DropdownMenuItem(value: 'Academic', child: Text('Academic')),
                  DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                  DropdownMenuItem(value: 'Financial', child: Text('Financial')),
                  DropdownMenuItem(value: 'Health', child: Text('Health')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _docNumController,
                decoration: const InputDecoration(
                  labelText: 'Document Reference Number (Optional)',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
              ),
              const SizedBox(height: 20),

              // Hardware Enclave Info Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_rounded, size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AES-256 Local HSM Seal will be applied prior to local storage.',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Encrypt & Save to Vault',
                isLoading: provider.isLoading,
                icon: Icons.shield_rounded,
                onPressed: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
