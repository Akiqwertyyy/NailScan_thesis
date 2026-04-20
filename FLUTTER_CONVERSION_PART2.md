# NailScan Flutter Conversion - Part 2

## 7. screens/result_screen.dart

```dart
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final VoidCallback onScanAgain;

  const ResultScreen({
    Key? key,
    required this.onScanAgain,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _currentResultIndex = 0;

  final List<Map<String, dynamic>> _results = [
    {
      'condition': 'Onychomycosis',
      'confidence': 94.8,
      'riskLevel': 'Moderate',
      'cardGradient': [const Color(0xFFFEF2F2), Colors.white],
      'borderColor': const Color(0xFFFECACA),
      'badgeGradient': [const Color(0xFFFEE2E2), const Color(0xFFFEF2F2)],
      'badgeBorderColor': const Color(0xFFFECACA),
      'badgeTextColor': const Color(0xFFDC2626),
      'shape': 'Irregular edges with thickened nail plate',
      'color': 'Yellow-brown discoloration throughout',
      'texture': 'Rough, brittle surface with visible debris',
      'description':
          'Onychomycosis is a fungal infection of the nail. It may cause discoloration, thickening, and separation from the nail bed. Early detection and treatment can prevent progression.',
      'underlyingCauses': [
        'Dermatophyte fungi (most common)',
        'Yeast infections (Candida species)',
        'Non-dermatophyte molds',
      ],
      'symptoms': [
        'Thickened nails',
        'Yellow, brown, or white discoloration',
        'Brittle, crumbly, or ragged nail edges',
        'Distorted nail shape',
        'Separation from nail bed',
        'Dark debris buildup under nail',
      ],
      'treatment': [
        'Antifungal medications (oral or topical)',
        'Laser therapy in some cases',
        'Surgical nail removal for severe cases',
        'Duration: 6-12 months for full recovery',
      ],
    },
    {
      'condition': 'Acral Lentiginous Melanoma (ALM)',
      'confidence': 88.3,
      'riskLevel': 'High',
      'cardGradient': [const Color(0xFFFEF2F2), Colors.white],
      'borderColor': const Color(0xFFFECACA),
      'badgeGradient': [const Color(0xFFFEE2E2), const Color(0xFFFEF2F2)],
      'badgeBorderColor': const Color(0xFFFECACA),
      'badgeTextColor': const Color(0xFFDC2626),
      'shape': 'Irregular pigmentation patterns along nail matrix',
      'color': 'Dark brown to black longitudinal streaks',
      'texture': 'Normal surface texture with pigmentation changes',
      'description':
          'Acral Lentiginous Melanoma (ALM) is a rare but serious form of skin cancer that affects the nail matrix. It presents as dark pigmentation, often in a longitudinal band. Early detection is critical for successful treatment.',
      'underlyingCauses': [
        'Genetic predisposition',
        'UV radiation exposure (less common for ALM)',
        'Trauma history (possible trigger)',
      ],
      'symptoms': [
        'Dark brown or black band in nail',
        'Pigmentation extending to cuticle (Hutchinson\'s sign)',
        'Band widening over time',
        'Nail plate changes or destruction',
        'Ulceration or bleeding in advanced cases',
      ],
      'treatment': [
        'Immediate dermatology/oncology referral',
        'Biopsy for definitive diagnosis',
        'Surgical excision of affected tissue',
        'Possible amputation in advanced cases',
        'Regular monitoring and follow-up',
      ],
    },
    {
      'condition': 'Nail Clubbing',
      'confidence': 86.7,
      'riskLevel': 'Moderate',
      'cardGradient': [const Color(0xFFFFFBEB), Colors.white],
      'borderColor': const Color(0xFFFED7AA),
      'badgeGradient': [const Color(0xFFFED7AA), const Color(0xFFFFFBEB)],
      'badgeBorderColor': const Color(0xFFFED7AA),
      'badgeTextColor': const Color(0xFFEA580C),
      'shape': 'Bulbous fingertip with increased nail curvature',
      'color': 'Normal pink to slightly blue-tinted nail bed',
      'texture': 'Smooth surface with exaggerated convex curvature',
      'description':
          'Nail clubbing is characterized by enlargement of the fingertips and increased nail curvature. It can be associated with various underlying medical conditions affecting the heart, lungs, or gastrointestinal system.',
      'underlyingCauses': [
        'Chronic lung diseases (COPD, lung cancer)',
        'Cardiovascular conditions (congenital heart disease)',
        'Gastrointestinal disorders (IBD, cirrhosis)',
        'Hyperthyroidism',
      ],
      'symptoms': [
        'Bulbous enlargement of fingertips',
        'Increased nail curvature (convex)',
        'Loss of normal nail bed angle',
        'Spongy or floating sensation at nail base',
        'Possible shortness of breath (if lung-related)',
      ],
      'treatment': [
        'Treat underlying medical condition',
        'Comprehensive medical evaluation required',
        'Pulmonary or cardiac assessment',
        'No direct treatment for clubbing itself',
        'Regular monitoring of progression',
      ],
    },
    {
      'condition': 'Healthy Nail',
      'confidence': 98.2,
      'riskLevel': 'Low',
      'cardGradient': [const Color(0xFFF0FDF4), Colors.white],
      'borderColor': const Color(0xFFBBF7D0),
      'badgeGradient': [const Color(0xFFDCFCE7), const Color(0xFFF0FDF4)],
      'badgeBorderColor': const Color(0xFFBBF7D0),
      'badgeTextColor': const Color(0xFF16A34A),
      'shape': 'Normal, smooth, and evenly curved nail plate',
      'color': 'Pink nail bed with white lunula visible',
      'texture': 'Smooth, uniform surface without irregularities',
      'description':
          'The nail appears healthy with no visible abnormalities detected. The nail shows normal color, shape, and texture characteristics consistent with good nail health.',
      'underlyingCauses': [
        'Proper nutrition and hydration',
        'Good nail hygiene practices',
        'Absence of trauma or infection',
      ],
      'symptoms': [
        'Pink, uniform nail bed color',
        'Smooth nail surface',
        'Normal thickness and strength',
        'No discoloration or irregularities',
        'Healthy cuticle condition',
      ],
      'treatment': [
        'Maintain current nail care routine',
        'Keep nails clean and trimmed',
        'Moisturize cuticles regularly',
        'Protect nails from harsh chemicals',
        'Continue balanced diet with adequate nutrients',
      ],
    },
    {
      'condition': 'Unidentified',
      'confidence': 42.1,
      'riskLevel': 'Low',
      'cardGradient': [const Color(0xFFF9FAFB), Colors.white],
      'borderColor': const Color(0xFFD1D5DB),
      'badgeGradient': [const Color(0xFFF3F4F6), const Color(0xFFF9FAFB)],
      'badgeBorderColor': const Color(0xFFE5E7EB),
      'badgeTextColor': const Color(0xFF6B7280),
      'shape': 'Unclear or atypical presentation',
      'color': 'Inconclusive color analysis',
      'texture': 'Unable to determine texture pattern',
      'description':
          'The AI model could not confidently identify a specific condition based on the provided image. This may be due to image quality, unusual presentation, or a condition outside the training dataset.',
      'underlyingCauses': [
        'Poor image quality or lighting',
        'Atypical condition presentation',
        'Condition outside detection scope',
        'Multiple overlapping conditions',
      ],
      'symptoms': [
        'Confidence score below threshold',
        'No clear pattern match',
        'Ambiguous visual features',
      ],
      'treatment': [
        'Consult a dermatologist for professional evaluation',
        'Provide high-quality images if retaking photo',
        'Describe any symptoms to healthcare provider',
        'Consider in-person clinical examination',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final result = _results[_currentResultIndex];
    final riskColors = _getRiskLevelColors(result['riskLevel']);

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
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Main Result Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: result['cardGradient'],
                      ),
                      border: Border.all(color: result['borderColor']),
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
                          result['condition'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
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
                              colors: result['badgeGradient'],
                            ),
                            border: Border.all(color: result['badgeBorderColor']),
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
                                '${result['confidence']}%',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: result['badgeTextColor'],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Analysis Details
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
                        _buildAnalysisCard('Shape', result['shape'], Icons.crop_square),
                        const SizedBox(height: 8),
                        _buildAnalysisCard('Color', result['color'], Icons.palette),
                        const SizedBox(height: 8),
                        _buildAnalysisCard('Texture', result['texture'], Icons.texture),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Condition Description
                  _buildInfoSection(
                    title: 'Condition Description',
                    content: result['description'],
                    borderColor: const Color(0xFFDDEAFE),
                    backgroundColor: Colors.white,
                  ),

                  const SizedBox(height: 16),

                  // Underlying Causes
                  _buildListSection(
                    title: 'Underlying Causes',
                    items: List<String>.from(result['underlyingCauses']),
                    bulletColor: const Color(0xFF2563EB),
                    borderColor: const Color(0xFFDDEAFE),
                    backgroundColor: Colors.white,
                  ),

                  const SizedBox(height: 16),

                  // Common Symptoms
                  _buildListSection(
                    title: 'Common Symptoms',
                    items: List<String>.from(result['symptoms']),
                    bulletColor: const Color(0xFF9333EA),
                    borderColor: const Color(0xFFF3E8FF),
                    backgroundColor: const Color(0xFFFAF5FF),
                  ),

                  const SizedBox(height: 16),

                  // Treatment Options
                  Container(
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
                        ...List<String>.from(result['treatment']).map((item) {
                          return Padding(
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
                          );
                        }).toList(),
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
                  ),

                  const SizedBox(height: 16),

                  // Risk Level Indicator
                  Container(
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
                              result['riskLevel'],
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
                            value: result['riskLevel'] == 'Low'
                                ? 0.33
                                : result['riskLevel'] == 'Moderate'
                                    ? 0.66
                                    : 1.0,
                            minHeight: 12,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              result['riskLevel'] == 'Low'
                                  ? const Color(0xFF16A34A)
                                  : result['riskLevel'] == 'Moderate'
                                      ? const Color(0xFFEAB308)
                                      : const Color(0xFFDC2626),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nail Care Tips
                  Container(
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
                  ),

                  const SizedBox(height: 16),

                  // Recommendation
                  Container(
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
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
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

  Widget _buildInfoSection({
    required String title,
    required String content,
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
          const SizedBox(height: 12),
          Text(
            content,
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
          ...items.map((item) {
            return Padding(
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
            );
          }).toList(),
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

  Map<String, Color> _getRiskLevelColors(String level) {
    switch (level) {
      case 'Low':
        return {
          'background': const Color(0xFFF0FDF4),
          'border': const Color(0xFF86EFAC),
          'text': const Color(0xFF16A34A),
        };
      case 'Moderate':
        return {
          'background': const Color(0xFFFEFCE8),
          'border': const Color(0xFFFDE047),
          'text': const Color(0xFFEAB308),
        };
      case 'High':
        return {
          'background': const Color(0xFFFEF2F2),
          'border': const Color(0xFFFCA5A5),
          'text': const Color(0xFFDC2626),
        };
      default:
        return {
          'background': const Color(0xFFF9FAFB),
          'border': const Color(0xFFD1D5DB),
          'text': const Color(0xFF6B7280),
        };
    }
  }
}
```

## 8. screens/history_screen.dart

```dart
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final Function(String) onNavigate;
  final String currentScreen;

  const HistoryScreen({
    Key? key,
    required this.onNavigate,
    required this.currentScreen,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> _historyItems = [
    HistoryItem(
      id: 1,
      condition: 'Onychomycosis',
      confidence: 98.5,
      date: 'Feb 18, 2026',
      message: 'Fungal infection detected with high confidence. Consult dermatologist for treatment.',
      type: HistoryItemType.disease,
    ),
    HistoryItem(
      id: 2,
      condition: 'Acral Lentiginous Melanoma (ALM)',
      confidence: 91.2,
      date: 'Feb 15, 2026',
      message: 'Dark pigmentation patterns detected. Immediate dermatology consultation recommended.',
      type: HistoryItemType.disease,
    ),
    HistoryItem(
      id: 3,
      condition: 'Healthy Nail',
      confidence: 97.8,
      date: 'Feb 12, 2026',
      message: 'No abnormalities detected. Nail appears healthy.',
      type: HistoryItemType.healthy,
    ),
    HistoryItem(
      id: 4,
      condition: 'Nail Clubbing',
      confidence: 87.3,
      date: 'Feb 10, 2026',
      message: 'Nail shape changes detected. May require medical evaluation.',
      type: HistoryItemType.disease,
    ),
    HistoryItem(
      id: 5,
      condition: 'Unidentified',
      confidence: 45.2,
      date: 'Feb 8, 2026',
      message: 'Low confidence - condition not in detection scope. Professional consultation recommended.',
      type: HistoryItemType.unidentified,
    ),
  ];

  bool _showClearConfirm = false;

  void _deleteItem(int id) {
    setState(() {
      _historyItems.removeWhere((item) => item.id == id);
    });
  }

  void _clearAll() {
    setState(() {
      _historyItems.clear();
      _showClearConfirm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                child: const SafeArea(
                  bottom: false,
                  child: Text(
                    'Scan History',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: _historyItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.history,
                                size: 40,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No History Yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Your scan history will appear here',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                        children: [
                          ..._historyItems.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildHistoryCard(item),
                              )),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showClearConfirm = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Clear All History',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),

              // Bottom Navigation
              _buildBottomNav(),
            ],
          ),
        ),

        // Confirmation Modal
        if (_showClearConfirm)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Clear All History?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showClearConfirm = false;
                            });
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.close, size: 20, color: Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This will permanently delete all ${_historyItems.length} scan${_historyItems.length != 1 ? 's' : ''} from your history. This action cannot be undone.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _showClearConfirm = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFFE5E7EB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _clearAll,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHistoryCard(HistoryItem item) {
    final cardStyle = _getCardStyle(item.type);
    final badgeStyle = _getBadgeStyle(item.type);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardStyle['gradient'],
        ),
        border: Border.all(color: cardStyle['border']!, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.condition,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.date,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeStyle['background'],
                      border: Border.all(color: badgeStyle['border']!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${item.confidence}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: badgeStyle['text'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _deleteItem(item.id),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, size: 16, color: Color(0xFFDC2626)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getCardStyle(HistoryItemType type) {
    switch (type) {
      case HistoryItemType.healthy:
        return {
          'gradient': [const Color(0xFFF0FDF4), Colors.white],
          'border': const Color(0xFFBBF7D0),
        };
      case HistoryItemType.unidentified:
        return {
          'gradient': [const Color(0xFFF9FAFB), Colors.white],
          'border': const Color(0xFFD1D5DB),
        };
      default:
        return {
          'gradient': [const Color(0xFFFEF2F2), Colors.white],
          'border': const Color(0xFFFECACA),
        };
    }
  }

  Map<String, dynamic> _getBadgeStyle(HistoryItemType type) {
    switch (type) {
      case HistoryItemType.healthy:
        return {
          'background': const Color(0xFFDCFCE7),
          'border': const Color(0xFFBBF7D0),
          'text': const Color(0xFF16A34A),
        };
      case HistoryItemType.unidentified:
        return {
          'background': const Color(0xFFF3F4F6),
          'border': const Color(0xFFE5E7EB),
          'text': const Color(0xFF6B7280),
        };
      default:
        return {
          'background': const Color(0xFFFEE2E2),
          'border': const Color(0xFFFECACA),
          'text': const Color(0xFFDC2626),
        };
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildNavButton(
              icon: Icons.home,
              label: 'Diagnose',
              isActive: widget.currentScreen == 'home',
              onTap: () => widget.onNavigate('home'),
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              icon: Icons.history,
              label: 'History',
              isActive: widget.currentScreen == 'history',
              onTap: () => widget.onNavigate('history'),
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              icon: Icons.info,
              label: 'About',
              isActive: widget.currentScreen == 'about',
              onTap: () => widget.onNavigate('about'),
            ),
          ],
        ),
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

// Models
enum HistoryItemType { disease, healthy, unidentified }

class HistoryItem {
  final int id;
  final String condition;
  final double confidence;
  final String date;
  final String message;
  final HistoryItemType type;

  HistoryItem({
    required this.id,
    required this.condition,
    required this.confidence,
    required this.date,
    required this.message,
    required this.type,
  });
}
```

## 9. screens/about_screen.dart

```dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final Function(String) onNavigate;
  final String currentScreen;

  const AboutScreen({
    Key? key,
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
            child: const SafeArea(
              bottom: false,
              child: Text(
                'About',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
              children: [
                // App Logo and Info
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
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
                    const SizedBox(height: 16),
                    const Text(
                      'NailScan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // What is NailScan?
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFDDEAFE)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What is NailScan?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'NailScan is a mobile application designed to assist in identifying visible nail conditions using image analysis. It aims to provide quick preliminary screening based on nail appearance patterns.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Conditions Detected
                Container(
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
                        'Conditions Detected',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildConditionItem('Onychomycosis', const Color(0xFF2563EB)),
                      _buildConditionItem('Acral Lentiginous Melanoma (ALM)', const Color(0xFF2563EB)),
                      _buildConditionItem('Nail Clubbing', const Color(0xFF2563EB)),
                      _buildConditionItem('Healthy Nail', const Color(0xFF16A34A)),
                      _buildConditionItem('Unidentified', const Color(0xFF9CA3AF)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // How It Works
                Container(
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
                        'How It Works',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'The user captures or uploads a nail image. The system analyzes visible patterns such as color, shape, and texture to estimate the most likely condition.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStepItem(1, 'Capture or upload a clear photo of your fingernail'),
                      const SizedBox(height: 12),
                      _buildStepItem(2, 'AI analyzes color, shape, and texture patterns'),
                      const SizedBox(height: 12),
                      _buildStepItem(3, 'Receive instant results with confidence scores'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Disclaimer
                Container(
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
                              'Important Notice',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'This application is intended for preliminary screening only and does not replace professional medical diagnosis. Always consult a qualified healthcare professional for proper medical advice and treatment.',
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
                ),
              ],
            ),
          ),

          // Bottom Navigation
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildConditionItem(String text, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int step, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$step',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SafeArea(
        top: false,
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

## 10. Next Steps & Implementation Guide

### Setting Up Your Flutter Project

1. **Create a new Flutter project:**
   ```bash
   flutter create nailscan
   cd nailscan
   ```

2. **Update `pubspec.yaml`** with the dependencies listed above

3. **Add the Inter font:**
   - Download Inter font from Google Fonts
   - Create a `fonts/` directory in your project root
   - Add font files and update `pubspec.yaml`

4. **Add logo image:**
   - Place your logo at `assets/images/logo.png`

5. **Copy the Dart files** from this guide into the appropriate directories

6. **Run the app:**
   ```bash
   flutter pub get
   flutter run
   ```

### Key Conversion Notes

| React/Web | Flutter Equivalent |
|-----------|-------------------|
| `div` | `Container`, `Column`, `Row` |
| `className` | `decoration: BoxDecoration()` |
| `useState` | `StatefulWidget` with `setState()` |
| `useEffect` | `initState()`, `didUpdateWidget()` |
| `onClick` | `onTap`, `onPressed` |
| CSS gradients | `LinearGradient`, `RadialGradient` |
| `img src` | `Image.asset()`, `Image.file()` |
| React Router | `Navigator.push/pop()` or custom state |
| `flex` layout | `Flex`, `Expanded`, `Flexible` |
| Media queries | `MediaQuery.of(context)` |

### API Integration

For AI model integration, you can use:
- **TensorFlow Lite** for on-device inference
- **REST API** calls using `dio` or `http` packages
- **Google ML Kit** for vision tasks
- **Firebase ML** for cloud-based models

### Testing on Real Devices

```bash
# Android
flutter run -d <device-id>

# iOS (requires Mac + Xcode)
flutter run -d <ios-device-id>
```

### Building Release APK

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Mac + Xcode)
flutter build ios --release
```

This completes the full Flutter conversion! You now have all the components needed to build the NailScan app natively for Android and iOS.
