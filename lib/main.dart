import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tegnordbok/screens/search_screen.dart';

void main() {
  runApp(const ProviderScope(child: TegnordbokApp()));
}

class TegnordbokApp extends StatelessWidget {
  const TegnordbokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tegnordbok",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SearchScreen(),
    );
  }
}
