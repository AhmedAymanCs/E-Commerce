class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String availabilityStatus;
  final List<String> images;
  final double price;
  final double discountPercentage;
  final int stock;

  ProductModel({
    required this.id,
    required this.title,
    required this.images,
    required this.price,
    required this.description,
    required this.category,
    required this.availabilityStatus,
    required this.discountPercentage,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'images': images,
      'price': price,
      'description': description,
      'category': category,
      'availabilityStatus': availabilityStatus,
      'discountPercentage': discountPercentage,
      'stock': stock,
    };
  }
}
