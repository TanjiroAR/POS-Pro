import '../datasources/local/app_database.dart';

class PosRepository {
  final db = AppDatabase();

  Future<int> insertInvoice(Map<String, dynamic> invoice) async {
    final database = await db.database;
    return await database.insert('invoices', invoice);
  }

  Future<void> insertInvoiceItem(Map<String, dynamic> item) async {
    final database = await db.database;
    await database.insert('invoice_items', item);
  }

  Future<void> updateProductStock(int productId, int newStock) async {
    final database = await db.database;
    await database.update(
      'products',
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> insertPayment(Map<String, dynamic> payment) async {
    final database = await db.database;
    await database.insert('payments', payment);
  }

  Future<int> getProductStock(int productId) async {
    final database = await db.database;
    final result = await database.query('products', columns: ['stock'], where: 'id=?', whereArgs: [productId]);
    return result.first['stock'] as int;
  }
}
