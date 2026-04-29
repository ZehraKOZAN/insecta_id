// lib/screens/result_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/insect_species.dart';
import '../services/classifier_service.dart';
import '../data/insect_data.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final ClassificationResult classificationResult;
  final InsectSpecies species;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.classificationResult,
    required this.species,
  });

  // Tasarım Renkleri
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color bgColor = Color(0xFFFDF8F1);
  static const Color accentGold = Color(0xFFD4A373);

  @override
  Widget build(BuildContext context) {
    final confidence = (classificationResult.confidence * 100).toStringAsFixed(0);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // Üstteki Resim Alanı
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: primaryDark,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black38,
                child: Icon(Icons.close, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(imagePath), fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // BURADAKİ const KALDIRILDI (Hata kaynağı buydu)
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6A4F),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10)
                        ],
                      ),
                      child: Text(
                        '✓ %$confidence EŞLEŞME',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Tür İsimleri
                Text(
                  species.scientificName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: primaryDark,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  species.turkishName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 40),

                // Saat İkonuyla Birlikte "Analiz Sonuçları" Başlığı
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryDark.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.access_time_filled_rounded,
                        color: accentGold,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Analiz Sonuçları',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif',
                        color: primaryDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Yapay zeka tahmin verileri ve olasılıklar',
                  style: TextStyle(color: Colors.black45, fontSize: 14),
                ),

                const SizedBox(height: 20),

                // Skor Kartı
                _buildConfidenceCard(),

                const SizedBox(height: 24),

                // Bilgi Bölümleri
                _buildInfoSection('🧍 Fiziksel Tanım', species.physicalDescription),
                const SizedBox(height: 16),
                _buildFeaturesSection(species.distinguishingFeatures),
                const SizedBox(height: 16),
                _buildInfoSection('🔬 Üreme', species.reproduction),
                const SizedBox(height: 16),
                _buildInfoSection('🧪 Biyolojik Notlar', species.biologicalNotes),
                const SizedBox(height: 50),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: InsectData.species.map((sp) {
          final score = classificationResult.allScores[sp.id] ?? 0.0;
          final isSelected = sp.id == classificationResult.speciesId;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sp.turkishName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? primaryDark : Colors.black45,
                      ),
                    ),
                    Text(
                      '%${(score * 100).toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? primaryDark : Colors.black45,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: score,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFF0F4F2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isSelected ? primaryDark : Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryDark)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(List<String> features) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔍 Ayırt Edici Özellikler', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryDark)),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 6, color: accentGold),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(f, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4))),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}