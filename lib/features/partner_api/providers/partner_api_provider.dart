import 'package:flutter/material.dart';
import '../models/partner_api_model.dart';
import '../../../core/services/storage_service.dart';

class PartnerApiProvider extends ChangeNotifier {
  final List<PartnerApiModel> _partnerApis = StorageService.getPartnerApis();

  List<PartnerApiModel> get partnerApis => _partnerApis;
  List<PartnerApiModel> get activePartners => _partnerApis.where((p) => p.isApproved).toList();

  Future<void> revokePartnerAccess(String partnerId) async {
    final index = _partnerApis.indexWhere((p) => p.id == partnerId);
    if (index != -1) {
      _partnerApis[index] = _partnerApis[index].copyWith(isApproved: false);
      await StorageService.savePartnerApis(_partnerApis);
      notifyListeners();
    }
  }

  Future<void> approvePartnerAccess(String partnerId) async {
    final index = _partnerApis.indexWhere((p) => p.id == partnerId);
    if (index != -1) {
      _partnerApis[index] = _partnerApis[index].copyWith(isApproved: true);
      await StorageService.savePartnerApis(_partnerApis);
      notifyListeners();
    }
  }
}
