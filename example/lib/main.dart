import 'package:flutter/material.dart';
import 'package:flutter_age/flutter_age.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterAge.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Age Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Age Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result = '';

  void _testEncryption() {
    final key = createKey();
    final message = 'Hello, Flutter Age!';
    final encrypted = encryptString(message: message, publicKey: key.publicKey);
    final decrypted = decryptString(ciphertext: encrypted, privateKey: key.privateKey);
    
    setState(() {
      _result = 'Original: $message\nEncrypted: $encrypted\nDecrypted: $decrypted';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press the button to test encryption:',
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _testEncryption,
        tooltip: 'Test Encryption',
        child: const Icon(Icons.security),
      ),
    );
  }
}
