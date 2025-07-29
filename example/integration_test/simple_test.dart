import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_age/flutter_age.dart';
import 'package:flutter_age/src/rust/api/types.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  
  test('Can create key', () async {
    final key = createKey();
    expect(key, isA<AgeKey>());
    expect(key.publicKey, isA<String>());
    expect(key.privateKey, isA<String>());
    expect(key.publicKey.startsWith('age'), isTrue);
    expect(key.privateKey.startsWith('AGE-SECRET-KEY'), isTrue);
  });

  test('Can encrypt and decrypt string', () async {
    // Create a key pair
    final key = createKey();
    
    // Test message
    const testMessage = 'Hello, this is a secret message!';
    
    // Encrypt the message using the public key
    final encrypted = encryptString(message: testMessage, publicKey: key.publicKey);
    expect(encrypted, isA<String>());
    expect(encrypted, isNotEmpty);
    expect(encrypted, isNot(equals(testMessage))); // Should be different from original

    // Decrypt the message using the private key
    final decrypted = decryptString(ciphertext: encrypted, privateKey: key.privateKey);
    expect(decrypted, isA<String>());
    expect(decrypted, equals(testMessage)); // Should match original message
  });

  test('Can encrypt and decrypt with special characters', () async {
    // Create a key pair
    final key = createKey();
    
    // Test message with special characters
    final testMessage = 'Hello! @#\$%^&*()_+-=[]{}|;:,.<>?`~"\'\\';
    
    // Encrypt the message
    final encrypted = encryptString(message: testMessage, publicKey: key.publicKey);
    expect(encrypted, isNotEmpty);
    
    // Decrypt the message
    final decrypted = decryptString(ciphertext: encrypted, privateKey: key.privateKey);
    expect(decrypted, equals(testMessage));
  });

  test('Can encrypt and decrypt empty string', () async {
    // Create a key pair
    final key = createKey();
    
    // Test empty message
    const testMessage = '';
    
    // Encrypt the message
    final encrypted = encryptString(message: testMessage, publicKey: key.publicKey);
    expect(encrypted, isNotEmpty);
    
    // Decrypt the message
    final decrypted = decryptString(ciphertext: encrypted, privateKey: key.privateKey);
    expect(decrypted, equals(testMessage));
  });

  test('Can encrypt and decrypt long message', () async {
    // Create a key pair
    final key = createKey();
    
    // Test long message
    final testMessage = 'A'.padRight(1000, 'A'); // 1000 character message
    
    // Encrypt the message
    final encrypted = encryptString(message: testMessage, publicKey: key.publicKey);
    expect(encrypted, isNotEmpty);
    
    // Decrypt the message
    final decrypted = decryptString(ciphertext: encrypted, privateKey: key.privateKey);
    expect(decrypted, equals(testMessage));
  });
}
