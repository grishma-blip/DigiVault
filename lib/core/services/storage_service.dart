import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/models/user_model.dart';
import '../../features/documents/models/document_model.dart';
import '../../features/secure_sharing/models/share_model.dart';
import '../../features/notifications/models/notification_model.dart';
import '../../features/partner_api/models/partner_api_model.dart';
import 'demo_data_service.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Seed initial data if first time or migration needed
    if (!_prefs.containsKey('is_initialized_v3')) {
      await saveUser(DemoDataService.initialUser);
      await saveDocuments(DemoDataService.initialDocuments);
      await saveShares(DemoDataService.initialShares);
      await saveNotifications(DemoDataService.initialNotifications);
      await savePartnerApis(DemoDataService.initialPartnerApis);
      await _prefs.setBool('is_initialized_v3', true);
    }
  }

  // User
  static UserModel getUser() {
    final raw = _prefs.getString('user_data');
    if (raw == null) return DemoDataService.initialUser;
    final user = UserModel.fromJson(jsonDecode(raw));
    if (user.fullName.contains('Ananya')) return DemoDataService.initialUser;
    return user;
  }

  static Future<void> saveUser(UserModel user) async {
    await _prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  // Documents
  static List<DocumentModel> getDocuments() {
    final rawList = _prefs.getStringList('documents_list');
    if (rawList == null) return DemoDataService.initialDocuments;
    final docs = rawList.map((e) => DocumentModel.fromJson(jsonDecode(e))).toList();
    if (docs.any((d) => d.holderName.contains('Ananya'))) return DemoDataService.initialDocuments;
    return docs;
  }

  static Future<void> saveDocuments(List<DocumentModel> docs) async {
    final rawList = docs.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList('documents_list', rawList);
  }

  // Shares
  static List<ShareModel> getShares() {
    final rawList = _prefs.getStringList('shares_list');
    if (rawList == null) return DemoDataService.initialShares;
    return rawList.map((e) => ShareModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveShares(List<ShareModel> shares) async {
    final rawList = shares.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList('shares_list', rawList);
  }

  // Notifications
  static List<NotificationModel> getNotifications() {
    final rawList = _prefs.getStringList('notifications_list');
    if (rawList == null) return DemoDataService.initialNotifications;
    return rawList.map((e) => NotificationModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveNotifications(List<NotificationModel> notifs) async {
    final rawList = notifs.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList('notifications_list', rawList);
  }

  // Partner APIs
  static List<PartnerApiModel> getPartnerApis() {
    final rawList = _prefs.getStringList('partner_apis_list');
    if (rawList == null) return DemoDataService.initialPartnerApis;
    return rawList.map((e) => PartnerApiModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> savePartnerApis(List<PartnerApiModel> apis) async {
    final rawList = apis.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList('partner_apis_list', rawList);
  }

  // General Preference Helpers
  static String? getString(String key) => _prefs.getString(key);
  static Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  static bool isLoggedIn() => _prefs.getBool('is_logged_in') ?? true;
  static Future<bool> setLoggedIn(bool value) => _prefs.setBool('is_logged_in', value);

  // Reset to Demo
  static Future<void> resetToDemo() async {
    await _prefs.clear();
    await init();
  }
}
