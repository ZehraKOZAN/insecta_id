// lib/data/insect_data.dart
import '../models/insect_species.dart';

class InsectData {
  // Model çıktı sırası: SGranarius=0, SOryzae=1, TCastaneum=2, TConfusum=3
  static const List<String> labelOrder = [
    'SGranarius',
    'SOryzae',
    'TCastaneum',
    'TConfusum',
  ];

  static const List<InsectSpecies> species = [
    InsectSpecies(
      id: 'SGranarius',
      scientificName: 'Sitophilus granarius',
      turkishName: 'Buğday Biti',
      englishName: 'Granary Weevil',
      order: 'COLEOPTERA',
      family: 'CURCULIONIDAE',
      category: 'Depolanmış Tahıl Zararlısı',
      physicalDescription:
          'Ergin (yetişkin) böcek koyu kahverengi, parlak ve yaklaşık 3–5 mm boyundadır. Hortumlu bir yapısı vardır. Yumurtaları beyazdır. Larvaları krem renkli ve bacaksızdır. Pupa dönemi sarımsı beyazdır.',
      distinguishingFeatures: [
        'Pronotum ve elitraların üzerleri noktalıdır (eliptik çukurlar)',
        'Elytra üzerinde açık renkli leke bulunmaz',
        'Erginler uçamaz',
      ],
      reproduction:
          'Yumurta sayısı 150-300 arasında değişir. Elverişli koşullarda gelişme süresi 30-45 gündür. Ülkemiz koşullarında yılda 3-4 döl verir.',
      biologicalNotes:
          'Dişi böcek yumurtalarını buğday tanesinin içine hortumuyla açtığı küçük deliklere bırakır ve ağzından salgıladığı madde ile kapatır. Larva tane içinde beslenerek gelişir. Zarar tane içinde gizli şekilde olur.',
      imagePath: 'assets/images/s_granarius.png',
    ),
    InsectSpecies(
      id: 'SOryzae',
      scientificName: 'Sitophilus oryzae',
      turkishName: 'Pirinç Biti',
      englishName: 'Rice Weevil',
      order: 'COLEOPTERA',
      family: 'CURCULIONIDAE',
      category: 'Depolanmış Tahıl Zararlısı',
      physicalDescription:
          'Erginin rengi kırmızımsı esmer ile kahverengi arasında değişir ve boyu 2.5–4 mm\'dir. Baş kısmında uzun bir hortum bulunur. Pronotum ve kanatlar üzerinde çukurcuklar vardır. Yumurtaları beyazdır.',
      distinguishingFeatures: [
        'Elytra üzerinde 4 adet sarımsı-kırmızı leke bulunur',
        'Pronotum üzerindeki çukurlar yuvarlak şekillidir',
        'Erginler uçabilir',
      ],
      reproduction:
          'Erginler yaklaşık 6–8 ay yaşar, bu sürede 120–280 yumurta bırakabilir. Yılda 5–6 döl verir.',
      biologicalNotes:
          'Dişi böcek yumurtalarını buğday tanesinin içine hortumuyla açtığı küçük deliklere bırakır ve ağzından salgıladığı madde ile kapatır. Larva tane içinde beslenerek gelişir. Zarar tane içinde gizli şekilde olur.',
      imagePath: 'assets/images/s_oryzae.png',
    ),
    InsectSpecies(
      id: 'TCastaneum',
      scientificName: 'Tribolium castaneum',
      turkishName: 'Un Biti',
      englishName: 'Flour Beetle',
      order: 'COLEOPTERA',
      family: 'TENEBRIONIDAE',
      category: 'Depolanmış Tahıl Zararlısı',
      physicalDescription:
          'Ergin parlak koyu kırmızı renkli, 3.5–4.0 mm boyda, yassı şekilde olup baş ve göğüs sık noktalıdır. Kın kanatların üzeri boyuna ince çizgilidir.',
      distinguishingFeatures: [
        'Bileşik gözün önündeki şakak çıkıntısı göz seviyesini AŞMAZ',
        'Antenlerin son 3 halkası diğerlerinden belirgin şekilde daha geniştir (topuz oluşturur)',
        'Gözler arasında belirgin boşluk yoktur',
      ],
      reproduction:
          'Yumurtası beyaz renklidir. Ergin dişi 300–400 arası yumurta bırakır. Normal koşullarda gelişme süresi 45–60 gündür. Yılda 3–4 döl verir.',
      biologicalNotes:
          'Gıda ortamına bırakılan yumurtalar, kabuklarındaki yapışkan maddeden dolayı gıda ile örtülüdür. Sekonder zararlı olup kırık ve toz haline gelmiş tahıllarda daha fazla zarar yapar.',
      imagePath: 'assets/images/t_castaneum.png',
    ),
    InsectSpecies(
      id: 'TConfusum',
      scientificName: 'Tribolium confusum',
      turkishName: 'Kırma Biti',
      englishName: 'Confused Flour Beetle',
      order: 'COLEOPTERA',
      family: 'TENEBRIONIDAE',
      category: 'Depolanmış Tahıl Zararlısı',
      physicalDescription:
          'Ergin parlak koyu kırmızı renkli, 3.5–4.0 mm boyda, yassı şekilde olup baş ve göğüs sık noktalıdır. Kın kanatların üzeri boyuna ince çizgilidir.',
      distinguishingFeatures: [
        'Bileşik gözün önündeki şakak çıkıntısı göz hizasını GEÇER',
        'Anten segmentleri kaideden uca doğru kademeli olarak büyür (topuz oluşturmaz)',
        'Gözler arasında göz genişliğinin 1/3\'ü kadar boşluk bulunur',
      ],
      reproduction:
          'Yumurtası beyaz renklidir. Ergin dişi 300–400 arası yumurta bırakır. Normal koşullarda gelişme süresi 45–60 gündür. Yılda 3–4 döl verir.',
      biologicalNotes:
          'Gıda ortamına bırakılan yumurtalar, kabuklarındaki yapışkan maddeden dolayı gıda ile örtülüdür. T. castaneum\'a çok benzer; ayrımda anten yapısı ve göz morfolojisi kullanılır.',
      imagePath: 'assets/images/t_confusum.png',
    ),
  ];

  static InsectSpecies? getById(String id) {
    try {
      return species.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}