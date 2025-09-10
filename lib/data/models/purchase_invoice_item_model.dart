class PurchaseInvoiceItem {
  final int? id;
  final int purchaseInvoiceId;
  final int productId;
  final int quantity;
  final double unitCost;

  PurchaseInvoiceItem({
    this.id,
    required this.purchaseInvoiceId,
    required this.productId,
    required this.quantity,
    required this.unitCost,
  });

  factory PurchaseInvoiceItem.fromMap(Map<String, dynamic> map) =>
      PurchaseInvoiceItem(
        id: map['id'] as int?,
        purchaseInvoiceId: map['purchase_invoice_id'],
        productId: map['product_id'],
        quantity: map['quantity'],
        unitCost: map['unit_cost'],
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'purchase_invoice_id': purchaseInvoiceId,
    'product_id': productId,
    'quantity': quantity,
    'unit_cost': unitCost,
  };
}
