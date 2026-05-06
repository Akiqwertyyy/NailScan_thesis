import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

// ── Blue NailScan palette ─────────────────────────────────────────────────
const Color _primary = Color(0xFF006DFF);
const Color _primaryLight = Color(0xFF29A8FF);
const Color _primaryDark = Color(0xFF0051D9);
const Color _bgLight = Color(0xFFDCEBFF);
const Color _bgMid = Color(0xFFBFDFFF);
const Color _bgDeep = Color(0xFF5EACFF);
const Color _textDark = Color(0xFF071F55);
const Color _textMid = Color(0xFF3F5F8F);
const Color _textMuted = Color(0xFF64789A);
const Color _cardBorder = Color(0xFFFFFFFF);

const Color _healthy = Color(0xFF159947);
const Color _danger = Color(0xFF0B6BFF);
const Color _unident = Color(0xFF7A8797);
const Color _warning = Color(0xFFFF9500);

// ── Result model ─────────────────────────────────────────────────────────
enum ConditionType { healthy, disease, unidentified }

class DiagnosisResult {
  final String condition;
  final double confidence;
  final ConditionType type;
  final String description;
  final String shapeDetail;
  final String colorDetail;
  final String textureDetail;
  final File? imageFile;

  const DiagnosisResult({
    required this.condition,
    required this.confidence,
    required this.type,
    required this.description,
    required this.shapeDetail,
    required this.colorDetail,
    required this.textureDetail,
    this.imageFile,
  });
}

// ── Dynamic details model ─────────────────────────────────────────────────
class _ResultInfo {
  final String subtitle;
  final String conditionDescription;
  final String causes;
  final List<String> symptoms;
  final List<String> treatment;
  final String risk;
  final String riskNote;

  const _ResultInfo({
    required this.subtitle,
    required this.conditionDescription,
    required this.causes,
    required this.symptoms,
    required this.treatment,
    required this.risk,
    required this.riskNote,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────
class ResultScreen extends StatefulWidget {
  final DiagnosisResult result;

  /// Fired once on load — persist the record here.
  final VoidCallback? onAutoSaved;

  /// Called when the user taps Done.
  final VoidCallback? onDone;

  /// Called when the user taps Scan Again.
  final VoidCallback? onScanAgain;

  const ResultScreen({
    super.key,
    required this.result,
    this.onAutoSaved,
    this.onDone,
    this.onScanAgain,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutQuart,
    ));

    _fadeController.forward();
    _slideController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAutoSaved?.call();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Color get _statusColor {
    switch (widget.result.type) {
      case ConditionType.healthy:
        return _healthy;
      case ConditionType.disease:
        return _danger;
      case ConditionType.unidentified:
        return _unident;
    }
  }

  IconData get _statusIcon {
    switch (widget.result.type) {
      case ConditionType.healthy:
        return Icons.verified_rounded;
      case ConditionType.disease:
        return Icons.health_and_safety_rounded;
      case ConditionType.unidentified:
        return Icons.help_rounded;
    }
  }

  _ResultInfo get _info {
    final key = widget.result.condition.toLowerCase();

    if (key.contains('healthy')) {
      return const _ResultInfo(
        subtitle: 'Normal nail appearance',
        conditionDescription:
            'Nail appearance is within normal visual characteristics for color, texture, and shape.',
        causes: 'No specific causes listed.',
        symptoms: [
          'Even color',
          'Smooth nail surface',
          'No clear visible lesions',
          'No visible deformity',
        ],
        treatment: [
          'Maintain regular nail hygiene',
          'Avoid prolonged moisture exposure',
          'Use protective gloves when handling chemicals',
          'Monitor any sudden nail changes',
        ],
        risk: 'Low',
        riskNote: 'No immediate visual risk detected from the captured image.',
      );
    }

    if (key.contains('club')) {
      return const _ResultInfo(
        subtitle: 'Abnormal nail curvature',
        conditionDescription:
            'This result indicates possible nail clubbing, which is commonly associated with increased nail curvature and enlarged fingertip appearance.',
        causes:
            'Possible underlying respiratory, cardiovascular, or systemic conditions may contribute to nail clubbing.',
        symptoms: [
          'Increased nail curvature',
          'Bulbous fingertip appearance',
          'Softened nail bed',
          'Rounded nail shape',
        ],
        treatment: [
          'Seek medical evaluation',
          'Monitor changes over time',
          'Avoid self-diagnosis',
          'Consult a healthcare professional if symptoms persist',
        ],
        risk: 'High',
        riskNote:
            'Medical evaluation is recommended because clubbing may be linked to underlying health conditions.',
      );
    }

    if (key.contains('pitting')) {
      return const _ResultInfo(
        subtitle: 'Small depressions on nail surface',
        conditionDescription:
            'This result indicates nail pitting, which appears as small dents or depressions on the nail surface.',
        causes:
            'Nail pitting may be associated with psoriasis, inflammatory skin conditions, or nail growth disruption.',
        symptoms: [
          'Small dents on nail',
          'Uneven nail surface',
          'Rough nail texture',
          'Possible nail discoloration',
        ],
        treatment: [
          'Keep nails trimmed',
          'Avoid nail trauma',
          'Use gentle nail care routines',
          'Consult a dermatologist if symptoms persist',
        ],
        risk: 'Moderate',
        riskNote:
            'Further observation or dermatology consultation may be helpful if nail changes continue.',
      );
    }

    if (key.contains('unidentified')) {
      return const _ResultInfo(
        subtitle: 'Unable to classify confidently',
        conditionDescription:
            'The system could not confidently classify the nail image. This may be due to low image quality, obstruction, or unsupported nail condition.',
        causes:
            'Possible causes include blurred image, poor lighting, nail polish, artificial nails, wrong angle, or an unsupported condition.',
        symptoms: [
          'Low confidence result',
          'Unclear nail features',
          'Obstructed nail view',
          'Image quality issues',
        ],
        treatment: [
          'Retake the photo in good lighting',
          'Keep the nail centered and clearly visible',
          'Remove nail polish or obstruction if possible',
          'Consult a professional for persistent concerns',
        ],
        risk: 'Unknown',
        riskNote:
            'The result should not be interpreted as a diagnosis. Please retake the image or seek professional advice.',
      );
    }

    return const _ResultInfo(
      subtitle: 'Fungal infection of the nail',
      conditionDescription:
          'This result indicates a fungal infection (onychomycosis) that affects the nail. It commonly causes discoloration, thickening, and brittleness.',
      causes:
          'Fungal organisms thrive in warm, moist environments and may spread through shared items or poor hygiene.',
      symptoms: [
        'Yellow or white discoloration',
        'Thickened or brittle nail',
        'Crumbling edges',
        'Distorted nail shape',
      ],
      treatment: [
        'Keep nails clean and dry',
        'Use antifungal treatments as recommended',
        'Avoid walking barefoot in public areas',
        'Consult a dermatologist if symptoms persist',
      ],
      risk: 'Moderate',
      riskNote:
          'Early treatment is recommended to prevent further spread and complications.',
    );
  }

  Color get _riskColor {
    switch (_info.risk.toLowerCase()) {
      case 'low':
        return _healthy;
      case 'high':
        return const Color(0xFFFF4D4F);
      case 'unknown':
        return _unident;
      default:
        return _warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _BlueBackground(),
          const _SoftCircle(top: -90, left: -70, size: 250, opacity: .24),
          const _SoftCircle(top: 160, right: -90, size: 220, opacity: .14),
          const _SoftCircle(bottom: -110, right: -80, size: 270, opacity: .20),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _BokehPainter()),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(child: _buildScrollableContent()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 20,
            child: _BackButton(
              onTap: () => Navigator.maybePop(context),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Diagnosis Result',
                style: TextStyle(
                  color: _textDark,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.4,
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Here’s what we found",
                style: TextStyle(
                  color: _textMid,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        18,
        4,
        18,
        18 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _imagePreview(),
          const SizedBox(height: 10),
          _summaryCard(),
          const SizedBox(height: 10),
          _savedCard(),
          const SizedBox(height: 10),
          _analysisDetailsCard(),
          const SizedBox(height: 10),
          _infoCard(
            icon: Icons.description_outlined,
            title: 'Condition Description',
            content: _info.conditionDescription,
          ),
          const SizedBox(height: 10),
          _infoCard(
            icon: Icons.coronavirus_rounded,
            title: 'Underlying Causes',
            content: _info.causes,
          ),
          const SizedBox(height: 10),
          _bulletCard(
            icon: Icons.stethoscope_rounded,
            title: 'Common Symptoms',
            bullets: _info.symptoms,
            twoColumns: true,
          ),
          const SizedBox(height: 10),
          _bulletCard(
            icon: Icons.health_and_safety_outlined,
            title: 'Treatment Guidance',
            bullets: _info.treatment,
          ),
          const SizedBox(height: 10),
          _riskCard(),
          const SizedBox(height: 12),
          _bottomButtons(),
        ],
      ),
    );
  }

  Widget _imagePreview() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.22),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(.95), width: 2),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(.13),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.result.imageFile != null)
              Image.file(
                widget.result.imageFile!,
                fit: BoxFit.cover,
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD8EDFF),
                      Color(0xFFB7DCFF),
                      Color(0xFF8EC7FF),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_rounded,
                    size: 54,
                    color: Colors.white70,
                  ),
                ),
              ),
            const _CornerGuides(),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    final info = _info;
    final conditionColor =
        widget.result.type == ConditionType.healthy ? _healthy : _statusColor;

    return _glassContainer(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      child: Row(
        children: [
          _IconBubble(
            icon: _statusIcon,
            color: conditionColor,
            filled: true,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.result.condition,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: conditionColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  info.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textMid,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 78,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.88),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(.95)),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(.08),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  '${widget.result.confidence.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.6,
                  ),
                ),
                const Text(
                  'Confidence',
                  style: TextStyle(
                    color: _textMid,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _savedCard() {
    return _glassContainer(
      tint: _healthy.withOpacity(.07),
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _healthy.withOpacity(.10),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: _healthy,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saved to History',
                  style: TextStyle(
                    color: _healthy,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'You can view this result in your history.',
                  style: TextStyle(
                    color: _textMid,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _analysisDetailsCard() {
    return _glassContainer(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis Details',
            style: TextStyle(
              color: _textDark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _miniAnalysisItem(
                  icon: Icons.crop_square_rounded,
                  label: 'Shape',
                  detail: widget.result.shapeDetail,
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _miniAnalysisItem(
                  icon: Icons.palette_rounded,
                  label: 'Color',
                  detail: widget.result.colorDetail,
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _miniAnalysisItem(
                  icon: Icons.blur_circular_rounded,
                  label: 'Texture',
                  detail: widget.result.textureDetail,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniAnalysisItem({
    required IconData icon,
    required String label,
    required String detail,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconBubble(icon: icon, color: _primary),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: _textDark,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          detail,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _textMid,
            fontSize: 11.8,
            height: 1.35,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 96,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFFB9D9FF).withOpacity(.85),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return _glassContainer(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBubble(icon: icon, color: _primary),
          const SizedBox(width: 14),
          Expanded(
            child: _sectionText(title: title, content: content),
          ),
        ],
      ),
    );
  }

  Widget _bulletCard({
    required IconData icon,
    required String title,
    required List<String> bullets,
    bool twoColumns = false,
  }) {
    final midpoint = (bullets.length / 2).ceil();
    final left = bullets.take(midpoint).toList();
    final right = bullets.skip(midpoint).toList();

    return _glassContainer(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBubble(icon: icon, color: _primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(title),
                const SizedBox(height: 7),
                if (twoColumns)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _bulletList(left)),
                      const SizedBox(width: 12),
                      Expanded(child: _bulletList(right)),
                    ],
                  )
                else
                  _bulletList(bullets),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskCard() {
    return _glassContainer(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      child: Row(
        children: [
          _IconBubble(icon: Icons.warning_amber_rounded, color: _primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Risk Level'),
                const SizedBox(height: 4),
                Text(
                  _info.risk,
                  style: TextStyle(
                    color: _riskColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _info.riskNote,
                  style: const TextStyle(
                    color: _textMid,
                    fontSize: 12.3,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _RiskGauge(color: _riskColor),
        ],
      ),
    );
  }

  Widget _bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: _BottomButton(
            icon: Icons.center_focus_strong_rounded,
            title: 'Scan Again',
            subtitle: 'Take a new photo',
            filled: false,
            onTap: widget.onScanAgain ??
                () => Navigator.pushReplacementNamed(context, '/capture'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _BottomButton(
            icon: Icons.check_rounded,
            title: 'Done',
            subtitle: 'Go to Home',
            filled: true,
            onTap: widget.onDone ??
                () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _textDark,
        fontSize: 14.2,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _sectionText({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            color: _textMid,
            fontSize: 12.6,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      color: _primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: _textMid,
                        fontSize: 12.3,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _glassContainer({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    Color? tint,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: tint ?? Colors.white.withOpacity(.82),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(.95), width: 1.3),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(.09),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ── Small reusable widgets ────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.82),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(.95)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: _primary,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool filled;

  const _IconBubble({
    required this.icon,
    required this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : color.withOpacity(.10),
        boxShadow: filled
            ? [
                BoxShadow(
                  color: color.withOpacity(.24),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                )
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: filled ? Colors.white : color,
        size: 26,
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback onTap;

  const _BottomButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: filled ? null : Colors.white.withOpacity(.84),
          gradient: filled
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_primaryLight, _primary, _primaryDark],
                )
              : null,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: filled ? Colors.white.withOpacity(.55) : _primary.withOpacity(.65),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: _primary.withOpacity(filled ? .26 : .10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? Colors.white : _primary.withOpacity(.10),
              ),
              child: Icon(
                icon,
                color: filled ? _primary : _primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: filled ? Colors.white : _primary,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: filled ? Colors.white.withOpacity(.88) : _textMid,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskGauge extends StatelessWidget {
  final Color color;

  const _RiskGauge({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 62,
      child: CustomPaint(
        painter: _RiskGaugePainter(color: color),
      ),
    );
  }
}

class _RiskGaugePainter extends CustomPainter {
  final Color color;

  const _RiskGaugePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * .95);
    final radius = size.width * .42;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(
      rect,
      3.14,
      .95,
      false,
      basePaint..color = const Color(0xFF52C76B),
    );
    canvas.drawArc(
      rect,
      4.15,
      .85,
      false,
      basePaint..color = const Color(0xFFFFD400),
    );
    canvas.drawArc(
      rect,
      5.05,
      .95,
      false,
      basePaint..color = const Color(0xFFFF5A4F),
    );

    final needlePaint = Paint()
      ..color = _textDark
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    double angle;
    if (color == _healthy) {
      angle = 3.85;
    } else if (color == const Color(0xFFFF4D4F)) {
      angle = 5.55;
    } else {
      angle = 4.85;
    }

    final needleEnd = Offset(
      center.dx + radius * .72 * MathHelper.cos(angle),
      center.dy + radius * .72 * MathHelper.sin(angle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 6, Paint()..color = _primary);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MathHelper {
  static double sin(double x) => _fastSin(x);
  static double cos(double x) => _fastSin(x + 1.57079632679);

  static double _fastSin(double x) {
    // Small approximation is enough for this static decorative gauge.
    const double pi = 3.1415926535897932;
    while (x > pi) {
      x -= 2 * pi;
    }
    while (x < -pi) {
      x += 2 * pi;
    }
    return x * (1.27323954 - 0.405284735 * x.abs());
  }
}

// ── Corner guide overlay ──────────────────────────────────────────────────

class _CornerGuides extends StatelessWidget {
  const _CornerGuides();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CornerGuidePainter(),
      child: Container(),
    );
  }
}

class _CornerGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const corner = 34.0;
    const inset = 19.0;

    canvas.drawLine(const Offset(inset, inset), const Offset(inset + corner, inset), paint);
    canvas.drawLine(const Offset(inset, inset), const Offset(inset, inset + corner), paint);

    canvas.drawLine(Offset(size.width - inset - corner, inset), Offset(size.width - inset, inset), paint);
    canvas.drawLine(Offset(size.width - inset, inset), Offset(size.width - inset, inset + corner), paint);

    canvas.drawLine(Offset(inset, size.height - inset), Offset(inset + corner, size.height - inset), paint);
    canvas.drawLine(Offset(inset, size.height - inset - corner), Offset(inset, size.height - inset), paint);

    canvas.drawLine(Offset(size.width - inset - corner, size.height - inset), Offset(size.width - inset, size.height - inset), paint);
    canvas.drawLine(Offset(size.width - inset, size.height - inset - corner), Offset(size.width - inset, size.height - inset), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Background ────────────────────────────────────────────────────────────

class _BlueBackground extends StatelessWidget {
  const _BlueBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _bgLight,
            _bgMid,
            Color(0xFF88C4FF),
            _bgDeep,
          ],
          stops: [0.0, .38, .76, 1.0],
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final double opacity;

  const _SoftCircle({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(opacity),
              Colors.white.withOpacity(opacity * .45),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _BokehPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dots = [
      [0.08, 0.12, 18.0, 0.18],
      [0.88, 0.06, 12.0, 0.13],
      [0.15, 0.55, 10.0, 0.10],
      [0.92, 0.35, 22.0, 0.15],
      [0.5, 0.08, 8.0, 0.12],
      [0.75, 0.75, 16.0, 0.10],
      [0.3, 0.88, 20.0, 0.08],
      [0.65, 0.5, 6.0, 0.09],
      [0.02, 0.72, 14.0, 0.11],
      [0.95, 0.88, 10.0, 0.08],
    ];

    for (final dot in dots) {
      canvas.drawCircle(
        Offset(size.width * dot[0], size.height * dot[1]),
        dot[2],
        Paint()
          ..color = Colors.white.withOpacity(dot[3])
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}