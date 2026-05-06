import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_colors.dart';
import 'screens/about_screen.dart';
import 'screens/capture_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/processing_screen.dart';
import 'screens/splash_screen.dart';
import 'models/diagnosis_result.dart';
import 'models/history_item.dart';
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
      routes: {
        '/capture': (context) => const CaptureScreen(),
      },
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        primaryColor: AppColors.teal,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.teal,
          onPrimary: Colors.white,
          secondary: AppColors.darkBlue,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: AppColors.textDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.textDark,
        ),
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
  static const String _historyStorageKey = 'nailscan_history_items';
  static const String _historyIdStorageKey = 'nailscan_next_history_id';

  String _currentScreen = 'splash';
  String? _capturedImagePath;

  DiagnosisResult? _pendingResult;
  String? _pendingDate;

  final List<HistoryItem> _historyItems = [];
  int _nextHistoryId = 1;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadHistoryFromLocal();

    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;
    setState(() {
      _currentScreen = 'home';
    });
  }

  void _navigateToScreen(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _handleStartDiagnosis() {
    setState(() {
      _capturedImagePath = null;
      _currentScreen = 'capture';
    });
  }

  Future<void> _handleUploadImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _capturedImagePath = pickedFile.path;
          _currentScreen = 'capture';
        });
      }
    } catch (e) {
      debugPrint('Gallery pick failed: $e');
    }
  }

  Future<void> _handleTakePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _capturedImagePath = pickedFile.path;
          _currentScreen = 'capture';
        });
      }
    } catch (e) {
      debugPrint('Camera capture failed: $e');
    }
  }

  Future<String> _saveImageToLocal(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final scansDir = Directory(p.join(appDir.path, 'nail_scans'));

    if (!await scansDir.exists()) {
      await scansDir.create(recursive: true);
    }

    final extension = p.extension(sourcePath).isNotEmpty
        ? p.extension(sourcePath)
        : '.jpg';

    final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedPath = p.join(scansDir.path, fileName);

    final sourceFile = File(sourcePath);
    final savedFile = await sourceFile.copy(savedPath);

    return savedFile.path;
  }

  Future<void> _handleCapture(String? imagePath) async {
    if (imagePath == null) return;

    setState(() {
      _currentScreen = 'processing';
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final savedImagePath = await _saveImageToLocal(imagePath);
    final mockResult = _getMockDiagnosisResult();
    final now = DateTime.now();

    final dateStr =
        '${_monthName(now.month)} ${now.day}, ${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    final newItem = HistoryItem(
      id: _nextHistoryId++,
      condition: mockResult.condition,
      confidence: mockResult.confidence,
      date: dateStr,
      imagePath: savedImagePath,
      message: mockResult.description,
      type: _itemTypeFromResult(mockResult),
      diagnosisResult: mockResult,
    );

    setState(() {
      _historyItems.insert(0, newItem);
      _pendingResult = mockResult;
      _pendingDate = dateStr;
      _capturedImagePath = savedImagePath;
      _currentScreen = 'capture';
    });

    await _saveHistoryToLocal();

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      DiagnosisDetailSheet.show(
  context,
  result: mockResult,
  date: dateStr,
  imagePath: savedImagePath,
  onScanAgain: _handleScanAgain,
  onDelete: () async {
    await _deleteHistoryItem(newItem.id);
  },
).then((_) {
  if (!mounted) return;

  setState(() {
    _capturedImagePath = null;
    _pendingResult = null;
    _pendingDate = null;
    _currentScreen = 'capture';
  });
});
    });
  }

  void _handleScanAgain() {
    setState(() {
      _capturedImagePath = null;
      _pendingResult = null;
      _pendingDate = null;
      _currentScreen = 'capture';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleTakePhoto();
    });
  }

  void _handleBack() {
    setState(() {
      _currentScreen = 'home';
      _capturedImagePath = null;
    });
  }

  HistoryItemType _itemTypeFromResult(DiagnosisResult result) {
    if (result.condition == 'Healthy Nail') return HistoryItemType.healthy;
    if (result.condition == 'Unidentified') {
      return HistoryItemType.unidentified;
    }
    return HistoryItemType.disease;
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  DiagnosisResult _getMockDiagnosisResult() {
    return DiagnosisResult(
      condition: 'Acral Lentiginous Melanoma (ALM)',
      confidence: 88.3,
      riskLevel: RiskLevel.high,
      shape: 'Irregular pigmentation patterns along nail matrix',
      color: 'Dark brown to black longitudinal streaks',
      texture: 'Normal surface texture with pigmentation changes',
      description:
          'Acral Lentiginous Melanoma (ALM) is a rare but serious form of skin cancer that affects the nail matrix. Early detection is critical for successful treatment.',
      underlyingCauses: [
        'Genetic predisposition',
        'UV radiation exposure',
        'Trauma history',
      ],
      symptoms: [
        'Dark brown or black band in nail',
        'Pigmentation extending to cuticle',
        'Band widening over time',
        'Nail plate changes or destruction',
      ],
      treatment: [
        'Immediate dermatology referral',
        'Biopsy for definitive diagnosis',
        'Surgical excision if confirmed',
        'Regular follow-up',
      ],
    );
  }

  Map<String, dynamic> _historyItemToJson(HistoryItem item) {
    return {
      'id': item.id,
      'condition': item.condition,
      'confidence': item.confidence,
      'date': item.date,
      'message': item.message,
      'type': item.type.name,
      'imagePath': item.imagePath,
      'diagnosisResult': item.diagnosisResult?.toJson(),
    };
  }

  HistoryItem _historyItemFromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? 'unidentified';

    return HistoryItem(
      id: json['id'] as int,
      condition: json['condition'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      date: json['date'] as String,
      message: json['message'] as String? ?? '',
      type: HistoryItemType.values.firstWhere(
        (e) => e.name == typeName,
        orElse: () => HistoryItemType.unidentified,
      ),
      imagePath: json['imagePath'] as String?,
      diagnosisResult: json['diagnosisResult'] != null
          ? DiagnosisResult.fromJson(
              Map<String, dynamic>.from(json['diagnosisResult']))
          : null,
    );
  }

  Future<void> _saveHistoryToLocal() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedHistory = _historyItems
        .map((item) => _historyItemToJson(item))
        .toList();

    await prefs.setString(_historyStorageKey, jsonEncode(encodedHistory));
    await prefs.setInt(_historyIdStorageKey, _nextHistoryId);
  }

  Future<void> _loadHistoryFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString(_historyStorageKey);
    final savedNextId = prefs.getInt(_historyIdStorageKey);

    if (savedNextId != null) {
      _nextHistoryId = savedNextId;
    }

    if (historyString == null || historyString.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(historyString) as List<dynamic>;
      final loadedItems = decoded
          .map((item) => _historyItemFromJson(Map<String, dynamic>.from(item)))
          .toList();

      _historyItems
        ..clear()
        ..addAll(loadedItems);

      if (_historyItems.isNotEmpty) {
        final maxId = _historyItems
            .map((e) => e.id)
            .reduce((a, b) => a > b ? a : b);
        if (_nextHistoryId <= maxId) {
          _nextHistoryId = maxId + 1;
        }
      }
    } catch (e) {
      debugPrint('Failed to load history: $e');
    }
  }

  Future<void> _deleteHistoryItem(int id) async {
    final itemIndex = _historyItems.indexWhere((item) => item.id == id);
    if (itemIndex == -1) return;

    final imagePath = _historyItems[itemIndex].imagePath;

    setState(() {
      _historyItems.removeAt(itemIndex);
    });

    if (imagePath != null) {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await _saveHistoryToLocal();
  }

  Future<void> _clearAllHistory() async {
    for (final item in _historyItems) {
      final imagePath = item.imagePath;
      if (imagePath != null) {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    setState(() {
      _historyItems.clear();
    });

    await _saveHistoryToLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          width: 390,
          height: 844,
          decoration: const BoxDecoration(
            color: AppColors.background,
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
          onTakePhoto: _handleTakePhoto,
          onCapture: _handleCapture,
          onUploadImage: _handleUploadImage,
          selectedImage:
              _capturedImagePath != null ? File(_capturedImagePath!) : null,
        );

      case 'processing':
        return const ProcessingScreen();

      case 'history':
        return HistoryScreen(
          onNavigate: _navigateToScreen,
          currentScreen: _currentScreen,
          historyItems: _historyItems,
          onDeleteItem: (id) async {
            await _deleteHistoryItem(id);
          },
          onClearAll: () async {
            await _clearAllHistory();
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