import 'package:flutter/material.dart';
import '../models/share_model.dart';
import '../../documents/models/document_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/crypto_service.dart';

class ShareProvider extends ChangeNotifier {
  final List<ShareModel> _shares = StorageService.getShares();
  bool _isLoading = false;

  List<ShareModel> get shares => _shares;
  List<ShareModel> get activeShares => _shares.where((s) => s.isValid).toList();
  List<ShareModel> get revokedOrExpiredShares => _shares.where((s) => !s.isValid).toList();
  bool get isLoading => _isLoading;

  Future<ShareModel> createShare({
    required DocumentModel document,
    required String recipientLabel,
    required int durationHours,
    required bool allowDownload,
    required bool enforceWatermark,
    required bool isPasswordProtected,
    required String accessPin,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final shareId = 'SHARE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final token = CryptoService.generateShareToken();
    final now = DateTime.now();
    final expiresAt = durationHours > 0 ? now.add(Duration(hours: durationHours)) : now.add(const Duration(days: 3650)); // 10 years if permanent

    final share = ShareModel(
      id: shareId,
      documentId: document.id,
      documentTitle: document.title,
      issuerName: document.issuerName,
      shareToken: token,
      recipientLabel: recipientLabel.isNotEmpty ? recipientLabel : 'Public Share Link',
      createdAt: now,
      expiresAt: expiresAt,
      accessCount: 0,
      maxAccessLimit: 10,
      allowDownload: allowDownload,
      enforceWatermark: enforceWatermark,
      isPasswordProtected: isPasswordProtected,
      accessPin: accessPin,
      status: 'ACTIVE',
    );

    _shares.insert(0, share);
    await StorageService.saveShares(_shares);

    _isLoading = false;
    notifyListeners();
    return share;
  }

  Future<void> revokeShare(String shareId) async {
    final index = _shares.indexWhere((s) => s.id == shareId);
    if (index != -1) {
      _shares[index] = _shares[index].copyWith(status: 'REVOKED');
      await StorageService.saveShares(_shares);
      notifyListeners();
    }
  }

  ShareModel? getShareByToken(String token) {
    try {
      return _shares.firstWhere((s) => s.shareToken == token);
    } catch (_) {
      return null;
    }
  }

  Future<bool> incrementAccessCount(String shareId) async {
    final index = _shares.indexWhere((s) => s.id == shareId);
    if (index != -1 && _shares[index].isValid) {
      final current = _shares[index];
      _shares[index] = current.copyWith(accessCount: current.accessCount + 1);
      await StorageService.saveShares(_shares);
      notifyListeners();
      return true;
    }
    return false;
  }
}
