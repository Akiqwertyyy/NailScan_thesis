import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';

class AboutScreen extends StatefulWidget {
  final Function(String)? onNavigate;
  final String? currentScreen;

  const AboutScreen({
    super.key,
    this.onNavigate,
    this.currentScreen,
  });

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  static const Color _blue = Color(0xFF0F62FE);
  static const Color _darkBlue = Color(0xFF0B2E6F);
  static const Color _softBlue = Color(0xFFEAF2FF);
  static const Color _mutedBlue = Color(0xFF4667A0);
  static const Color _lightText = Color(0xFF8BA2C9);

  String? _expandedSection;

  final List<_ConditionInfo> _conditions = const [
    _ConditionInfo(
      name: 'Onychomycosis',
      description:
          'A fungal infection affecting the nail that may cause discoloration, thickening, and brittleness.',
      color: _blue,
    ),
    _ConditionInfo(
      name: 'Nail Pitting',
      description:
          'Small dents or pits on the surface of the nail, often associated with psoriasis or other skin conditions.',
      color: Color(0xFFFFA043),
    ),
    _ConditionInfo(
      name: 'Nail Clubbing',
      description:
          'A nail shape change where fingertips enlarge and nails curve downward, sometimes associated with chronic heart, lung, or liver conditions.',
      color: Color(0xFF8BB8FF),
    ),
    _ConditionInfo(
      name: 'Healthy Nail',
      description: 'Normal nail appearance with no visible abnormalities.',
      color: Color(0xFF35C58A),
    ),
    _ConditionInfo(
      name: 'Unidentified',
      description:
          'The image may be unclear or the nail pattern is outside the current detection scope.',
      color: Color(0xFF94A3B8),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) widget.onNavigate?.call('home');
          if (index == 1) widget.onNavigate?.call('history');
          if (index == 2) widget.onNavigate?.call('about');
        },
      ),
      body: Stack(
        children: [
          _buildBackground(size),
          SafeArea(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildBackground(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD5EBFF),
            Color(0xFFEEF7FF),
            Color(0xFFBFDFFF),
            Color(0xFF88C4FF),
          ],
          stops: [0.0, 0.34, 0.72, 1.0],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildLogo(),
          const SizedBox(height: 10),
          const Text(
            'NailScan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _darkBlue,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'AI-Powered Nail Health Analysis',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _mutedBlue,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _lightText,
            ),
          ),
          const SizedBox(height: 20),
          _buildExpandableMenuTile(
            keyName: 'what',
            leading: _buildSmallLogo(),
            title: 'What is NailScan?',
            child: _buildWhatIsNailScanContent(),
          ),
          const SizedBox(height: 8),
          _buildExpandableMenuTile(
            keyName: 'how',
            icon: Icons.auto_awesome_rounded,
            title: 'How It Works',
            child: _buildHowItWorksContent(),
          ),
          const SizedBox(height: 8),
          _buildExpandableMenuTile(
            keyName: 'conditions',
            icon: Icons.medical_information_outlined,
            title: 'Conditions Detected',
            child: _buildConditionsContent(),
          ),
          const SizedBox(height: 8),
          _buildExpandableMenuTile(
            keyName: 'notice',
            icon: Icons.warning_amber_rounded,
            title: 'Important Notice',
            child: _buildImportantNoticeContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
  return Row(
    children: [
      GestureDetector(
        onTap: () => widget.onNavigate?.call('home'),
        behavior: HitTestBehavior.opaque,
        child: Container(
  width: 42,
  height: 42,
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.38),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.white.withOpacity(0.62),
      width: 1,
    ),
  ),
  child: const Icon(
    Icons.arrow_back_ios_new_rounded,
    color: _darkBlue,
    size: 18,
  ),
),
      ),
      const SizedBox(width: 10),
      const Text(
        'About',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: _darkBlue,
        ),
      ),
    ],
  );
}
  Widget _buildLogo() {
    return Container(
      width: 82,
      height: 82,
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  color: Colors.white.withOpacity(0.4),
  border: Border.all(
    color: Colors.white.withOpacity(0.7),
    width: 1.5,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ],
),  

      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.fingerprint_rounded,
            color: Colors.white,
            size: 52,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallLogo() {
    return Container(
      width: 34,
      height: 34,

     decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(12),
  color: Colors.white.withOpacity(0.4), // light frosted
  border: Border.all(
    color: Colors.white.withOpacity(0.7),
    width: 1.2,
  ),
),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.fingerprint_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableMenuTile({
    required String keyName,
    IconData? icon,
    Widget? leading,
    required String title,
    required Widget child,
  }) {
    final isOpen = _expandedSection == keyName;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCFE0FF), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _blue.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _expandedSection = isOpen ? null : keyName;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    leading ??
                        Icon(
                          icon,
                          color: _blue,
                          size: 22,
                        ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _mutedBlue,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isOpen ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8AA6D6),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: child,
                ),
              ),
              crossFadeState:
                  isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 220),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatIsNailScanContent() {
    return const Text(
      'NailScan is a mobile application designed to assist in identifying visible nail conditions using image analysis. It aims to provide quick preliminary screening based on nail appearance patterns.',
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: _darkBlue,
        height: 1.35,
      ),
    );
  }

  Widget _buildHowItWorksContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'NailScan analyzes a captured or uploaded fingernail image and checks visible nail patterns such as color, shape, and texture.',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: _darkBlue,
            height: 1.35,
          ),
        ),
        SizedBox(height: 16),
        _StepItem(number: 1, text: 'Capture or upload a clear nail photo'),
        SizedBox(height: 10),
        _StepItem(number: 2, text: 'AI analyzes visible nail features'),
        SizedBox(height: 10),
        _StepItem(number: 3, text: 'Result appears with confidence score'),
      ],
    );
  }

  Widget _buildConditionsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _conditions
          .map(
            (condition) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: condition.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          condition.name,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _darkBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          condition.description,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: _mutedBlue,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildImportantNoticeContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _softBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCFE0FF)),
      ),
      child: const Text(
        'This app is intended for preliminary screening only and does not replace professional medical diagnosis. Always consult a qualified healthcare professional for proper medical advice and treatment.',
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: _darkBlue,
          height: 1.35,
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String text;

  const _StepItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8AB6FF)),
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F62FE),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4667A0),
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConditionInfo {
  final String name;
  final String description;
  final Color color;

  const _ConditionInfo({
    required this.name,
    required this.description,
    required this.color,
  });
}
