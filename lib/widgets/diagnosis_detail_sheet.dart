import 'dart:io';
import 'package:flutter/material.dart';
import '../models/diagnosis_result.dart';

/// Full-screen bottom sheet showing diagnosis details.
/// When [onSaveToHistory] is provided (fresh result), shows "Discard" + "Save to History" buttons.
/// When null (opened from history), shows the original "Scan Again" button.
class DiagnosisDetailSheet extends StatelessWidget {
  final DiagnosisResult result;
  final String date;
  final String? imagePath;
  final VoidCallback onScanAgain;
  final VoidCallback? onSaveToHistory;

  const DiagnosisDetailSheet({
    super.key,
    required this.result,
    required this.date,
    required this.onScanAgain,
    this.onSaveToHistory,
    this.imagePath,
  });

  static Future<void> show(
    BuildContext context, {
    required DiagnosisResult result,
    required String date,
    required VoidCallback onScanAgain,
    VoidCallback? onSaveToHistory,
    String? imagePath,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: onSaveToHistory == null, // can't swipe-dismiss fresh result
      enableDrag: onSaveToHistory == null,
      builder: (_) => DiagnosisDetailSheet(
        result: result,
        date: date,
        imagePath: imagePath,
        onScanAgain: onScanAgain,
        onSaveToHistory: onSaveToHistory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.93,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEFF6FF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: const Border(
                    bottom: BorderSide(color: Color(0xFFDDEAFE)),
                  ),
                ),
                child: Row(
                  children: [
                    // Only show close button when opened from history
                    if (onSaveToHistory == null)
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child:
                            const Icon(Icons.close, color: Color(0xFF6B7280)),
                      )
                    else
                      const SizedBox(width: 24),
                    const Expanded(
                      child: Text(
                        'Diagnosis Result',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Thumbnail
                      if (imagePath != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildImage(imagePath!),
                        ),
                        const SizedBox(height: 16),
                      ],

                      _buildMainResultCard(context),
                      const SizedBox(height: 20),
                      _buildConditionDescription(),
                      const SizedBox(height: 12),
                      _buildListSection(
                        title: 'Underlying Causes',
                        items: result.underlyingCauses,
                        bulletColor: const Color(0xFF2563EB),
                        borderColor: const Color(0xFFDDEAFE),
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      _buildListSection(
                        title: 'Common Symptoms',
                        items: result.symptoms,
                        bulletColor: const Color(0xFF9333EA),
                        borderColor: const Color(0xFFF3E8FF),
                        backgroundColor: const Color(0xFFFAF5FF),
                      ),
                      const SizedBox(height: 12),
                      _buildTreatment(),
                      const SizedBox(height: 12),
                      _buildRiskLevel(),
                      const SizedBox(height: 12),
                      _buildRecommendation(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              // Bottom action buttons
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  border: const Border(
                    top: BorderSide(color: Color(0xFFDDEAFE)),
                  ),
                ),
                child: onSaveToHistory != null
                    // ── Fresh result: Discard + Save to History ──
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                onScanAgain();
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(
                                    color: Color(0xFFE5E7EB)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Discard',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                onSaveToHistory!();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Save to History',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    // ── Opened from history: Scan Again ──
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onScanAgain();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Scan Again',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImage(String path) {
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file,
          height: 160, width: double.infinity, fit: BoxFit.cover);
    }
    return Image.asset(
      path,
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_not_supported,
            color: Color(0xFF9CA3AF), size: 48),
      ),
    );
  }

  Widget _buildMainResultCard(BuildContext context) {
    final colors = result.getCardColors();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors['cardGradient'] as List<Color>,
        ),
        border: Border.all(color: colors['borderColor'] as Color),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Detected Condition',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 6),
          Text(
            result.condition,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors['badgeGradient'] as List<Color>,
              ),
              border:
                  Border.all(color: colors['badgeBorderColor'] as Color),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Confidence Score',
                  style:
                      TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 4),
                Text(
                  '${result.confidence}%',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colors['badgeTextColor'] as Color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Analysis Details',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildAnalysisCard('Shape', result.shape, Icons.crop_square),
          const SizedBox(height: 8),
          _buildAnalysisCard('Color', result.color, Icons.palette),
          const SizedBox(height: 8),
          _buildAnalysisCard('Texture', result.texture, Icons.texture),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDEAFE)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF6B7280))),
                const SizedBox(height: 3),
                Text(content,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF111827))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionDescription() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDEAFE)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Condition Description',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827))),
          const SizedBox(height: 10),
          Text(result.description,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF374151), height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildListSection({
    required String title,
    required List<String> items,
    required Color bulletColor,
    required Color borderColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827))),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ',
                        style: TextStyle(
                            color: bulletColor, fontSize: 13, height: 1.5)),
                    Expanded(
                      child: Text(item,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151),
                              height: 1.5)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTreatment() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0FDF4), Colors.white],
        ),
        border: Border.all(color: const Color(0xFFBBF7D0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Treatment Options',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827))),
          const SizedBox(height: 12),
          ...result.treatment.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 13,
                            height: 1.5)),
                    Expanded(
                      child: Text(item,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF374151),
                              height: 1.5)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Note: Treatment should be prescribed by a healthcare professional.',
              style: TextStyle(fontSize: 12, color: Color(0xFF065F46)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskLevel() {
    final riskColors = result.getRiskLevelColors();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: riskColors['background'],
        border: Border.all(color: riskColors['border']!, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Risk Level',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827))),
              Text(
                result.riskLevel.toString().split('.').last.toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: riskColors['text']),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: result.riskLevel == RiskLevel.low
                  ? 0.33
                  : result.riskLevel == RiskLevel.moderate
                      ? 0.66
                      : 1.0,
              minHeight: 10,
              backgroundColor: Colors.white,
              valueColor:
                  AlwaysStoppedAnimation<Color>(riskColors['color']!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFBFDBFE)],
        ),
        border: Border.all(
            color: const Color(0xFF2563EB).withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Color(0xFF2563EB), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recommendation',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB))),
                SizedBox(height: 6),
                Text(
                  'This result is AI-generated and intended for preliminary screening only. '
                  'Please consult a licensed healthcare professional for confirmation and treatment.',
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF374151),
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
