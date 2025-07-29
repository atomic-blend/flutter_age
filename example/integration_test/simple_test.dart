import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_age/flutter_age.dart';
import 'package:flutter_age/src/rust/api/types.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  test('Can create key', () async {
    final key = createKey();
    print(key);
    expect(key, isA<AgeKey>());
    expect(key.publicKey, isA<String>());
    expect(key.privateKey, isA<String>());
    expect(key.publicKey.startsWith('age'), isTrue);
    expect(key.privateKey.startsWith('AGE-SECRET-KEY'), isTrue);
  });
}
