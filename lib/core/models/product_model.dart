class ProductModel {
  final String id;
  final String title;
  final String image;
  final String price;
  final String description;
  final String category;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: json['price'],
      description: json['description'],
      category: json['category'],
    );
  }
}
