class Customer {
  final int? id;
  final String name;
  final String? phone;
  final String? address;
  final String? email;

  Customer({
    this.id,
    required this.name,
    this.phone,
    this.address,
    this.email,
  });

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
