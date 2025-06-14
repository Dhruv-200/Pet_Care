import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/LoginScreen.dart';
import 'package:pet_care/HomeScreen.dart'; // Import HomeScreen

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PetCareApp());
}

ThemeData petCareThemeData() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFFF6F9F6),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.teal),
      prefixIconColor: Colors.teal,
      suffixIconColor: Colors.teal,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      bodyMedium: TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      labelLarge: TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.teal),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    ),
  );
}

class PetCareApp extends StatefulWidget {
  const PetCareApp({super.key});

  @override
  State<PetCareApp> createState() => _PetCareAppState();
}

class _PetCareAppState extends State<PetCareApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Care Scheduler',
      theme: petCareThemeData(),
      home: AuthGate(), // Use AuthGate to keep user logged in
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class PetCareHomePage extends StatefulWidget {
  const PetCareHomePage({super.key, required this.title});

  final String title;

  @override
  State<PetCareHomePage> createState() => _PetCareHomePageState();
}

class _PetCareHomePageState extends State<PetCareHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Welcome to Pet Care Scheduler!'),
      ),
    );
  }
}
