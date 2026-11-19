import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AgroRegistroApp());
}

class AgroRegistroApp extends StatelessWidget {
  const AgroRegistroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroRegistro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
