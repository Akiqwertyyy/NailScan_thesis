import 'package:flutter/material.dart';
import 'diagnosis_result.dart';

enum HistoryItemType { disease, healthy, unidentified }

class HistoryItem {
  final int id;
  final String condition;
  final double confidence;
  final String date;
  final String message;
  final HistoryItemType type;

  /// Optional: path to the scanned image thumbnail
  final String? imagePath;

  /// Full diagnosis result for detail view
  final DiagnosisResult? diagnosisResult;

  const HistoryItem({
    required this.id,
    required this.condition,
    required this.confidence,
    required this.date,
    required this.message,
    required this.type,
    this.imagePath,
    this.diagnosisResult,
  });

  Map<String, dynamic> getCardStyle() {
    switch (type) {
      case HistoryItemType.healthy:
        return {
          'gradient': [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
          'border': const Color(0xFF86EFAC),
        };
      case HistoryItemType.unidentified:
        return {
          'gradient': [const Color(0xFFFAFAFA), const Color(0xFFF3F4F6)],
          'border': const Color(0xFFD1D5DB),
        };
      case HistoryItemType.disease:
      default:
        return {
          'gradient': [const Color(0xFFFFF1F2), const Color(0xFFFFE4E6)],
          'border': const Color(0xFFFCA5A5),
        };
    }
  }

  Map<String, Color> getBadgeStyle() {
    switch (type) {
      case HistoryItemType.healthy:
        return {
          'background': const Color(0xFFDCFCE7),
          'border': const Color(0xFF86EFAC),
          'text': const Color(0xFF16A34A),
        };
      case HistoryItemType.unidentified:
        return {
          'background': const Color(0xFFF3F4F6),
          'border': const Color(0xFFD1D5DB),
          'text': const Color(0xFF6B7280),
        };
      case HistoryItemType.disease:
      default:
        return {
          'background': const Color(0xFFFFE4E6),
          'border': const Color(0xFFFCA5A5),
          'text': const Color(0xFFDC2626),
        };
    }
  }
}
