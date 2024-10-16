/// Product model has id, name, price, stock and optional description
class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String? description;

  Product({
    String? id,
    required this.name,
    required this.price,
    required this.stock,
    this.description,
  }) : id = id ?? 'P-${_counter++}';

  static var _counter = 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      description: json['description'],
    );
  }
}
