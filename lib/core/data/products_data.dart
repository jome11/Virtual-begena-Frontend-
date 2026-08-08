import '../models/product.dart';

const List<Product> products = [
  // Begena
  Product(
    id: 'begena-1',
    name: 'Classic Begena',
    description: 'Traditional ten-stringed begena, handcrafted with natural wood and leather.',
    price: 8500,
    imagePath: 'assets/begena/b1.jpg',
    category: 'begena',
  ),
  Product(
    id: 'begena-2',
    name: 'Carved Begena',
    description: 'Mid-tier begena with decorative carvings and reinforced frame.',
    price: 13500,
    imagePath: 'assets/begena/b2.jpg',
    category: 'begena',
  ),
  Product(
    id: 'begena-3',
    name: 'Premium Begena',
    description: 'High-end handcrafted begena, finest materials and finish.',
    price: 19800,
    imagePath: 'assets/begena/b3.jpg',
    category: 'begena',
  ),
  // Kende
  Product(
    id: 'kende-1',
    name: 'Small Kende',
    description: 'Compact traditional kende, suitable for beginners.',
    price: 950,
    imagePath: 'assets/kende/k1.jpg',
    category: 'kende',
  ),
  Product(
    id: 'kende-2',
    name: 'Standard Kende',
    description: 'Standard-size kende for regular practice and performance.',
    price: 1450,
    imagePath: 'assets/kende/k2.jpg',
    category: 'kende',
  ),
  Product(
    id: 'kende-3',
    name: 'Decorated Kende',
    description: 'Kende with traditional decorative patterning.',
    price: 1900,
    imagePath: 'assets/kende/k3.jpg',
    category: 'kende',
  ),
  Product(
    id: 'kende-4',
    name: 'Large Kende',
    description: 'Larger kende with deeper resonance.',
    price: 2600,
    imagePath: 'assets/kende/k4.jpg',
    category: 'kende',
  ),
  Product(
    id: 'kende-5',
    name: 'Master Kende',
    description: 'Top-tier kende, built for experienced players.',
    price: 3400,
    imagePath: 'assets/kende/k5.jpg',
    category: 'kende',
  ),
  // Strings
  Product(
    id: 'strings-1',
    name: 'Standard String Set',
    description: 'Full replacement string set for begena, standard gauge.',
    price: 350,
    imagePath: 'assets/Strings/S1.jpg',
    category: 'strings',
  ),
  Product(
    id: 'strings-2',
    name: 'Reinforced String Set',
    description: 'Longer-lasting reinforced strings for regular players.',
    price: 550,
    imagePath: 'assets/Strings/S2.png',
    category: 'strings',
  ),
  Product(
    id: 'strings-3',
    name: 'Premium String Set',
    description: 'Premium string set, best tonal quality.',
    price: 750,
    imagePath: 'assets/Strings/S3.png',
    category: 'strings',
  ),
  Product(
    id: 'strings-4',
    name: 'Professional String Set',
    description: 'Professional-grade strings used by advanced players.',
    price: 900,
    imagePath: 'assets/Strings/S4.jpg',
    category: 'strings',
  ),
];

const List<String> productCategories = ['begena', 'kende', 'strings'];
