# NailScan Flutter Conversion Guide

This document provides complete Flutter/Dart code for converting the NailScan React app to Flutter.

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── capture_screen.dart
│   ├── processing_screen.dart
│   ├── result_screen.dart
│   ├── history_screen.dart
│   └── about_screen.dart
├── models/
│   ├── scan_result.dart
│   └── history_item.dart
├── widgets/
│   └── bottom_navigation_bar.dart
└── services/
    └── ai_model_service.dart
```

## 1. pubspec.yaml

```yaml
name: nailscan
description: AI-Powered Nail Health Analysis
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # UI Components
  cupertino_icons: ^1.0.2
  
  # Image handling
  image_picker: ^1.0.4
  camera: ^0.10.5+5
  
  # State management
  provider: ^6.0.5
  
  # HTTP requests (for AI API integration)
  http: ^1.1.0
  dio: ^5.3.3
  
  # Animations
  flutter_animate: ^4.2.0
  
  # Storage (for history)
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Date formatting
  intl: ^0.18.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: ^0.13.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.6

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/logo.png
    
  fonts:
    - family: Inter
      fonts:
        - asset: fonts/Inter-Regular.ttf
        - asset: fonts/Inter-Bold.ttf
          weight: 700
        - asset: fonts/Inter-SemiBold.ttf
          weight: 600
```

## 2. main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/capture_screen.dart';
import 'screens/processing_screen.dart';
import 'screens/result_screen.dart';
import 'screens/history_screen.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const NailScanApp());
}

class NailScanApp extends StatelessWidget {
  const NailScanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NailScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        useMaterial3: true,
      ),
      home: const AppNavigator(),
    );
  }
}

// Main navigation controller
class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  String _currentScreen = 'splash';

  @override
  void initState() {
    super.initState();
    // Auto-navigate from splash to home after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _currentScreen = 'home';
        });
      }
    });
  }

  void _navigateToScreen(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _handleStartDiagnosis() {
    setState(() {
      _currentScreen = 'capture';
    });
  }

  void _handleCapture() {
    setState(() {
      _currentScreen = 'processing';
    });
    
    // Simulate AI processing
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _currentScreen = 'result';
        });
      }
    });
  }

  void _handleScanAgain() {
    setState(() {
      _currentScreen = 'home';
    });
  }

  void _handleBack() {
    setState(() {
      _currentScreen = 'home';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        // Mobile container - iPhone 13 dimensions (390 x 844)
        child: Container(
          width: 390,
          height: 844,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _buildCurrentScreen(),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 'splash':
        return const SplashScreen();
      case 'home':
        return HomeScreen(
          onStartDiagnosis: _handleStartDiagnosis,
          onNavigate: _navigateToScreen,
          currentScreen: _currentScreen,
        );
      case 'capture':
        return CaptureScreen(
          onBack: _handleBack,
          onCapture: _handleCapture,
        );
      case 'processing':
        return const ProcessingScreen();
      case 'result':
        return ResultScreen(
          onScanAgain: _handleScanAgain,
        );
      case 'history':
        return HistoryScreen(
          onNavigate: _navigateToScreen,
          currentScreen: _currentScreen,
        );
      case 'about':
        return AboutScreen(
          onNavigate: _navigateToScreen,
          currentScreen: _currentScreen,
        );
      default:
        return const SplashScreen();
    }
  }
}
```

## 3. screens/splash_screen.dart

```dart
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEFF6FF), // blue-50
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // Top Section - 40%
          Expanded(
            flex: 4,
            child: Center(
              child: Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          
          // Center Section - 60%
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'NailScan',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'AI-Powered Nail Health Analysis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Section - Loading indicator
          Expanded(
            flex: 2,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedDot(0),
                  const SizedBox(width: 8),
                  _buildAnimatedDot(150),
                  const SizedBox(width: 8),
                  _buildAnimatedDot(300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -10 * value),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
```

## 4. screens/home_screen.dart

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartDiagnosis;
  final Function(String) onNavigate;
  final String currentScreen;

  const HomeScreen({
    Key? key,
    required this.onStartDiagnosis,
    required this.onNavigate,
    required this.currentScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEFF6FF),
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 140),
            child: Column(
              children: [
                // Header with logo
                Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'NailScan',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'AI-Powered Nail Health Analysis',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Description
                const Text(
                  'Scan your fingernail to detect possible conditions using advanced AI technology.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Start Diagnosis Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onStartDiagnosis,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Start Diagnosis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Info Cards
                _buildInfoCard(
                  icon: Icons.analytics,
                  text: 'Instant AI-powered analysis',
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  icon: Icons.history,
                  text: 'Track your nail health history',
                ),
                
                const SizedBox(height: 48),
                
                // Disclaimer
                const Text(
                  'This system provides AI-assisted preliminary screening only. Not a substitute for professional medical advice.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDEAFE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2563EB),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _buildNavButton(
            icon: Icons.home,
            label: 'Diagnose',
            isActive: currentScreen == 'home',
            onTap: () => onNavigate('home'),
          ),
          const SizedBox(width: 12),
          _buildNavButton(
            icon: Icons.history,
            label: 'History',
            isActive: currentScreen == 'history',
            onTap: () => onNavigate('history'),
          ),
          const SizedBox(width: 12),
          _buildNavButton(
            icon: Icons.info,
            label: 'About',
            isActive: currentScreen == 'about',
            onTap: () => onNavigate('about'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  )
                : null,
            color: isActive ? null : Colors.white,
            border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF6B7280),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 5. screens/capture_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CaptureScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onCapture;

  const CaptureScreen({
    Key? key,
    required this.onBack,
    required this.onCapture,
  }) : super(key: key);

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  File? _capturedImage;
  final ImagePicker _picker = ImagePicker();
  String? _errorMessage;

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Camera permission was denied. Please use the "Upload Image" button below to select a photo from your gallery instead.';
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      
      if (image != null) {
        setState(() {
          _capturedImage = File(image.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load image from gallery.';
      });
    }
  }

  void _handleAnalyze() {
    if (_capturedImage != null) {
      widget.onCapture();
    }
  }

  void _handleRetake() {
    setState(() {
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEFF6FF),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              border: const Border(
                bottom: BorderSide(color: Color(0xFFDDEAFE)),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: const Color(0xFF374151),
                    onPressed: widget.onBack,
                  ),
                  const Expanded(
                    child: Text(
                      'Capture Nail Image',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Instructions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'For better scan results:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInstructionItem('Ensure good lighting'),
                        _buildInstructionItem('Keep the nail clearly visible'),
                        _buildInstructionItem('Avoid shadows'),
                        _buildInstructionItem('Keep the nail clean'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Image Preview
                  _capturedImage != null
                      ? Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF2563EB),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              _capturedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFBFDBFE),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 64,
                                color: Color(0xFFBFDBFE),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No image selected',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  if (_capturedImage != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleAnalyze,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Analyze Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _handleRetake,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFFBFDBFE),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Retake Photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _takePhoto,
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text(
                          'Take Photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _uploadImage,
                        icon: const Icon(Icons.image, color: Color(0xFF374151)),
                        label: const Text(
                          'Upload Image',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFFBFDBFE),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  // Error Message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber,
                            color: Color(0xFFD97706),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Camera Not Available',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF78350F),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF92400E),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## 6. screens/processing_screen.dart

```dart
import 'package:flutter/material.dart';

class ProcessingScreen extends StatelessWidget {
  const ProcessingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEFF6FF),
            Colors.white,
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Loading Spinner
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Text
              const Text(
                'Analyzing your nail...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Our AI is examining color, shape, and texture patterns',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                '(EfficientNetV2-L)',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 7. Additional Screens (Continued in Next Part)

Due to length limitations, I'll continue with the remaining screens in the next section. Would you like me to continue with:
- ResultScreen (with all 5 conditions and detailed analysis)
- HistoryScreen (with delete functionality)
- AboutScreen (with app information)
- Models and Services

The conversion follows these key principles:
1. **Layout**: React's `div` → Flutter's `Container`, `Column`, `Row`, `Stack`
2. **Styling**: CSS classes → `BoxDecoration`, `TextStyle`, `EdgeInsets`
3. **State**: `useState` → `StatefulWidget` with `setState`
4. **Navigation**: React state-based navigation → Flutter's Navigator or custom state management
5. **Responsive**: Tailwind classes → `MediaQuery` and `LayoutBuilder`
6. **Images**: `figma:asset` imports → Flutter asset system
7. **Icons**: `lucide-react` → Flutter's Material Icons or custom icons

Would you like me to continue with the remaining components?
