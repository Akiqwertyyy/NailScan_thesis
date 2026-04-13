import 'package:flutter/material.dart';

/// Enum for risk levels
enum RiskLevel {
  low,
  moderate,
  high,
}

/// Model class for diagnosis results
class DiagnosisResult {
  final String condition;
  final double confidence;
  final RiskLevel riskLevel;
  final String shape;
  final String color;
  final String texture;
  final String description;
  final List<String> underlyingCauses;
  final List<String> symptoms;
  final List<String> treatment;

  DiagnosisResult({
    required this.condition,
    required this.confidence,
    required this.riskLevel,
    required this.shape,
    required this.color,
    required this.texture,
    required this.description,
    required this.underlyingCauses,
    required this.symptoms,
    required this.treatment,
  });

  /// Get card colors based on condition
  Map<String, dynamic> getCardColors() {
    if (condition == 'Healthy Nail') {
      return {
        'cardGradient': [const Color(0xFFF0FDF4), Colors.white],
        'borderColor': const Color(0xFFBBF7D0),
        'badgeGradient': [const Color(0xFFDCFCE7), const Color(0xFFF0FDF4)],
        'badgeBorderColor': const Color(0xFFBBF7D0),
        'badgeTextColor': const Color(0xFF16A34A),
      };
    } else if (condition == 'Unidentified') {
      return {
        'cardGradient': [const Color(0xFFF9FAFB), Colors.white],
        'borderColor': const Color(0xFFD1D5DB),
        'badgeGradient': [const Color(0xFFF3F4F6), const Color(0xFFF9FAFB)],
        'badgeBorderColor': const Color(0xFFE5E7EB),
        'badgeTextColor': const Color(0xFF6B7280),
      };
    } else if (condition == 'Nail Clubbing') {
      return {
        'cardGradient': [const Color(0xFFFFFBEB), Colors.white],
        'borderColor': const Color(0xFFFED7AA),
        'badgeGradient': [const Color(0xFFFED7AA), const Color(0xFFFFFBEB)],
        'badgeBorderColor': const Color(0xFFFED7AA),
        'badgeTextColor': const Color(0xFFEA580C),
      };
    } else {
      // Disease conditions (Onychomycosis, ALM)
      return {
        'cardGradient': [const Color(0xFFFEF2F2), Colors.white],
        'borderColor': const Color(0xFFFECACA),
        'badgeGradient': [const Color(0xFFFEE2E2), const Color(0xFFFEF2F2)],
        'badgeBorderColor': const Color(0xFFFECACA),
        'badgeTextColor': const Color(0xFFDC2626),
      };
    }
  }

  /// Get risk level colors
  Map<String, Color> getRiskLevelColors() {
    switch (riskLevel) {
      case RiskLevel.low:
        return {
          'background': const Color(0xFFF0FDF4),
          'border': const Color(0xFF86EFAC),
          'text': const Color(0xFF16A34A),
          'color': const Color(0xFF16A34A),
        };
      case RiskLevel.moderate:
        return {
          'background': const Color(0xFFFEFCE8),
          'border': const Color(0xFFFDE047),
          'text': const Color(0xFFEAB308),
          'color': const Color(0xFFEAB308),
        };
      case RiskLevel.high:
        return {
          'background': const Color(0xFFFEF2F2),
          'border': const Color(0xFFFCA5A5),
          'text': const Color(0xFFDC2626),
          'color': const Color(0xFFDC2626),
        };
    }
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'confidence': confidence,
      'riskLevel': riskLevel.toString(),
      'shape': shape,
      'color': color,
      'texture': texture,
      'description': description,
      'underlyingCauses': underlyingCauses,
      'symptoms': symptoms,
      'treatment': treatment,
    };
  }

  /// Create from JSON
  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      condition: json['condition'],
      confidence: json['confidence'],
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.toString() == json['riskLevel'],
        orElse: () => RiskLevel.low,
      ),
      shape: json['shape'],
      color: json['color'],
      texture: json['texture'],
      description: json['description'],
      underlyingCauses: List<String>.from(json['underlyingCauses']),
      symptoms: List<String>.from(json['symptoms']),
      treatment: List<String>.from(json['treatment']),
    );
  }
}
