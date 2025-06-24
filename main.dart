// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_care/HomeScreen.dart';
import 'package:pet_care/firebase_options.dart';
import 'package:pet_care/LoginScreen.dart';

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
    cardTheme: CardThemeData(
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

ThemeData petCareFunTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
    useMaterial3: true,
    primaryColor: Colors.orangeAccent,
    scaffoldBackgroundColor: const Color(0xFFFFF8E1), // light fun yellow
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.orangeAccent,
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
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
        borderSide: const BorderSide(color: Colors.orangeAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.orangeAccent),
      prefixIconColor: Colors.orangeAccent,
      suffixIconColor: Colors.orangeAccent,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Colors.orangeAccent,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      bodyMedium: TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      labelLarge: TextStyle(
        color: Colors.orangeAccent,
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.orangeAccent),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.white,
    ),
  );
}

ThemeData petCareSoothingTheme() {
  return ThemeData(
    colorScheme:
        ColorScheme.fromSeed(seedColor: Color(0xFF81C784)), // soft green
    useMaterial3: true,
    primaryColor: const Color(0xFF81C784), // soft green
    scaffoldBackgroundColor: const Color(0xFFF1F8E9), // very light green
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF81C784),
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF81C784),
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
        borderSide: const BorderSide(color: Color(0xFF81C784)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF388E3C), width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF388E3C)),
      prefixIconColor: Color(0xFF81C784),
      suffixIconColor: Color(0xFF81C784),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: Color(0xFF388E3C),
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      bodyMedium: TextStyle(
        color: Colors.black87,
        fontSize: 16,
      ),
      labelLarge: TextStyle(
        color: Color(0xFF388E3C),
        fontWeight: FontWeight.w600,
      ),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF388E3C)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF81C784),
      foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF388E3C),
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xFF81C784),
      elevation: 2,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFFF1F8E9),
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
      theme: petCareSoothingTheme(),
      home: AuthGate(),
      // Ensure theme is available to all routes
      builder: (context, child) {
        return Theme(
          data: petCareSoothingTheme(),
          child: child!,
        );
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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
