//  Shop_data.dart file in model folder

class Shop {
  final String id;
  final String name;
  final String category;
  final String discount;

  Shop({
    required this.id,
    required this.name,
    required this.category,
    required this.discount,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      discount: map['discount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'category': category, 'discount': discount};
  }
}
