# flutter_age

A Flutter plugin that provides age encryption functionality using Rust and Flutter Rust Bridge.

## Features

- Generate age encryption keys (public/private key pairs)
- Encrypt strings and binary data using age encryption
- Decrypt strings and binary data using age encryption
- Cross-platform support (Android, iOS, macOS, Linux, Windows, Web)

## Getting Started

### Installation

Add `flutter_age` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_age: ^0.0.1
```

### Platform Configuration

#### Automatic Configuration (All platforms except Web)

For Android, iOS, macOS, Linux, and Windows, the configuration is handled automatically by the plugin. No additional setup is required.

#### Web Configuration

For web support, you need to manually generate the Rust WebAssembly files since Flutter doesn't include the package's web directory when building your app.

1. Clone the `flutter_age` package locally
2. Run the following command to generate the Rust WASM files in your app's web directory:

```bash
flutter_rust_bridge_codegen build-web --release -o ~/workspace/atomic-blend/app
```

Replace `~/workspace/atomic-blend/app` with the path to your app's web directory.

### Usage

```dart
import 'package:flutter_age/flutter_age.dart';

// Initialize the plugin
await FlutterAge.init();

// Generate a new key pair
AgeKey key = createKey();

// Encrypt a string
String encrypted = encryptString("Hello, World!", key.publicKey);

// Decrypt a string
String decrypted = decryptString(encrypted, key.privateKey);

// Encrypt binary data
List<int> data = [1, 2, 3, 4, 5];
String encryptedData = encryptData(data, key.publicKey);

// Decrypt binary data
List<int> decryptedData = decryptData(encryptedData, key.privateKey);
```

## API Reference

### Functions

- `createKey()` - Generates a new age key pair
- `encryptString(String message, String publicKey)` - Encrypts a string using a public key
- `decryptString(String ciphertext, String privateKey)` - Decrypts a string using a private key
- `encryptData(List<int> data, String publicKey)` - Encrypts binary data using a public key
- `decryptData(String encryptedDataBase64, String privateKey)` - Decrypts binary data using a private key

### Types

- `AgeKey` - Contains a public key and private key pair

## Updating the Package

When a new version of the package is available:

1. Update the version in your `pubspec.yaml`
2. Pull the version of the package corresponding to the new version in pubspec
3. Regenerate the WASM files for your app using the web configuration command above

## Project Structure

This plugin uses Flutter Rust Bridge to connect Dart code with Rust implementations:

- `lib/` - Contains the Dart API definitions and generated bindings
- `rust/` - Contains the Rust implementation using the age encryption library
- `web/` - Contains the generated WebAssembly files for web support

## Dependencies

- `flutter_rust_bridge: 2.11.1` - For Rust-Dart interop
- `age` - Rust age encryption library
- `base64` - For encoding/decoding encrypted data

## License

This project is licensed under the terms specified in the LICENSE file.

