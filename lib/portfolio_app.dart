import 'package:flutter/material.dart';

import 'widgets/kinetic_landing_view.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // The rotated content layer
          Positioned.fill(
            child: Center(
              child: Transform.rotate(
                angle: -15 * 3.1415926535 / 180, // -15 degrees in radians
                child: OverflowBox(
                  maxWidth: MediaQuery.of(context).size.width * 2 + 1000, 
                  maxHeight: double.infinity,
                  child: KineticLandingView(isMenuOpen: _isMenuOpen),
                ),
              ),
            ),
          ),
          
          // Fixed Hamburger Menu Layer
          Positioned(
            top: MediaQuery.of(context).padding.top > 0 ? MediaQuery.of(context).padding.top + 20 : 50,
            right: 30,
            child: IconButton(
              iconSize: 40,
              icon: Icon(
                _isMenuOpen ? Icons.close : Icons.menu,
                color: Colors.white,
              ),
              onPressed: _toggleMenu,
            ),
          ),
        ],
      ),
    );
  }
}


