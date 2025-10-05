class Product {
  final int id;
  final String name;
  final int price;
  final String? description;
  final String category;
  final String imgUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imgUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'img_url': imgUrl,
    };
  }

  // Factory constructor to create a Product object from a Map (e.g., from database)
  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as int,
      description: map['description'] as String?,
      category: map['category'] as String,
      imgUrl: map['img_url'] as String,
    );
  }
}
