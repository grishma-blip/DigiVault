import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/partner_api_provider.dart';

class PartnerApiScreen extends StatefulWidget {
  const PartnerApiScreen({super.key});

  @override
  State<PartnerApiScreen> createState() => _PartnerApiScreenState();
}

class _PartnerApiScreenState extends State<PartnerApiScreen> {
  void _showGenerateApiKeyModal(BuildContext context) {
    final nameController = TextEditingController();
    final purposeController = TextEditingController();
    String selectedScope = 'Read Identity (Aadhaar, PAN)';
    double rateLimit = 100;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Register Partner Application API',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Grant third-party apps tokenized access to verify specific vault credentials.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Partner Organization / App Name',
                      hintText: 'e.g., SBI Mutual Fund KYC Portal',
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: purposeController,
                    decoration: const InputDecoration(
                      labelText: 'Access Purpose Description',
                      hintText: 'e.g., Verification of PAN & Bank KYC',
                    ),
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: selectedScope,
                    decoration: const InputDecoration(
                      labelText: 'Requested Scope Permission',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Read Identity (Aadhaar, PAN)',
                        child: Text('Read Identity (Aadhaar, PAN)'),
                      ),
                      DropdownMenuItem(
                        value: 'Read Academic Certificates (Degree, Marksheet)',
                        child: Text('Read Academic (Degree, CBSE)'),
                      ),
                      DropdownMenuItem(
                        value: 'Read Transport (Driving Licence, RC)',
                        child: Text('Read Transport (DL, Vehicle RC)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedScope = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Rate Limit: ${rateLimit.toInt()} req/day',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Slider(
                    value: rateLimit,
                    min: 10,
                    max: 500,
                    divisions: 49,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setModalState(() => rateLimit = val),
                  ),
                  const SizedBox(height: 20),

                  CustomButton(
                    text: 'Issue OAuth2 Client Key',
                    icon: Icons.key_rounded,
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter partner app name.')),
                        );
                        return;
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Issued API Key for ${nameController.text}: pk_live_${DateTime.now().millisecondsSinceEpoch}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PartnerApiProvider>();
    final partners = provider.partnerApis;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Partner API Access'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_link_rounded),
            onPressed: () => _showGenerateApiKeyModal(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.api_rounded, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sovereign API Gateway',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Manage external apps and institutional partners accessing your e-credentials.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // API Metrics Card
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      title: 'Active Integrations',
                      value: '${provider.activePartners.length}',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      title: 'Requests Handled',
                      value: '${partners.fold<int>(0, (sum, p) => sum + p.totalRequestsHandled)}',
                      icon: Icons.swap_calls_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Authorized Partner Apps',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: partners.length,
                itemBuilder: (context, index) {
                  final partner = partners[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: partner.isApproved ? AppColors.border : AppColors.error.withOpacity(0.3),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.business_rounded, color: AppColors.primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      partner.partnerName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(
                                      partner.purpose,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: partner.isApproved,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  if (val) {
                                    provider.approvePartnerAccess(partner.id);
                                  } else {
                                    provider.revokePartnerAccess(partner.id);
                                  }
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.security_rounded, size: 14, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    partner.grantedPermissions,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                '${partner.totalRequestsHandled} API Calls',
                                style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: 'Register New Partner App',
                icon: Icons.add_rounded,
                isOutlined: true,
                onPressed: () => _showGenerateApiKeyModal(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
