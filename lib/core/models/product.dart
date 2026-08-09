class Product {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final double price; // in ETB
  final String imagePath;
  final String category; // 'begena' | 'horn' | 'strings'

  const Product({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}
