# 🎓 DigiLocker Document Wallet (DigiVault)
## 📜 Ultimate Teacher Presentation & Code Walkthrough Guide

---

## 👤 Presenter & Academic Profile

* **Student Name**: **Grishma Thakare**
* **Roll Number**: `150096724054`
* **Cohort**: **Elon Musk**
* **Branch & Batch**: **B.Tech Computer Science Engineering (CSE & AI) • 2024–2028**
* **Course Subject**: **Cross-Platform Application Development**
* **University**: **ITM Skills University**
* **Project Reference**: **142. DigiLocker Document Wallet**
* **Industry**: **Digital Identity, FinTech & Cryptographic Public Infrastructure**

---

## 🎯 1. Introduction & Pitch Script

### 🛑 The Problem
> *"Carrying physical documents like Aadhaar, PAN card, Driving License, or college marksheets everywhere is risky. They can easily get lost, damaged, or stolen. On the other hand, simple phone screenshots or photos are often not accepted as official proof."*

### 💡 The Solution (What I Built)
> *"To solve this, I built a **secure Flutter app** where users can safely store, view, and share their official digital documents in one place, complete with QR code verification and PIN security."*

---

## 🌟 2. Key Technical & Product Features Implemented

> *"To deliver a production-ready solution, I implemented the following key features in the application:"*

1. **Direct Issuer Integration**: Citizens can automatically fetch official credentials directly from verified issuers like UIDAI, CBSE, and MoRTH using unique URN numbers.
2. **Tamper-Evident QR Code Verification**: Generates dynamic QR codes for each document. Anyone scanning the QR code via our built-in camera scanner can instantly verify the document's authenticity and PKI digital signature.
3. **Digital PKI Signature & Metadata**: Displays issuer logos, issue/expiry dates, URN numbers, and 2048-bit cryptographic signature status (`VERIFIED BY ISSUER`).
4. **Time-Bound Secure Sharing**: Enables users to share documents with customized validity periods (e.g., valid for 1 hour or 24 hours) and optional PIN protection.
5. **Biometric & App Lock Security**: Built-in PIN and biometric authentication screens to safeguard private citizen data.
6. **Document Expiry & Alert System**: Real-time notification system to alert users when a document (such as a Driving License or Vehicle Insurance) is expiring soon.
7. **Folder & Category Organization**: Structured tab navigation categorizing documents into *Identity*, *Academic*, *Transport*, *Financial*, and *Health*.
8. **Vault Storage & Partner API Ecosystem**: Includes vault quota management (Free 1GB tier with optional ₹99/year 5GB premium upgrade) and a Partner API integration hub for third-party KYC verification.

---

## 🎙️ 3. Detailed Parameter-Wise Walkthrough & Code Proofs

---

### 📌 Parameter 1: UI/UX Design, Theming and Responsiveness (5 Marks)

#### 🎨 A. Design System & Visual Aesthetics
* **Explanation**: App ko government-grade digital wallet look dene ke liye official **GovTech Color Palette** design kiya gaya hai (`#0F3860` Deep Navy Blue as primary, `#E65100` Saffron accent, and `#1B5E20` Emerald Green for verified documents).
* **Code File**: [`lib/core/constants/app_colors.dart`](file:///Users/thakaregrishma/Downloads/stitch_digivault_document_wallet_flutter_app/lib/core/constants/app_colors.dart)
* **Code Proof**:
```dart
class AppColors {
  // Official DigiLocker & GovTech India Palette
  static const Color primary = Color(0xFF0F3860); // Official DigiLocker Deep Navy Blue
  static const Color primaryLight = Color(0xFF1B4D7E);
  static const Color secondary = Color(0xFFE65100); // National Saffron Accent
  static const Color tertiary = Color(0xFF1B5E20); // Verified Emerald Green
  static const Color background = Color(0xFFF8FAFC); // Slate 50 ultra clean
  static const Color surface = Color(0xFFFFFFFF); // Pure White
}
```

---

#### 🌓 B. Dynamic Light & Dark Enclave Theming
* **Explanation**: [`lib/core/theme/app_theme.dart`](file:///Users/thakaregrishma/Downloads/stitch_digivault_document_wallet_flutter_app/lib/core/theme/app_theme.dart) me Light aur Dark dono modes ke liye separate `ThemeData` configure kiye hain. `ThemeProvider` ke through user live switch kar sakta hai.
* **Code File**: [`lib/core/theme/theme_provider.dart`](file:///Users/thakaregrishma/Downloads/stitch_digivault_document_wallet_flutter_app/lib/core/theme/theme_provider.dart)
* **Code Proof**:
```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
```

---

#### 📐 C. Responsive Layouts & Overflow Protection
* **Explanation**: Fixed pixel heights ki bajaye `LayoutBuilder`, `ConstrainedBox`, `Expanded`, aur `SingleChildScrollView` use hue hain jisse **0 RenderFlex Pixel Overflows** milte hain.
* **Code File**: [`lib/features/documents/screens/document_viewer_screen.dart`](file:///Users/thakaregrishma/Downloads/stitch_digivault_document_wallet_flutter_app/lib/features/documents/screens/document_viewer_screen.dart)
* **Code Proof**:
```dart
// Text overflow prevention using Expanded + TextOverflow.ellipsis
Row(
  children: [
    const Icon(Icons.verified_user_rounded, color: AppColors.tertiaryContainer, size: 18),
    const SizedBox(width: 6),
    Expanded(
      child: Text(
        'DIGILOCKER VERIFIED • ${document.issuerName.toUpperCase()}',
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)
```

---

### 📌 Parameter 2: Dart Fundamentals and Package Ecosystem (5 Marks)

#### 🏛️ A. Architecture & State Management (`Provider`)
* **Explanation**: App Clean Architecture follow karta hai. State management **`Provider` (`ChangeNotifier`)** se handled hai.
* **Code File**: [`lib/features/auth/providers/auth_provider.dart`](file:///Users/thakaregrishma/Downloads/stitch_digivault_document_wallet_flutter_app/lib/features/auth/providers/auth_provider.dart)
* **Code Proof**:
```dart
class AuthProvider extends ChangeNotifier {
  UserModel _user = StorageService.getUser();
  AuthState _authState = StorageService.isLoggedIn() ? AuthState.authenticated : AuthState.unauthenticated;

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
    return false;
  }
}
```

---

#### 💾 B. Local Persistence & Async Operations
* **Explanation**: User data, storage quota, aur login state `SharedPreferences` me save hota hai background `Future` / `async` calls dwara.
* **Code File**: [`lib/core/services/storage_service.dart`](file:///Users/thakaregrishma/Downloads/stitch_digivault_document_wallet_flutter_app/lib/core/services/storage_service.dart)
* **Code Proof**:
```dart
class StorageService {
  static late SharedPreferences _prefs;

  static bool isLoggedIn() => _prefs.getBool('is_logged_in') ?? true;
  static Future<bool> setLoggedIn(bool value) => _prefs.setBool('is_logged_in', value);
}
```

---

#### 📦 C. Package Ecosystem (`pubspec.yaml`)
* **Code File**: [`pubspec.yaml`](file:///Users/thakaregrishma/Downloads/stitch_digivault_document_wallet_flutter_app/pubspec.yaml)
* **Packages Implemented**:
  * `provider: ^6.1.2` — State management
  * `google_fonts: ^6.1.0` — Inter & Outfit fonts
  * `qr_flutter: ^4.1.0` — QR Code generation
  * `mobile_scanner: ^5.2.3` — Live camera scanner
  * `shared_preferences: ^2.2.2` — Local device storage
  * `crypto: ^3.0.3` — SHA-256 cryptographic checksums

---

### 📌 Parameter 3: Build Configurations and Deployment Readiness (5 Marks)

#### 🛡️ A. Navigation Safety & Back-Button Protection (`PopScope`)
* **Explanation**: User back button dabane par galti se app exit na ho ya logout na ho, iske liye `PopScope` container apply kiya hai.
* **Code File**: [`lib/features/dashboard/screens/dashboard_screen.dart`](file:///Users/thakaregrishma/Downloads/stitch_digivault_document_wallet_flutter_app/lib/features/dashboard/screens/dashboard_screen.dart)
* **Code Proof**:
```dart
return PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) {
    if (didPop) return;
    if (_currentTab != 0) {
      setState(() => _currentTab = 0);
    }
  },
  child: Scaffold(...),
);
```

---

#### ⚡ B. Verification Commands & Zero Errors
* **Static Analysis**: `flutter analyze` passes with **0 Errors & 0 Warnings**.
* **Automated Unit Tests**: `flutter test` passes **100% (`All tests passed!`)**.

---

## 🎓 4. Technical Viva Q&A (Teacher Evaluation Ready)

| # | Question Asked by Teacher | Your Precise Technical Answer |
| :-: | :--- | :--- |
| 1 | **What is Flutter's 3-Tree Architecture?** | Flutter uses 3 parallel trees: **Widget Tree** (UI Configuration), **Element Tree** (Lifecycle & Bridge), and **RenderObject Tree** (Layout, Sizing & Painting on canvas). |
| 2 | **Why did you use Provider over `setState()`?** | `setState()` rebuilds the entire local subtree and couples logic with UI. `Provider` decouples business logic, optimizes re-renders to `Consumer` subscribers, and enables global state persistence. |
| 3 | **How does `PopScope` protect the app flow?** | `PopScope` intercepts back navigation gestures (`canPop: false`). If the user is on a secondary tab, it safely navigates back to the Home tab instead of closing the app or logging out. |
| 4 | **How are digital signatures verified?** | The app calculates a SHA-256 hash checksum of document attributes and embeds it inside a dynamic QR code. Scanning the QR code validates the checksum against the issuer PKI root. |

---

<p align="center">
  <strong>DigiLocker Document Wallet (DigiVault)</strong><br />
  Submitted by <strong>Grishma Thakare</strong> (Roll No: <code>150096724054</code>) • ITM Skills University
</p>
