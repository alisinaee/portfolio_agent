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
    const scheme = ColorScheme.dark(
      primary: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF0A0A0A),
      surface: Color(0xFF0A0A0A),
      onSurface: Color(0xFFF5F5F5),
      outline: Color(0xFF4B4B4B),
      secondary: Color(0xFFEDEDED),
    );

    final baseTextTheme = GoogleFonts.spaceGroteskTextTheme(
      ThemeData.dark(useMaterial3: true).textTheme,
    ).apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    return MaterialApp(
      title: 'Ali Sinaee Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: scheme.surface,
        textTheme: baseTextTheme.copyWith(
          labelLarge: GoogleFonts.spaceMono(
            textStyle: baseTextTheme.labelLarge,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          elevation: 0,
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.onSurface,
            shape: const RoundedRectangleBorder(),
            side: BorderSide(color: scheme.outline, width: 1),
            textStyle: GoogleFonts.spaceMono(
              textStyle: const TextStyle(fontSize: 13, letterSpacing: 0.4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            minimumSize: const Size(0, 40),
          ),
        ),
      ),
      home: const PortfolioApp(),
    );
  }
}
