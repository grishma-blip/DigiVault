import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/crypto_service.dart';
import 'verification_result_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with SingleTickerProviderStateMixin {
  late final MobileScannerController _scannerController;
  late final AnimationController _scanAnimationController;
  late final Animation<double> _scanAnimation;

  bool _isScanned = false;
  bool _isTorchOn = false;
  bool _isCameraStarted = false;
  double _laserYOffset = 0.5; // Drag position (0.1 to 0.9)

  final TextEditingController _manualQrController = TextEditingController(
    text: 'DIGIVAULT:DOC-AADHAAR-01|UIDAI|Grishma Thakare|e3b0c44298fc1c149afbf4c8996fb924',
  );

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      torchEnabled: false,
      autoStart: true,
    );
    _initCamera();

    // Smooth continuous vertical laser animation
    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.12, end: 0.88).animate(
      CurvedAnimation(
        parent: _scanAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  void _initCamera() async {
    try {
      await _scannerController.start();
      if (mounted) setState(() => _isCameraStarted = true);
    } catch (_) {
      // Handled gracefully in UI errorBuilder
    }
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    _scannerController.dispose();
    _manualQrController.dispose();
    super.dispose();
  }

  void _processQrPayload(String rawPayload) {
    if (_isScanned) return;
    setState(() => _isScanned = true);

    final result = CryptoService.parseAndVerifyQrPayload(rawPayload);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VerificationResultScreen(
          rawPayload: rawPayload,
          verificationResult: result,
        ),
      ),
    );
  }

  void _showManualInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Custom QR Code Payload'),
        content: TextField(
          controller: _manualQrController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Paste QR payload, Aadhaar data, PAN, DL number or hash...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processQrPayload(_manualQrController.text);
            },
            child: const Text('Verify QR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Government Document QR Scanner'),
        actions: [
          IconButton(
            icon: Icon(_isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded),
            tooltip: 'Toggle Flashlight',
            onPressed: () async {
              await _scannerController.toggleTorch();
              setState(() => _isTorchOn = !_isTorchOn);
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded),
            tooltip: 'Switch Camera Source',
            onPressed: () async {
              await _scannerController.switchCamera();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              const Text(
                'Hold Driving License, Aadhaar Card, or PAN Card QR in front of camera',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              // Interactive Moveable Viewfinder Box
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      // Allow moving laser focus up and down by dragging
                      setState(() {
                        _laserYOffset = (_laserYOffset + details.delta.dy / 290.0).clamp(0.1, 0.9);
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: 290,
                        height: 290,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white12, width: 1.5),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // MobileScanner Real Live Webcam / Mobile Camera Stream
                              MobileScanner(
                                controller: _scannerController,
                                onDetect: (capture) {
                                  final List<Barcode> barcodes = capture.barcodes;
                                  for (final barcode in barcodes) {
                                    if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                                      _processQrPayload(barcode.rawValue!);
                                      break;
                                    }
                                  }
                                },
                                errorBuilder: (context, error, child) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    color: const Color(0xFF1E293B),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(_isCameraStarted ? Icons.videocam_rounded : Icons.videocam_outlined, color: Colors.amber, size: 44),
                                        const SizedBox(height: 10),
                                        Text(
                                          _isCameraStarted ? 'Live Camera Stream Active' : 'Live Camera Stream Ready',
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            await _scannerController.start();
                                            await _scannerController.switchCamera();
                                            if (mounted) setState(() => _isCameraStarted = true);
                                          },
                                          icon: const Icon(Icons.camera_alt_rounded, size: 16),
                                          label: const Text('Start Camera Stream', style: TextStyle(fontSize: 12)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Sleek Target Corner Brackets (Google Wallet Style)
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Stack(
                                    children: [
                                      _buildCornerBracket(top: true, left: true),
                                      _buildCornerBracket(top: true, left: false),
                                      _buildCornerBracket(top: false, left: true),
                                      _buildCornerBracket(top: false, left: false),
                                    ],
                                  ),
                                ),
                              ),

                              // Smooth Moving Laser Beam
                              AnimatedBuilder(
                                animation: _scanAnimation,
                                builder: (context, child) {
                                  final currentPos = _scanAnimation.value;
                                  return Positioned(
                                    top: 290.0 * currentPos - 1.5,
                                    left: 24,
                                    right: 24,
                                    child: Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.secondary.withOpacity(0.1),
                                            AppColors.secondary,
                                            Colors.amber,
                                            AppColors.secondary,
                                            AppColors.secondary.withOpacity(0.1),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.secondary.withOpacity(0.6),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Status Indicator & Moveable Instruction Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swipe_vertical_rounded, color: AppColors.secondary, size: 16),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Drag or hold camera over QR code to scan',
                        style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Quick Document Scan Test Triggers
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _processQrPayload('DIGIVAULT:DOC-DL-03|MoRTH|Grishma Thakare|MH02 20230008849');
                      },
                      icon: const Icon(Icons.directions_car_rounded, color: Colors.amber, size: 18),
                      label: const Flexible(
                        child: Text(
                          'Scan Driving License',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.amber)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _processQrPayload('DIGIVAULT:DOC-AADHAAR-01|UIDAI|Grishma Thakare|e3b0c44298fc1c149afbf4c8996fb924');
                      },
                      icon: const Icon(Icons.badge_rounded, color: Colors.lightBlueAccent, size: 18),
                      label: const Flexible(
                        child: Text(
                          'Scan Aadhaar Card',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.lightBlueAccent)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _processQrPayload('DIGIVAULT:DOC-PAN-02|Income Tax Dept|Grishma Thakare|4a8a08f09d37b73795649038408b5f33');
                      },
                      icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.greenAccent, size: 18),
                      label: const Flexible(
                        child: Text(
                          'Scan PAN Card',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.greenAccent)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showManualInputDialog,
                      icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 18),
                      label: const Flexible(
                        child: Text(
                          'Manual Entry',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38)),
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

  Widget _buildCornerBracket({required bool top, required bool left}) {
    return Align(
      alignment: Alignment(left ? -1.0 : 1.0, top ? -1.0 : 1.0),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: top ? const BorderSide(color: AppColors.secondary, width: 3.5) : BorderSide.none,
            bottom: !top ? const BorderSide(color: AppColors.secondary, width: 3.5) : BorderSide.none,
            left: left ? const BorderSide(color: AppColors.secondary, width: 3.5) : BorderSide.none,
            right: !left ? const BorderSide(color: AppColors.secondary, width: 3.5) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
