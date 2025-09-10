import '../../data/models/invoice_item_model.dart';
import '../../data/repositories/pos_repository.dart';

class CompleteSaleUsecase {
  final PosRepository repository;

  CompleteSaleUsecase(this.repository);

  Future<void> call({
    required int customerId,
    required int userId,
    required int pharmacyId,
    required List<InvoiceItem> items,
    required double paidAmount,
  }) async {
    double total = items.fold(0, (sum, item) => sum + (item.price * item.quantity));

    final invoiceId = await repository.insertInvoice({
      'customer_id': customerId,
      'user_id': userId,
      'pharmacy_id': pharmacyId,
      'date': DateTime.now().toIso8601String(),
      'total': total,
    });

    for (var item in items) {
      await repository.insertInvoiceItem({
        'invoice_id': invoiceId,
        'product_id': item.productId,
        'quantity': item.quantity,
        'price': item.price,
      });

      final currentStock = await repository.getProductStock(item.productId);
      await repository.updateProductStock(item.productId, currentStock - item.quantity);
    }

    if (paidAmount > 0) {
      double remainingAmount = total - paidAmount;
      await repository.insertPayment({
        'kind': 'customer',
        'ref_id': invoiceId,
        'pharmacy_id': pharmacyId,
        'date': DateTime.now().toIso8601String(),
        'amount': paidAmount,
        'notes': remainingAmount > 0 ? 'جزئي' : 'كامل',
      });
    }
  }
}
