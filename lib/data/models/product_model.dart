class Product {
  final int? id;
  final String barcode;
  final String name;
  final String genericName;
  final String category;
  final double boxPrice;
  final double stripPrice;
  final int stripsInBox;
  final int stock;
  final DateTime? productionDate;
  final DateTime? expiryDate;
  final double discount;
  final String supplierName;

  Product({
    this.id,
    required this.barcode,
    required this.name,
    required this.genericName,
    required this.category,
    required this.boxPrice,
    required this.stripPrice,
    required this.stripsInBox,
    required this.stock,
    this.productionDate,
    this.expiryDate,
    this.discount = 0.0,
    required this.supplierName,
  });

  Product copyWith({
    int? id,
    String? barcode,
    String? name,
    String? genericName,
    String? category,
    double? boxPrice,
    double? stripPrice,
    int? stripsInBox,
    int? stock,
    DateTime? productionDate,
    DateTime? expiryDate,
    double? discount,
    String? supplierName,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      category: category ?? this.category,
      boxPrice: boxPrice ?? this.boxPrice,
      stripPrice: stripPrice ?? this.stripPrice,
      stripsInBox: stripsInBox ?? this.stripsInBox,
      stock: stock ?? this.stock,
      productionDate: productionDate ?? this.productionDate,
      expiryDate: expiryDate ?? this.expiryDate,
      discount: discount ?? this.discount,
      supplierName: supplierName ?? this.supplierName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'genericName': genericName,
      'category': category,
      'boxPrice': boxPrice,
      'stripPrice': stripPrice,
      'stripsInBox': stripsInBox,
      'stock': stock,
      'productionDate': productionDate?.millisecondsSinceEpoch,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'discount': discount,
      'supplierName': supplierName,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      barcode: map['barcode'],
      name: map['name'],
      genericName: map['genericName'],
      category: map['category'],
      boxPrice: map['boxPrice'],
      stripPrice: map['stripPrice'],
      stripsInBox: map['stripsInBox'],
      stock: map['stock'],
      productionDate: map['productionDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['productionDate'])
          : null,
      expiryDate: map['expiryDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiryDate'])
          : null,
      discount: map['discount'] ?? 0.0,
      supplierName: map['supplierName'],
    );
  }
}
