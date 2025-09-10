class Invoice {
  final int? id;
  final int customerId;
  final int userId;
  final int pharmacyId;
  final String date;
  final double total;

  Invoice({
    this.id,
    required this.customerId,
    required this.userId,
    required this.pharmacyId,
    required this.date,
    required this.total,
  });

  factory Invoice.fromMap(Map<String, dynamic> map) => Invoice(
    id: map['id'] as int?,
    customerId: map['customer_id'],
    userId: map['user_id'],
    pharmacyId: map['pharmacy_id'],
    date: map['date'],
    total: map['total'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'customer_id': customerId,
    'user_id': userId,
    'pharmacy_id': pharmacyId,
    'date': date,
    'total': total,
  };
}
