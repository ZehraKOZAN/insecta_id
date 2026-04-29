// lib/models/insect_species.dart
class InsectSpecies {
  final String id;
  final String scientificName;
  final String turkishName;
  final String englishName;
  final String order;
  final String family;
  final String category;
  final String physicalDescription;
  final List<String> distinguishingFeatures;
  final String reproduction;
  final String biologicalNotes;
  final String imagePath;

  const InsectSpecies({
    required this.id,
    required this.scientificName,
    required this.turkishName,
    required this.englishName,
    required this.order,
    required this.family,
    required this.category,
    required this.physicalDescription,
    required this.distinguishingFeatures,
    required this.reproduction,
    required this.biologicalNotes,
    required this.imagePath,
  });
}