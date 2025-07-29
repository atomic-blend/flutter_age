# flutter_age

A Flutter plugin that provides age encryption functionality using the [age](https://age-encryption.org/) encryption tool. This plugin uses Flutter Rust Bridge to interface with the age Rust library, providing secure file encryption and decryption capabilities.

## Features

- 🔐 Generate age encryption keys (public/private key pairs)
- 📁 Encrypt and decrypt files using age encryption
- 🛡️ Secure key management with proper memory handling
- 📱 Cross-platform support (iOS, Android, macOS, Linux, Windows)
- ⚡ High-performance native Rust implementation

## Installation

Add `flutter_age` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_age: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Initialize the plugin

```dart
import 'package:flutter_age/flutter_age.dart';

void main() async {
  // Initialize the Rust library
  await RustLib.init();
  runApp(MyApp());
}
```

### Generate age keys

```dart
import 'package:flutter_age/flutter_age.dart';

// Generate a new age key pair
Map<String, String> keyPair = createKey();

print('Public key: ${keyPair['public_key']}');
print('Private key: ${keyPair['private_key']}');
```

### Example output

```
Public key: age156uf0wqrftqmtfjzpgl80tjc9jy8rte3y4kwwm5p2fjneajf53zq3avr7h
Private key: AGE-SECRET-KEY-1EG6UVJTHMJ44Q4HTXS3M2PKQ65SQ7RJXXGSXA9Q0A0HGYRZ6V9HSHFE4AP
```

## API Reference

### Functions

#### `createKey()`

Generates a new age encryption key pair.

**Returns:** `Map<String, String>` - A map containing:
- `public_key`: The public key for encryption
- `private_key`: The private key for decryption

**Example:**
```dart
Map<String, String> keys = createKey();
String publicKey = keys['public_key']!;
String privateKey = keys['private_key']!;
```

## Platform Support

| Platform | Support |
|----------|---------|
| iOS | ✅ |
| Android | ✅ |
| macOS | ✅ |
| Linux | ✅ |
| Windows | ✅ |
| Web | ❌ |

## Security

This plugin uses the official [age](https://age-encryption.org/) encryption tool, which provides:

- **Modern cryptography**: Uses ChaCha20-Poly1305 for encryption and Ed25519 for key exchange
- **Secure key generation**: Cryptographically secure random key generation
- **Memory safety**: Proper memory handling with Rust's ownership system
- **No external dependencies**: Self-contained encryption without external tools

## Development

This plugin is built using [Flutter Rust Bridge](https://github.com/fzyzcjy/flutter_rust_bridge), which provides seamless integration between Flutter and Rust.

### Project Structure

```
flutter_age/
├── lib/                    # Dart API
├── rust/                   # Rust implementation
│   ├── src/
│   │   └── api/           # Rust API functions
│   └── Cargo.toml         # Rust dependencies
├── example/               # Example Flutter app
└── flutter_rust_bridge.yaml # Code generation config
```

### Building from source

1. Clone the repository:
```bash
git clone https://github.com/your-username/flutter_age.git
cd flutter_age
```

2. Install dependencies:
```bash
flutter pub get
cd rust && cargo build --release
cd ..
```

3. Generate Dart bindings:
```bash
flutter_rust_bridge_codegen generate
```

4. Run the example:
```bash
cd example
flutter run
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [age encryption tool](https://age-encryption.org/) - The underlying encryption library
- [Flutter Rust Bridge](https://github.com/fzyzcjy/flutter_rust_bridge) - For seamless Flutter-Rust integration

