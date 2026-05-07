class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String? logoUrl;
  final double? rating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.logoUrl,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id']),
      name: json['name'] ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      description: json['description'] ?? '',
      logoUrl: json['logo_url'],
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
    );
  }
}

class MenuCategory {
  final int id;
  final String name;
  final String description;
  final List<Product> products;

  MenuCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.products,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      products: json['products'] != null
          ? (json['products'] as List).map((p) => Product.fromJson(p)).toList()
          : [],
    );
  }
}
