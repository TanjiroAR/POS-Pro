class Payment {
  final int? id;
  final String kind; // 'customer' أو 'supplier'
  final int refId; // customer_id أو supplier_id حسب النوع
  final int? pharmacyId;
  final String date;
  final double amount;
  final String? notes;

  Payment({
    this.id,
    required this.kind,
    required this.refId,
    this.pharmacyId,
    required this.date,
    required this.amount,
    this.notes,
  });

  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
    id: map['id'] as int?,
    kind: map['kind'],
    refId: map['ref_id'],
    pharmacyId: map['pharmacy_id'],
    date: map['date'],
    amount: map['amount'],
    notes: map['notes'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'kind': kind,
    'ref_id': refId,
    'pharmacy_id': pharmacyId,
    'date': date,
    'amount': amount,
    'notes': notes,
  };
}
