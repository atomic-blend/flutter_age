import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_age/flutter_age.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  test('Can create key', () async {
    final key = createKey();
    print(key);
    expect(key, isA<Map<String, String>>());
  });
}
