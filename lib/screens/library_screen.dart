import 'package:flutter/material.dart';
import '../data/insect_data.dart';
import '../models/insect_species.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final Set<String> _expanded = {};

  // Görseldeki renk paleti
  static const Color primaryDark = Color(0xFF1B4332);
  static const Color bgColor = Color(0xFFFDF8F1);
  static const Color tagBgGreen = Color(0xFFE8F3ED);
  static const Color tagBgBrown = Color(0xFFF4EDE4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildSpeciesCard(InsectData.species[i]),
                childCount: InsectData.species.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: primaryDark,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryDark, Color(0xFF2D6A4F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.menu_book, color: Color(0xFFE9C46A), size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded( // Başlık alanının taşmasını engellemek için eklendi
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Böcek Ansiklopedisi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Bilimsel verilerle detaylı tür profilleri',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeciesCard(InsectSpecies sp) {
    final isExpanded = _expanded.contains(sp.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(12),
            onTap: () => setState(() => isExpanded ? _expanded.remove(sp.id) : _expanded.add(sp.id)),
            leading: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                sp.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Icon(Icons.bug_report, size: 30, color: Colors.grey),
              ),
            ),
            title: Text(
              sp.scientificName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: primaryDark,
              ),
              overflow: TextOverflow.ellipsis, // Uzun isimlerin taşmasını engeller
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sp.turkishName,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Overflow hatasını çözen kritik değişiklik: Row yerine Wrap kullanımı
                Wrap(
                  spacing: 6, // Yatay boşluk
                  runSpacing: 4, // Dikey boşluk (alt satıra geçerse)
                  children: [
                    _tag(sp.order.toUpperCase(), tagBgGreen, const Color(0xFF2D6A4F)),
                    _tag(sp.family.toUpperCase(), tagBgBrown, const Color(0xFF8B5E3C)),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black26,
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 20),
                  _detail('🧍 Fiziksel Özellik', sp.physicalDescription),
                  const SizedBox(height: 10),
                  _detail('🔬 Bilimsel Bilgi', sp.biologicalNotes),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _tag(String txt, Color bg, Color textCol) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
    child: Text(
      txt,
      style: TextStyle(
        color: textCol,
        fontSize: 9, // Dar ekranlar için bir tık küçültüldü
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _detail(String title, String desc) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryDark),
      ),
      const SizedBox(height: 4),
      Text(
        desc,
        style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
      ),
    ],
  );
}