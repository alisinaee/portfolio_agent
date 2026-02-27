import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'portfolio_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinetic Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.playfairDisplayTextTheme(
          ThemeData.dark().textTheme,
        ),
        useMaterial3: true,
      ),
      home: const PortfolioApp(),
    );
  }
}
