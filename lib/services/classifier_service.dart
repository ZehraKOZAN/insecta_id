// lib/services/classifier_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../data/insect_data.dart';
import 'dart:math';

class ClassificationResult {
  final String speciesId;
  final double confidence;
  final Map<String, double> allScores;

  ClassificationResult({
    required this.speciesId,
    required this.confidence,
    required this.allScores,
  });
}

class ClassifierService {
  static const String modelPath = 'assets/model/insect_classifier_float32.tflite';
  static const int inputSize = 224;

  Interpreter? _interpreter;
  bool _isLoaded = false;

  Future<void> loadModel() async {
    if (_isLoaded) return;
    try {
      final options = InterpreterOptions()..threads = 4;
      _interpreter = await Interpreter.fromAsset(
        modelPath,
        options: options,
      );
      _isLoaded = true;
      debugPrint('✅ Model yüklendi');
    } catch (e) {
      debugPrint('❌ Model yükleme hatası: $e');
      rethrow;
    }
  }

  Future<ClassificationResult?> classify(File imageFile) async {
    if (!_isLoaded || _interpreter == null) {
      await loadModel();
    }

    try {
      // Görseli yükle ve yeniden boyutlandır
      final bytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      if (originalImage == null) return null;

      final resized = img.copyResize(
        originalImage,
        width: inputSize,
        height: inputSize,
      );

      // Float32 input tensor oluştur [1, 224, 224, 3]
      final input = List.generate(
        1,
        (_) => List.generate(
          inputSize,
          (y) => List.generate(
            inputSize,
            (x) {
              final pixel = resized.getPixel(x, y);
              return [
                (pixel.r / 255.0 - 0.485) / 0.229,
                (pixel.g / 255.0 - 0.456) / 0.224,
                (pixel.b / 255.0 - 0.406) / 0.225,
              ];
            },
          ),
        ),
      );

      // Output tensor [1, 4]
      final output = List.generate(1, (_) => List.filled(4, 0.0));

      _interpreter!.run(input, output);

      final scores = output[0];

      // Softmax uygula
      final softmaxScores = _softmax(scores);

      // En yüksek skoru bul
      int maxIdx = 0;
      for (int i = 1; i < softmaxScores.length; i++) {
        if (softmaxScores[i] > softmaxScores[maxIdx]) maxIdx = i;
      }

      final Map<String, double> allScores = {};
      for (int i = 0; i < InsectData.labelOrder.length; i++) {
        allScores[InsectData.labelOrder[i]] = softmaxScores[i];
      }

      return ClassificationResult(
        speciesId: InsectData.labelOrder[maxIdx],
        confidence: softmaxScores[maxIdx],
        allScores: allScores,
      );
    } catch (e) {
      debugPrint('❌ Sınıflandırma hatası: $e');
      return null;
    }
  }

 List<double> _softmax(List<double> scores) {
   final maxScore = scores.reduce(max);
   final expScores = scores.map((s) => exp(s - maxScore)).toList();
   final sumExp = expScores.reduce((a, b) => a + b);
   return expScores.map((e) => e / sumExp).toList();
 }





  void dispose() {
    _interpreter?.close();
    _isLoaded = false;
  }
}