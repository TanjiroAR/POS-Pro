class InvoiceItem {
  final int? id;
  final int? invoiceId;
  final int productId;
  late final int quantity;
  final double price;

  InvoiceItem({
    this.id,
    this.invoiceId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory InvoiceItem.fromMap(Map<String, dynamic> map) => InvoiceItem(
    id: map['id'] as int?,
    invoiceId: map['invoice_id'],
    productId: map['product_id'],
    quantity: map['quantity'],
    price: map['price'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'invoice_id': invoiceId,
    'product_id': productId,
    'quantity': quantity,
    'price': price,
  };
}
