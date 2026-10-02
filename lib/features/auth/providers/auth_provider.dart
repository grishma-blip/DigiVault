import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../../../core/services/storage_service.dart';

enum AuthState { unauthenticated, authenticated, locked }

class AuthProvider extends ChangeNotifier {
  UserModel _user = StorageService.getUser();
  AuthState _authState = StorageService.isLoggedIn() ? AuthState.authenticated : AuthState.unauthenticated;
  bool _isLoading = false;
  String _currentOtp = '';

  UserModel get user => _user;
  AuthState get authState => _authState;
  bool get isLoading => _isLoading;
  String get currentOtp => _currentOtp;

  void setAuthState(AuthState state) {
    _authState = state;
    notifyListeners();
  }

  String generateNewOtp() {
    final random = Random();
    _currentOtp = (100000 + random.nextInt(900000)).toString();
    notifyListeners();
    return _currentOtp;
  }

  Future<bool> loginWithMobileOrAadhaar(String input, String method) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network request
    generateNewOtp();
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyOtp(String enteredOtp) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    if (_currentOtp.isNotEmpty && enteredOtp.trim() == _currentOtp) {
      _authState = AuthState.authenticated;
      await StorageService.setLoggedIn(true);
      notifyListeners();
      return true;
    }
    // Fallback for demo if no OTP generated yet
    if (_currentOtp.isEmpty && (enteredOtp == '123456' || enteredOtp.length == 6)) {
      _authState = AuthState.authenticated;
      await StorageService.setLoggedIn(true);
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<void> updateSecurityPin(String pin) async {
    _user = _user.copyWith(securityPin: pin, isPinSet: true);
    await StorageService.saveUser(_user);
    notifyListeners();
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String dob,
    required String gender,
    required String avatarUrl,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _user = _user.copyWith(
      fullName: fullName,
      email: email,
      mobileNumber: mobileNumber,
      dob: dob,
      gender: gender,
      avatarUrl: avatarUrl,
    );
    await StorageService.saveUser(_user);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleBiometrics(bool enabled) async {
    _user = _user.copyWith(isBiometricEnabled: enabled);
    await StorageService.saveUser(_user);
    notifyListeners();
  }

  Future<bool> verifyPin(String pin) async {
    if (pin == _user.securityPin) {
      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> upgradeToPremiumPlan() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1200)); // Payment simulation
    _user = _user.copyWith(
      isPremium: true,
      totalStorageMb: 6144.0, // 6 GB (1 GB + 5 GB Premium)
    );
    await StorageService.saveUser(_user);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _authState = AuthState.unauthenticated;
    await StorageService.setLoggedIn(false);
    notifyListeners();
  }

  Future<void> resetDemo() async {
    await StorageService.resetToDemo();
    _user = StorageService.getUser();
    _authState = AuthState.authenticated;
    notifyListeners();
  }
}
