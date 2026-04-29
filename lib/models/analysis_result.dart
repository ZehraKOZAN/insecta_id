// lib/models/analysis_result.dart
class AnalysisResult {
  final String speciesId;
  final String scientificName;
  final String turkishName;
  final double confidence;
  final DateTime timestamp;
  final String imagePath;

  AnalysisResult({
    required this.speciesId,
    required this.scientificName,
    required this.turkishName,
    required this.confidence,
    required this.timestamp,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'speciesId': speciesId,
    'scientificName': scientificName,
    'turkishName': turkishName,
    'confidence': confidence,
    'timestamp': timestamp.toIso8601String(),
    'imagePath': imagePath,
  };

  factory AnalysisResult.fromJson(Map<String, dynamic> json) => AnalysisResult(
    speciesId: json['speciesId'],
    scientificName: json['scientificName'],
    turkishName: json['turkishName'],
    confidence: json['confidence'],
    timestamp: DateTime.parse(json['timestamp']),
    imagePath: json['imagePath'],
  );
}