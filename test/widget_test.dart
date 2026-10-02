import 'package:flutter_test/flutter_test.dart';
import 'package:digivault_app/main.dart';
import 'package:digivault_app/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('DigiLocker App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    await tester.pumpWidget(const DigiVaultApp());
    expect(find.text('DigiLocker'), findsWidgets);

    // Fast-forward fake timer clock to finish splash screen navigation
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });
}
