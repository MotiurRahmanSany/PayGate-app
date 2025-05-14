import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paygate/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    try {
      await dotenv.load(fileName: ".env"); // Load environment variables
    } catch (e) {
      throw Exception('Error loading .env file: $e'); // Print error if any
    }
  } catch (e) {}

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paygate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
