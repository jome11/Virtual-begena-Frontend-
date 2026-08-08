class Product {
  final String id;
  final String name;
  final String description;
  final double price; // in ETB
  final String imagePath;
  final String category; // 'begena' | 'kende' | 'strings'

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}
