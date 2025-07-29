import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_age/flutter_age.dart';
import 'package:flutter_age/src/rust/api/types.dart';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

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

  test('Can encrypt and decrypt small data', () async {
    // Create a key pair
    final key = createKey();
    
    // Test content
    const testContent = 'This is a test content for encryption!';
    final testData = testContent.codeUnits;
    
    // Encrypt the data
    final encryptedBase64 = encryptData(data: testData, publicKey: key.publicKey);
    expect(encryptedBase64, isA<String>());
    expect(encryptedBase64, isNotEmpty);
    expect(encryptedBase64, isNot(equals(testContent))); // Should be different from original
    
    // Decrypt the data
    final decryptedData = decryptData(
      encryptedDataBase64: encryptedBase64,
      privateKey: key.privateKey,
    );
    expect(decryptedData, isA<Uint8List>());
    expect(decryptedData, isNotEmpty);
    
    // Convert back to string and verify
    final decryptedContent = String.fromCharCodes(decryptedData);
    expect(decryptedContent, equals(testContent));
  });

  test('Can encrypt and decrypt large data', () async {
    // Create a key pair
    final key = createKey();
    
    // Generate large test content (100KB)
    final random = Random(42); // Fixed seed for reproducible tests
    final testContent = String.fromCharCodes(
      List.generate(100000, (i) => random.nextInt(26) + 97) // Random lowercase letters
    );
    final testData = testContent.codeUnits;
    
    // Encrypt the data
    final encryptedBase64 = encryptData(data: testData, publicKey: key.publicKey);
    expect(encryptedBase64, isA<String>());
    expect(encryptedBase64, isNotEmpty);
    expect(encryptedBase64, isNot(equals(testContent))); // Should be different from original
    
    // Decrypt the data
    final decryptedData = decryptData(
      encryptedDataBase64: encryptedBase64,
      privateKey: key.privateKey,
    );
    expect(decryptedData, isA<Uint8List>());
    expect(decryptedData.length, equals(testData.length));
    
    // Convert back to string and verify
    final decryptedContent = String.fromCharCodes(decryptedData);
    expect(decryptedContent, equals(testContent));
    expect(decryptedContent.length, equals(testContent.length));
  });

  test('Can encrypt and decrypt data with special characters', () async {
    // Create a key pair
    final key = createKey();
    
    // Test content with special characters
    const testContent = 'Hello! @#\$%^&*()_+-=[]{}|;:,.<>?`~"\'\\\n\r\t';
    final testData = testContent.codeUnits;
    
    // Encrypt the data
    final encryptedBase64 = encryptData(data: testData, publicKey: key.publicKey);
    expect(encryptedBase64, isA<String>());
    expect(encryptedBase64, isNotEmpty);
    
    // Decrypt the data
    final decryptedData = decryptData(
      encryptedDataBase64: encryptedBase64,
      privateKey: key.privateKey,
    );
    expect(decryptedData, isA<Uint8List>());
    
    // Convert back to string and verify
    final decryptedContent = String.fromCharCodes(decryptedData);
    expect(decryptedContent, equals(testContent));
  });

  test('Can encrypt and decrypt empty data', () async {
    // Create a key pair
    final key = createKey();
    
    // Test empty data
    final testData = <int>[];
    
    // Encrypt the data
    final encryptedBase64 = encryptData(data: testData, publicKey: key.publicKey);
    expect(encryptedBase64, isA<String>());
    expect(encryptedBase64, isNotEmpty);
    
    // Decrypt the data
    final decryptedData = decryptData(
      encryptedDataBase64: encryptedBase64,
      privateKey: key.privateKey,
    );
    expect(decryptedData, isA<Uint8List>());
    expect(decryptedData, isEmpty);
    
    // Convert back to string and verify
    final decryptedContent = String.fromCharCodes(decryptedData);
    expect(decryptedContent, equals(''));
  });

  test('Can encrypt and decrypt binary data', () async {
    // Create a key pair
    final key = createKey();
    
    // Test binary data (random bytes)
    final random = Random(42);
    final testData = List<int>.generate(1000, (i) => random.nextInt(256));
    
    // Encrypt the data
    final encryptedBase64 = encryptData(data: testData, publicKey: key.publicKey);
    expect(encryptedBase64, isA<String>());
    expect(encryptedBase64, isNotEmpty);
    
    // Decrypt the data
    final decryptedData = decryptData(
      encryptedDataBase64: encryptedBase64,
      privateKey: key.privateKey,
    );
    expect(decryptedData, isA<Uint8List>());
    expect(decryptedData.length, equals(testData.length));
    
    // Verify binary data matches
    expect(decryptedData, equals(testData));
  });
}
