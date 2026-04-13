import 'package:flutter/material.dart';
import '../models/diagnosis_result.dart';

/// Result screen displaying diagnosis with detailed analysis
class ResultScreen extends StatefulWidget {
  final VoidCallback onScanAgain;
  final String? imagePath;

  const ResultScreen({
    super.key,
    required this.onScanAgain,
    this.imagePath,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _currentResultIndex = 0;

  // Mock results for demonstration
  final List<DiagnosisResult> _results = [
    DiagnosisResult(
      condition: 'Onychomycosis',
      confidence: 94.8,
      riskLevel: RiskLevel.moderate,
      shape: 'Irregular edges with thickened nail plate',
      color: 'Yellow-brown discoloration throughout',
      texture: 'Rough, brittle surface with visible debris',
      description: 'Onychomycosis is a fungal infection of the nail. It may cause discoloration, thickening, and separation from the nail bed. Early detection and treatment can prevent progression.',
      underlyingCauses: [
        'Dermatophyte fungi (most common)',
        'Yeast infections (Candida species)',
        'Non-dermatophyte molds',
      ],
      symptoms: [
        'Thickened nails',
        'Yellow, brown, or white discoloration',
        'Brittle, crumbly, or ragged nail edges',
        'Distorted nail shape',
        'Separation from nail bed',
        'Dark debris buildup under nail',
      ],
      treatment: [
        'Antifungal medications (oral or topical)',
        'Laser therapy in some cases',
        'Surgical nail removal for severe cases',
        'Duration: 6-12 months for full recovery',
      ],
    ),
    DiagnosisResult(
      condition: 'Acral Lentiginous Melanoma (ALM)',
      confidence: 88.3,
      riskLevel: RiskLevel.high,
      shape: 'Irregular pigmentation patterns along nail matrix',
      color: 'Dark brown to black longitudinal streaks',
      texture: 'Normal surface texture with pigmentation changes',
      description: 'Acral Lentiginous Melanoma (ALM) is a rare but serious form of skin cancer that affects the nail matrix. It presents as dark pigmentation, often in a longitudinal band. Early detection is critical for successful treatment.',
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
        'Possible amputation in advanced cases',
        'Regular monitoring and follow-up',
      ],
    ),
    DiagnosisResult(
      condition: 'Nail Clubbing',
      confidence: 86.7,
      riskLevel: RiskLevel.moderate,
      shape: 'Bulbous fingertip with increased nail curvature',
      color: 'Normal pink to slightly blue-tinted nail bed',
      texture: 'Smooth surface with exaggerated convex curvature',
      description: 'Nail clubbing is characterized by enlargement of the fingertips and increased nail curvature. It can be associated with various underlying medical conditions affecting the heart, lungs, or gastrointestinal system.',
      underlyingCauses: [
        'Chronic lung diseases (COPD, lung cancer)',
        'Cardiovascular conditions (congenital heart disease)',
        'Gastrointestinal disorders (IBD, cirrhosis)',
        'Hyperthyroidism',
      ],
      symptoms: [
        'Bulbous enlargement of fingertips',
        'Increased nail curvature (convex)',
        'Loss of normal nail bed angle',
        'Spongy or floating sensation at nail base',
        'Possible shortness of breath (if lung-related)',
      ],
      treatment: [
        'Treat underlying medical condition',
        'Comprehensive medical evaluation required',
        'Pulmonary or cardiac assessment',
        'No direct treatment for clubbing itself',
        'Regular monitoring of progression',
      ],
    ),
    DiagnosisResult(
      condition: 'Healthy Nail',
      confidence: 98.2,
      riskLevel: RiskLevel.low,
      shape: 'Normal, smooth, and evenly curved nail plate',
      color: 'Pink nail bed with white lunula visible',
      texture: 'Smooth, uniform surface without irregularities',
      description: 'The nail appears healthy with no visible abnormalities detected. The nail shows normal color, shape, and texture characteristics consistent with good nail health.',
      underlyingCauses: [
        'Proper nutrition and hydration',
        'Good nail hygiene practices',
        'Absence of trauma or infection',
      ],
      symptoms: [
        'Pink, uniform nail bed color',
        'Smooth nail surface',
        'Normal thickness and strength',
        'No discoloration or irregularities',
        'Healthy cuticle condition',
      ],
      treatment: [
        'Maintain current nail care routine',
        'Keep nails clean and trimmed',
        'Moisturize cuticles regularly',
        'Protect nails from harsh chemicals',
        'Continue balanced diet with adequate nutrients',
      ],
    ),
    DiagnosisResult(
      condition: 'Unidentified',
      confidence: 42.1,
      riskLevel: RiskLevel.low,
      shape: 'Unclear or atypical presentation',
      color: 'Inconclusive color analysis',
      texture: 'Unable to determine texture pattern',
      description: 'The AI model could not confidently identify a specific condition based on the provided image. This may be due to image quality, unusual presentation, or a condition outside the training dataset.',
      underlyingCauses: [
        'Poor image quality or lighting',
        'Atypical condition presentation',
        'Condition outside detection scope',
        'Multiple overlapping conditions',
      ],
      symptoms: [
        'Confidence score below threshold',
        'No clear pattern match',
        'Ambiguous visual features',
      ],
      treatment: [
        'Consult a dermatologist for professional evaluation',
        'Provide high-quality images if retaking photo',
        'Describe any symptoms to healthcare provider',
        'Consider in-person clinical examination',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final result = _results[_currentResultIndex];

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
          _buildHeader(),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildMainResultCard(result),
                  const SizedBox(height: 24),
                  _buildConditionDescription(result),
                  const SizedBox(height: 16),
                  _buildUnderlyingCauses(result),
                  const SizedBox(height: 16),
                  _buildSymptoms(result),
                  const SizedBox(height: 16),
                  _buildTreatment(result),
                  const SizedBox(height: 16),
                  _buildRiskLevel(result),
                  const SizedBox(height: 16),
                  _buildNailCareTips(),
                  const SizedBox(height: 16),
                  _buildRecommendation(),
                ],
              ),
            ),
          ),

          // Bottom Button
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFF2563EB)),
              onPressed: () {
                setState(() {
                  _currentResultIndex = (_currentResultIndex - 1 + _results.length) % _results.length;
                });
              },
            ),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Diagnosis Result',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Example ${_currentResultIndex + 1} of ${_results.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF2563EB)),
              onPressed: () {
                setState(() {
                  _currentResultIndex = (_currentResultIndex + 1) % _results.length;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainResultCard(DiagnosisResult result) {
    final colors = result.getCardColors();
    
    return Container(
      padding: const EdgeInsets.all(24),
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
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.condition,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors['badgeGradient'] as List<Color>,
              ),
              border: Border.all(color: colors['badgeBorderColor'] as Color),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Confidence Score',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${result.confidence}%',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: colors['badgeTextColor'] as Color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Analysis Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDEAFE)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionDescription(DiagnosisResult result) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDEAFE)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Condition Description',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            result.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderlyingCauses(DiagnosisResult result) {
    return _buildListSection(
      title: 'Underlying Causes',
      items: result.underlyingCauses,
      bulletColor: const Color(0xFF2563EB),
      borderColor: const Color(0xFFDDEAFE),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildSymptoms(DiagnosisResult result) {
    return _buildListSection(
      title: 'Common Symptoms',
      items: result.symptoms,
      bulletColor: const Color(0xFF9333EA),
      borderColor: const Color(0xFFF3E8FF),
      backgroundColor: const Color(0xFFFAF5FF),
    );
  }

  Widget _buildTreatment(DiagnosisResult result) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Treatment Options',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          ...result.treatment.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Note: Treatment should be prescribed by a healthcare professional based on proper diagnosis.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF065F46),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskLevel(DiagnosisResult result) {
    final riskColors = result.getRiskLevelColors();

    return Container(
      padding: const EdgeInsets.all(24),
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
              const Text(
                'Risk Level',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                result.riskLevel.toString().split('.').last.toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: riskColors['text'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: result.riskLevel == RiskLevel.low
                  ? 0.33
                  : result.riskLevel == RiskLevel.moderate
                      ? 0.66
                      : 1.0,
              minHeight: 12,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(riskColors['color']!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNailCareTips() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
        ),
        border: Border.all(color: const Color(0xFFFDE68A), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Color(0xFFD97706), size: 20),
              SizedBox(width: 8),
              Text(
                'Nail Care Tips',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem('Keep nails clean and dry'),
          _buildTipItem('Avoid sharing nail tools'),
          _buildTipItem('Trim nails regularly'),
          _buildTipItem('Seek professional consultation if symptoms persist'),
        ],
      ),
    );
  }

  Widget _buildRecommendation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEFF6FF), Color(0xFFBFDBFE)],
        ),
        border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Color(0xFF2563EB), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommendation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This result is AI-generated and intended for preliminary screening only. Please consult a licensed healthcare professional for confirmation and treatment.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    color: bulletColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF374151),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFFD97706),
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

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(
          top: BorderSide(color: Color(0xFFDDEAFE)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onScanAgain,
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
    );
  }
}
