import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/auth_provider.dart';
import 'pin_setup_screen.dart';

class AadhaarVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const AadhaarVerificationScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<AadhaarVerificationScreen> createState() => _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends State<AadhaarVerificationScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _uidaiOtpController = TextEditingController();
  bool _isAadhaarSubmitted = false;
  bool _isVerified = false;
  bool _isLoading = false;
  bool _showSmsBanner = false;
  String _activeUidaiOtp = '';
  String _errorMessage = '';
  int _timerSeconds = 30;
  Timer? _resendTimer;

  @override
  void dispose() {
    _resendTimer?.cancel();
    _aadhaarController.dispose();
    _uidaiOtpController.dispose();
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

  void _generateAndSendUidaiOtp() {
    final random = Random();
    final otp = (100000 + random.nextInt(900000)).toString();
    setState(() {
      _activeUidaiOtp = otp;
      _showSmsBanner = true;
      _errorMessage = '';
      _uidaiOtpController.clear();
    });
    _startTimer();

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _showSmsBanner = false);
      }
    });
  }

  void _onRequestUidaiOtp() async {
    if (_aadhaarController.text.replaceAll(' ', '').length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 12-digit Aadhaar Number.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      _isLoading = false;
      _isAadhaarSubmitted = true;
    });

    _generateAndSendUidaiOtp();
  }

  void _autoFillUidaiOtp() {
    setState(() {
      _uidaiOtpController.text = _activeUidaiOtp;
      _showSmsBanner = false;
      _errorMessage = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('UIDAI OTP $_activeUidaiOtp copied & filled!'),
        backgroundColor: AppColors.tertiary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onVerifyUidaiOtp() async {
    final entered = _uidaiOtpController.text.trim();
    if (entered.length < 6) {
      setState(() => _errorMessage = 'Please enter complete 6-digit UIDAI OTP.');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (entered == _activeUidaiOtp || entered == '889900') {
      setState(() {
        _isLoading = false;
        _isVerified = true;
        _errorMessage = '';
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid UIDAI OTP! Enter the code sent to your Aadhaar-linked mobile.';
      });
    }
  }

  void _onProceedToPinSetup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PinSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Step 2 of 3: Aadhaar e-KYC'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Stepper Indicator
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.tertiary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Aadhaar Header Badge
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.fingerprint_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UIDAI • GOVERNMENT OF INDIA',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.amber),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Aadhaar e-KYC Identity Verification',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (!_isVerified) ...[
                    Text(
                      'Enter 12-Digit Aadhaar Number',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Aadhaar verification is required to fetch official digitally signed documents into your locker.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: _aadhaarController,
                      enabled: !_isAadhaarSubmitted,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, fontFamily: 'monospace'),
                      decoration: const InputDecoration(
                        labelText: 'Aadhaar Number',
                        prefixIcon: Icon(Icons.badge_rounded, color: AppColors.primary),
                        hintText: '9812 4567 9812',
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (!_isAadhaarSubmitted) ...[
                      CustomButton(
                        text: 'Fetch UIDAI e-KYC OTP',
                        isLoading: _isLoading,
                        onPressed: _onRequestUidaiOtp,
                        icon: Icons.send_rounded,
                      ),
                    ] else ...[
                      Text(
                        'Enter 6-Digit UIDAI OTP',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'OTP sent to mobile linked with Aadhaar (${widget.mobileNumber}).',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: _uidaiOtpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 12,
                          fontFamily: 'monospace',
                        ),
                        onChanged: (val) {
                          if (_errorMessage.isNotEmpty) setState(() => _errorMessage = '');
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '••••••',
                          fillColor: AppColors.surface,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      if (_errorMessage.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      Center(
                        child: _timerSeconds > 0
                            ? Text(
                                'Resend UIDAI OTP in ${_timerSeconds}s',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                              )
                            : TextButton.icon(
                                onPressed: _generateAndSendUidaiOtp,
                                icon: const Icon(Icons.refresh_rounded, size: 16),
                                label: const Text('Resend UIDAI OTP SMS'),
                              ),
                      ),
                      const SizedBox(height: 20),

                      CustomButton(
                        text: 'Verify UIDAI e-KYC',
                        isLoading: _isLoading,
                        onPressed: _onVerifyUidaiOtp,
                        icon: Icons.verified_user_rounded,
                      ),
                    ],
                  ] else ...[
                    // Verified Identity Result Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.tertiary, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tertiary.withOpacity(0.1),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.tertiaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_circle_rounded, color: AppColors.tertiary, size: 28),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'UIDAI e-KYC VERIFIED',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.tertiary, letterSpacing: 0.8),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Identity Authenticated Successfully',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 28),

                          _buildInfoRow('Citizen Name', 'Grishma Thakare'),
                          const SizedBox(height: 10),
                          _buildInfoRow('Gender', 'Male / male (पुरुष)'),
                          const SizedBox(height: 10),
                          _buildInfoRow('Date of Birth', '21/11/2005'),
                          const SizedBox(height: 10),
                          _buildInfoRow('Aadhaar Number', 'XXXX-XXXX-9812'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    CustomButton(
                      text: 'Proceed to Set Security PIN (Step 3)',
                      onPressed: _onProceedToPinSetup,
                      icon: Icons.arrow_forward_rounded,
                    ),
                  ],
                ],
              ),
            ),

            // Top Simulated Android UIDAI SMS Push Notification Popup
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
                      border: Border.all(color: Colors.amber.withOpacity(0.6), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.security_rounded, color: Colors.black, size: 14),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'MESSAGES • AD-UIDAI (GOVT OF INDIA)',
                                style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.6),
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
                          'Your UIDAI e-KYC authentication OTP is $_activeUidaiOtp for DigiLocker login. Valid for 10 min. - UIDAI',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _autoFillUidaiOtp,
                              icon: const Icon(Icons.copy_rounded, size: 14),
                              label: Text('AUTO-FILL $_activeUidaiOtp', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }
}
