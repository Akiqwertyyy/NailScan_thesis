import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProcessingScreen extends StatelessWidget {
  const ProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔥 SOFT DARK BLUE GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A), // deep blue
              Color(0xFF2563EB), // primary blue
              Color(0xFF3B82F6), // lighter blend
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // 🔵 PROGRESS CIRCLE
                SizedBox(
                  width: 170,
                  height: 170,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: .75,
                        strokeWidth: 10,
                        backgroundColor: Colors.white.withOpacity(.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF93C5FD),
                        ),
                      ),

                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(.15),
                          ),
                        ),
                      ),

                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Analyzing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Please wait',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Analyzing your nail image\nusing AI model',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: .55,
                    minHeight: 7,
                    backgroundColor: Colors.white.withOpacity(.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF93C5FD),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}