import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import 'aadhaar_verification_screen.dart';

class OtpScreen extends StatefulWidget {
  final String identifier;
  final String method;

  const OtpScreen({
    super.key,
    required this.identifier,
    required this.method,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _showSmsBanner = false;
  String _activeOtp = '';
  int _timerSeconds = 30;
  Timer? _resendTimer;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerNewOtp();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _resendTimer?.cancel();
    setState(() => _timerSeconds = 30);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        if (mounted) setState(() => _timerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  void _triggerNewOtp() {
    final auth = context.read<AuthProvider>();
    final otp = auth.generateNewOtp();
    setState(() {
      _activeOtp = otp;
      _showSmsBanner = true;
      _errorMessage = '';
    });
    _startTimer();

    // Auto-dismiss SMS notification banner after 8 seconds
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _showSmsBanner = false);
      }
    });
  }

  void _autoFillOtp() {
    setState(() {
      _otpController.text = _activeOtp;
      _showSmsBanner = false;
      _errorMessage = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP $_activeOtp copied & filled!'),
        backgroundColor: AppColors.tertiary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onVerify() async {
    final auth = context.read<AuthProvider>();
    final entered = _otpController.text.trim();

    if (entered.length < 6) {
      setState(() => _errorMessage = 'Please enter complete 6-digit OTP');
      return;
    }

    final success = await auth.verifyOtp(entered);
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AadhaarVerificationScreen(mobileNumber: widget.identifier),
        ),
      );
    } else if (mounted) {
      setState(() => _errorMessage = 'Invalid OTP! Please enter the 6-digit code received via SMS.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verify Mobile OTP'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Indicator Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Step 1 of 3: Mobile Auth',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Enter 6-Digit OTP',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'An official e-KYC security OTP has been dispatched to ${widget.identifier} via SMS.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // OTP Code Input Box
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 14,
                      fontFamily: 'monospace',
                      color: AppColors.textPrimary,
                    ),
                    onChanged: (val) {
                      if (_errorMessage.isNotEmpty) setState(() => _errorMessage = '');
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '••••••',
                      hintStyle: const TextStyle(color: AppColors.border, letterSpacing: 10),
                      fillColor: AppColors.surface,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error Message Banner if invalid OTP entered
                  if (_errorMessage.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Resend Timer & Button
                  Center(
                    child: _timerSeconds > 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 6),
                              Text(
                                'Resend OTP in ${_timerSeconds}s',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        : TextButton.icon(
                            onPressed: _triggerNewOtp,
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Resend OTP SMS', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                  ),
                  const SizedBox(height: 28),

                  CustomButton(
                    text: 'Verify & Authorize Vault',
                    isLoading: auth.isLoading,
                    onPressed: _onVerify,
                    icon: Icons.verified_user_rounded,
                  ),
                ],
              ),
            ),

            // Top Simulated Android SMS Push Notification Popup
            if (_showSmsBanner)
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF1E293B),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.tertiary.withOpacity(0.5), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.tertiary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.mark_chat_unread_rounded, color: Colors.white, size: 14),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'MESSAGES • 1901 (GOVT OF INDIA / UIDAI)',
                                style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.6),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _showSmsBanner = false),
                              child: const Icon(Icons.close_rounded, color: Colors.white54, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your DigiLocker security OTP is $_activeOtp. Valid for 10 minutes. Do NOT share it with anyone. - UIDAI/MeitY',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _autoFillOtp,
                              icon: const Icon(Icons.copy_rounded, size: 14),
                              label: Text('AUTO-FILL $_activeOtp', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.tertiary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
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
