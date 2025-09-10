class PurchaseInvoice {
  final int? id;
  final int supplierId;
  final int pharmacyId;
  final String date;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;

  PurchaseInvoice({
    this.id,
    required this.supplierId,
    required this.pharmacyId,
    required this.date,
    required this.totalAmount,
    this.paidAmount = 0,
    this.remainingAmount = 0,
  });

  factory PurchaseInvoice.fromMap(Map<String, dynamic> map) => PurchaseInvoice(
    id: map['id'] as int?,
    supplierId: map['supplier_id'],
    pharmacyId: map['pharmacy_id'],
    date: map['date'],
    totalAmount: map['total_amount'],
    paidAmount: map['paid_amount'],
    remainingAmount: map['remaining_amount'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'supplier_id': supplierId,
    'pharmacy_id': pharmacyId,
    'date': date,
    'total_amount': totalAmount,
    'paid_amount': paidAmount,
    'remaining_amount': remainingAmount,
  };
}
