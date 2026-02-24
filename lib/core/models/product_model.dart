class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String availabilityStatus;
  final List<String> images;
  final double price;
  final int stock;
  final bool isFavorite;
  int quantity;

  ProductModel({
    required this.id,
    required this.title,
    required this.images,
    required this.price,
    required this.description,
    required this.category,
    required this.availabilityStatus,
    required this.stock,
    this.isFavorite = false,
    this.quantity = 1,
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
      stock: json['stock'] ?? 0,
      quantity: json['quantity'] ?? 1,
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
      'stock': stock,
      'quantity': quantity,
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    String? description,
    String? category,
    String? availabilityStatus,
    List<String>? images,
    double? price,
    double? discountPercentage,
    int? stock,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      images: images ?? this.images,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
