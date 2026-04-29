// lib/screens/home_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/classifier_service.dart';
import '../services/history_service.dart';
import '../models/analysis_result.dart';
import '../data/insect_data.dart';
import 'result_screen.dart';
import 'library_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ClassifierService _classifier = ClassifierService();
  final HistoryService _historyService = HistoryService();
  final ImagePicker _picker = ImagePicker();
  int _currentIndex = 0;
  bool _isLoading = false;

  static const Color primaryDark = Color(0xFF1B4332);
  static const Color accentGreen = Color(0xFF2D6A4F);
  static const Color bgColor = Color(0xFFFDF8F1);
  static const Color accentGold = Color(0xFFD4A373);

  @override
  void initState() {
    super.initState();
    _classifier.loadModel();
  }

  @override
  void dispose() {
    _classifier.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) return;
    }

    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 90,
      );
      if (file == null) return;

      setState(() => _isLoading = true);
      final result = await _classifier.classify(File(file.path));

      if (result != null) {
        final species = InsectData.getById(result.speciesId);
        if (species != null) {
          await _historyService.saveResult(AnalysisResult(
            speciesId: result.speciesId,
            scientificName: species.scientificName,
            turkishName: species.turkishName,
            confidence: result.confidence,
            timestamp: DateTime.now(),
            imagePath: file.path,
          ));

          if (mounted) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultScreen(
                  imagePath: file.path,
                  classificationResult: result,
                  species: species,
                ),
              ),
            );
            setState(() {});
          }
        }
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          const LibraryScreen(),
          const HistoryScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Column(
          children: [
            // ÜST BÖLÜM: Hero Alanı
            Expanded(
              flex: 48,
              child: _buildHeroSection(),
            ),

            // ALT BÖLÜM: İşlem Kartları (Başlık silindi)
            Expanded(
              flex: 52,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Column(
                  children: [
                    // Fotoğraf Çek Kartı
                    Expanded(
                      child: _buildActionCard(
                        icon: Icons.camera_alt_rounded,
                        title: 'Fotoğraf Çek',
                        subtitle: 'Anında tanımlama için kamerayı kullan',
                        onTap: () => _pickImage(ImageSource.camera),
                        isPrimary: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Galeriden Yükle Kartı
                    Expanded(
                      child: _buildActionCard(
                        icon: Icons.photo_library_rounded,
                        title: 'Galeriden Yükle',
                        subtitle: 'Analiz için mevcut bir fotoğraf seç',
                        onTap: () => _pickImage(ImageSource.gallery),
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Alt İkili Kartlar
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _buildSmallCard('Kütüphane', Icons.menu_book_rounded, 1)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildSmallCard('Geçmiş', Icons.access_time_filled_rounded, 2)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryDark, accentGreen],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  height: 95,
                  width: 95,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Transform.scale(
                      scale: 1.35,
                      child: Image.asset(
                        'assets/images/icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'InsectID',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Yapay Zeka Destekli Böcek Tanımlama',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _heroStat('OFFLINE', 'MOD'),
                  _divider(),
                  _heroStat('%94', 'DOĞRULUK'),
                  _divider(),
                  _heroStat('2s', 'ORT. SÜRE'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroStat(String v, String l) => Column(
    children: [
      Text(v, style: const TextStyle(color: accentGold, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(l, style: const TextStyle(color: Colors.white54, fontSize: 10)),
    ],
  );

  Widget _divider() => Container(height: 30, width: 1, color: Colors.white12);

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isPrimary
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isPrimary ? primaryDark : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            if(!isPrimary) BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white.withOpacity(0.1) : const Color(0xFFF0F4F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isPrimary ? Colors.white : primaryDark, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: isPrimary ? Colors.white : Colors.black87, fontSize: 17, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: isPrimary ? Colors.white60 : Colors.black45, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: isPrimary ? Colors.white24 : Colors.black12, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(String title, IconData icon, int index) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryDark, size: 28),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1)),
      ),
      child: NavigationBar(
        height: 65,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_filled), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Kütüphane'),
          NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history_rounded), label: 'Geçmiş'),
        ],
      ),
    );
  }
}