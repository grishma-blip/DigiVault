import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/app_lock_screen.dart';
import '../../auth/screens/login_screen.dart';
import '../../storage/screens/storage_management_screen.dart';
import '../../partner_api/screens/partner_api_screen.dart';
import '../../legal/screens/privacy_policy_screen.dart';
import '../../legal/screens/terms_conditions_screen.dart';
import '../../../core/theme/theme_provider.dart';
import 'edit_profile_screen.dart';

class ProfileSecurityScreen extends StatefulWidget {
  const ProfileSecurityScreen({super.key});

  @override
  State<ProfileSecurityScreen> createState() => _ProfileSecurityScreenState();
}

class _ProfileSecurityScreenState extends State<ProfileSecurityScreen> {
  IconData _getAvatarIcon(String urlKey) {
    switch (urlKey) {
      case 'avatar_engineer':
        return Icons.engineering_rounded;
      case 'avatar_officer':
        return Icons.badge_rounded;
      case 'avatar_female':
        return Icons.face_3_rounded;
      case 'avatar_male':
        return Icons.face_6_rounded;
      default:
        return Icons.face_rounded;
    }
  }

  void _showChangePinDialog(BuildContext context) {
    final newPinController = TextEditingController();
    String pinError = '';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text('Update 4-Digit PIN'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter a new 4-digit PIN for encrypting local session keys.'),
                const SizedBox(height: 16),
                TextField(
                  controller: newPinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '••••',
                    errorText: pinError.isEmpty ? null : pinError,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (newPinController.text.length == 4) {
                    await context.read<AuthProvider>().updateSecurityPin(newPinController.text);
                    if (context.mounted) {
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Security PIN successfully updated!')),
                      );
                    }
                  } else {
                    setDialogState(() => pinError = 'PIN must be exactly 4 digits');
                  }
                },
                child: const Text('Save PIN'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Security & Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Card Header
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.surface,
                        AppColors.primary.withOpacity(0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primary.withOpacity(0.12),
                            child: Icon(_getAvatarIcon(user.avatarUrl), color: AppColors.primary, size: 40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        user.fullName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified_rounded, color: AppColors.tertiary, size: 20),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            user.gender.toLowerCase() == 'female'
                                                ? Icons.female_rounded
                                                : Icons.male_rounded,
                                            size: 14,
                                            color: AppColors.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            user.gender,
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      user.dob,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email.isEmpty ? 'Add email address' : user.email,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                            tooltip: 'Edit Profile Details',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.fingerprint_rounded, size: 16, color: AppColors.tertiary),
                              const SizedBox(width: 6),
                              Text(
                                'Aadhaar: XXXX-XXXX-${user.aadhaarLast4}',
                                style: const TextStyle(fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.tertiaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'VERIFIED CITIZEN',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.tertiary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Prominent Edit Profile Button Tile
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.manage_accounts_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Edit Citizen Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Change Photo Avatar, Full Name, Email & DOB',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),

              // Security & Authentication Settings
              Text(
                'Vault Authentication',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                  children: [
                    SwitchListTile(
                      value: user.isBiometricEnabled,
                      activeTrackColor: AppColors.primary,
                      title: const Text('Biometric Authentication', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Unlock vault with Touch ID / Face ID', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primary),
                      onChanged: (val) {
                        auth.toggleBiometrics(val);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.pin_rounded, color: AppColors.primary),
                      title: const Text('Security PIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Current PIN: •••• (${user.securityPin})', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      trailing: const Text('Change', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      onTap: () => _showChangePinDialog(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.lock_reset_rounded, color: AppColors.primary),
                      title: const Text('Lock Vault Immediately', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Require PIN on next screen transition', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      onTap: () {
                        auth.setAuthState(AuthState.locked);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AppLockScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
              const SizedBox(height: 24),

              // Appearance & Theming
              Text(
                'Appearance & Theme Mode',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return SwitchListTile(
                        value: themeProvider.isDarkMode,
                        activeTrackColor: AppColors.primary,
                        title: const Text('Dark Enclave Theme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('High-contrast dark mode UI for secure viewing', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        secondary: Icon(
                          themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: AppColors.primary,
                        ),
                        onChanged: (val) {
                          themeProvider.toggleTheme(val);
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Storage & Subscription Plan
              Text(
                'Storage Plan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    leading: const Icon(Icons.cloud_queue_rounded, color: AppColors.secondary),
                    title: Text(
                      user.isPremium ? 'Premium Vault Plan (6 GB)' : 'Free Vault Plan (1 GB)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      '${user.usedStorageMb.toStringAsFixed(1)} MB / ${(user.totalStorageMb / 1024).toStringAsFixed(1)} GB occupied',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StorageManagementScreen()),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Developer / Partner Integrations
              Text(
                'API & Institutional Integration',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  child: ListTile(
                    leading: const Icon(Icons.api_rounded, color: AppColors.info),
                    title: const Text('Partner API Access Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('View & control active institutional API tokens', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PartnerApiScreen()),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Legal & Framework Policy Section
              Text(
                'Legal & Governance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('DPDP Act 2023 & IT Act 2000 Compliance', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.gavel_rounded, color: AppColors.primary),
                        title: const Text('Terms & Conditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text('Rule 9A e-Document Legal Framework', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TermsConditionsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Reset Demo & Logout Action Buttons
              CustomButton(
                text: 'Reset Demo Data to Initial State',
                icon: Icons.refresh_rounded,
                isOutlined: true,
                onPressed: () async {
                  await auth.resetDemo();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Demo storage restored to initial government vault state.')),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              CustomButton(
                text: 'Logout of Vault Session',
                icon: Icons.logout_rounded,
                isOutlined: true,
                onPressed: () async {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
