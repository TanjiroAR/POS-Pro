class Supplier {
  final int? id;
  final String name;
  final String? phone;
  final String? address;
  final String? email;

  Supplier({
    this.id,
    required this.name,
    this.phone,
    this.address,
    this.email,
  });

  factory Supplier.fromMap(Map<String, dynamic> map) => Supplier(
    id: map['id'] as int?,
    name: map['name'],
    phone: map['phone'],
    address: map['address'],
    email: map['email'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address': address,
    'email': email,
  };
}
