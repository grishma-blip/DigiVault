import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _errorMessage = '';

  void _onUnlock() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.verifyPin(_pinController.text);
    if (success && mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (mounted) {
      setState(() => _errorMessage = 'Incorrect Security PIN (Set PIN: ${auth.user.securityPin})');
    }
  }

  void _onBiometricAuth() async {
    // Simulate biometric authentication success
    final auth = context.read<AuthProvider>();
    auth.setAuthState(AuthState.authenticated);
    if (mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_rounded, size: 40, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Vault Locked • Enter 4-Digit Security PIN',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

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
                  errorText: _errorMessage.isEmpty ? null : _errorMessage,
                ),
                onChanged: (_) => setState(() => _errorMessage = ''),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Unlock Vault',
                onPressed: _onUnlock,
                icon: Icons.key_rounded,
              ),

              if (auth.user.isBiometricEnabled) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _onBiometricAuth,
                  icon: const Icon(Icons.fingerprint_rounded, color: AppColors.tertiary),
                  label: const Text('Unlock with Biometrics (Touch ID / Face ID)'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
