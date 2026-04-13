import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/capture_screen.dart';
import 'screens/processing_screen.dart';
import 'screens/history_screen.dart';
import 'screens/about_screen.dart';
import 'models/history_item.dart';
import 'models/diagnosis_result.dart';
import 'widgets/diagnosis_detail_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const NailScanApp());
}

class NailScanApp extends StatelessWidget {
  const NailScanApp({super.key});

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
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  String _currentScreen = 'splash';
  String? _capturedImagePath; // holds Firebase download URL after upload

  // Pending result — held until the user confirms saving
  DiagnosisResult? _pendingResult;
  String? _pendingDate;

  // Shared history list
  final List<HistoryItem> _historyItems = [];
  int _nextHistoryId = 1;

  @override
  void initState() {
    super.initState();
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

  /// Uploads image to Firebase Storage and returns the download URL.
  Future<String?> _uploadImage(String localPath) async {
    try {
      final file = File(localPath);
      final fileName = 'scans/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      print('✅ Firebase image URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Image upload failed: $e');
      return null;
    }
  }

  /// Saves diagnosis result to Firestore.
  Future<void> _saveToFirestore(HistoryItem item) async {
    try {
      await FirebaseFirestore.instance.collection('scan_history').add({
        'condition': item.condition,
        'confidence': item.confidence,
        'date': item.date,
        'imageUrl': item.imagePath ?? '',
        'message': item.message,
        'type': item.type.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Saved to Firestore');
    } catch (e) {
      print('❌ Firestore save failed: $e');
    }
  }

  Future<void> _handleCapture(String? imagePath) async {
    setState(() {
      _currentScreen = 'processing';
    });

    // Upload image to Firebase Storage first
    String? imageUrl;
    if (imagePath != null) {
      imageUrl = await _uploadImage(imagePath);
    }

    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    final mockResult = _getMockDiagnosisResult();
    final now = DateTime.now();
    final dateStr =
        '${_monthName(now.month)} ${now.day}, ${now.year}  '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _pendingResult = mockResult;
      _pendingDate = dateStr;
      _capturedImagePath = imageUrl; // Firebase URL (or null if upload failed)
      _currentScreen = 'result';
    });
  }

  /// Called when user taps "Save to History".
  Future<void> _handleSaveResult() async {
    if (_pendingResult == null) return;

    final newItem = HistoryItem(
      id: _nextHistoryId++,
      condition: _pendingResult!.condition,
      confidence: _pendingResult!.confidence,
      date: _pendingDate!,
      imagePath: _capturedImagePath,
      message: _pendingResult!.description,
      type: _itemTypeFromResult(_pendingResult!),
      diagnosisResult: _pendingResult,
    );

    // Save to Firestore
    await _saveToFirestore(newItem);

    setState(() {
      _historyItems.insert(0, newItem);
      _pendingResult = null;
      _pendingDate = null;
      _capturedImagePath = null;
      _currentScreen = 'history';
    });
  }

  /// Called when user taps "Discard".
  void _handleScanAgain() {
    setState(() {
      _capturedImagePath = null;
      _pendingResult = null;
      _pendingDate = null;
      _currentScreen = 'home';
    });
  }

  void _handleBack() {
    setState(() {
      _currentScreen = 'home';
    });
  }

  HistoryItemType _itemTypeFromResult(DiagnosisResult result) {
    if (result.condition == 'Healthy Nail') return HistoryItemType.healthy;
    if (result.condition == 'Unidentified') return HistoryItemType.unidentified;
    return HistoryItemType.disease;
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  /// Replace with your real AI result once integrated.
  DiagnosisResult _getMockDiagnosisResult() {
    return DiagnosisResult(
      condition: 'Acral Lentiginous Melanoma (ALM)',
      confidence: 88.3,
      riskLevel: RiskLevel.high,
      shape: 'Irregular pigmentation patterns along nail matrix',
      color: 'Dark brown to black longitudinal streaks',
      texture: 'Normal surface texture with pigmentation changes',
      description:
          'Acral Lentiginous Melanoma (ALM) is a rare but serious form of skin cancer '
          'that affects the nail matrix. Early detection is critical for successful treatment.',
      underlyingCauses: [
        'Genetic predisposition',
        'UV radiation exposure (less common for ALM)',
        'Trauma history (possible trigger)',
      ],
      symptoms: [
        'Dark brown or black band in nail',
        'Pigmentation extending to cuticle (Hutchinson\'s sign)',
        'Band widening over time',
        'Nail plate changes or destruction',
        'Ulceration or bleeding in advanced cases',
      ],
      treatment: [
        'Immediate dermatology/oncology referral',
        'Biopsy for definitive diagnosis',
        'Surgical excision of affected tissue',
        'Regular monitoring and follow-up',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
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
          child: ClipRect(
            child: _buildCurrentScreen(),
          ),
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
        return _ResultBridge(
          result: _pendingResult!,
          date: _pendingDate!,
          imagePath: _capturedImagePath,
          onSave: _handleSaveResult,
          onDiscard: _handleScanAgain,
        );

      case 'history':
        return HistoryScreen(
          onNavigate: _navigateToScreen,
          currentScreen: _currentScreen,
          historyItems: _historyItems,
          onDeleteItem: (id) {
            setState(() {
              _historyItems.removeWhere((item) => item.id == id);
            });
          },
          onClearAll: () {
            setState(() {
              _historyItems.clear();
            });
          },
          onScanAgain: _handleScanAgain,
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

/// Bridges the processing screen to the DiagnosisDetailSheet.
/// Mounts a background screen and immediately opens the sheet.
/// The user must either "Save to History" or "Discard" — no back-swipe.
class _ResultBridge extends StatefulWidget {
  final DiagnosisResult result;
  final String date;
  final String? imagePath;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const _ResultBridge({
    required this.result,
    required this.date,
    required this.imagePath,
    required this.onSave,
    required this.onDiscard,
  });

  @override
  State<_ResultBridge> createState() => _ResultBridgeState();
}

class _ResultBridgeState extends State<_ResultBridge> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DiagnosisDetailSheet.show(
        context,
        result: widget.result,
        date: widget.date,
        imagePath: widget.imagePath,
        onScanAgain: widget.onDiscard,
        onSaveToHistory: widget.onSave,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFEFF6FF),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF2563EB),
        ),
      ),
    );
  }
}
