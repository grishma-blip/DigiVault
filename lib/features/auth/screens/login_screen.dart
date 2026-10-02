import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import 'otp_screen.dart';
import '../../legal/screens/privacy_policy_screen.dart';
import '../../legal/screens/terms_conditions_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isSignUp;

  const LoginScreen({
    super.key,
    this.isSignUp = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _authMethod = 'Mobile'; // 'Mobile' or 'Aadhaar'
  bool _consentGiven = true;

  @override
  void initState() {
    super.initState();
    _inputController.clear();
  }

  void _onSendOtp() async {
    if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the DigiLocker consent terms to proceed.')),
      );
      return;
    }

    if (_inputController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid ${_authMethod == 'Mobile' ? 'Mobile Number' : 'Aadhaar Number'}.')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.loginWithMobileOrAadhaar(_inputController.text, _authMethod);
    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            identifier: _inputController.text,
            method: _authMethod,
          ),
        ),
      );
    }
  }

  void _switchAuthMethod(String type) {
    setState(() {
      _authMethod = type;
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isSignUp ? 'Create DigiLocker Account' : 'Sign In to DigiLocker'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Government Header Badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'DIGITAL INDIA • MEITY',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: AppColors.primary),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Secure Citizen Identity & Credential Enclave',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Text(
                widget.isSignUp ? 'New Citizen Registration' : 'Enter Credentials',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your registered Mobile Number (+91) or 12-Digit Aadhaar Number to receive a secure OTP.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Tab Selector
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchAuthMethod('Mobile'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _authMethod == 'Mobile' ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Mobile Number',
                              style: TextStyle(
                                color: _authMethod == 'Mobile' ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchAuthMethod('Aadhaar'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _authMethod == 'Aadhaar' ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Aadhaar Number',
                              style: TextStyle(
                                color: _authMethod == 'Aadhaar' ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Input Field
              TextField(
                controller: _inputController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: _authMethod == 'Mobile' ? 'Mobile Number (+91)' : 'Aadhaar Number (12-Digit)',
                  prefixIcon: Icon(
                    _authMethod == 'Mobile' ? Icons.phone_android_rounded : Icons.badge_rounded,
                    color: AppColors.primary,
                  ),
                  hintText: _authMethod == 'Mobile' ? 'Enter 10-digit mobile number' : 'Enter 12-digit Aadhaar number',
                ),
              ),
              const SizedBox(height: 20),

              // Consent Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _consentGiven,
                      onChanged: (val) => setState(() => _consentGiven = val ?? true),
                      activeColor: AppColors.primary,
                    ),
                    Expanded(
                      child: Text(
                        'I give consent to DigiLocker to authenticate my identity and fetch my e-credentials per IT Act 2000 & Aadhaar Regulations.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Send Verification OTP',
                isLoading: auth.isLoading,
                onPressed: _onSendOtp,
                icon: Icons.send_rounded,
              ),
              const SizedBox(height: 24),

              // Legal Policy Links Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                      );
                    },
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
                  ),
                  const Text('  •  ', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TermsConditionsScreen()),
                      );
                    },
                    child: const Text(
                      'Terms & Conditions',
                      style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
