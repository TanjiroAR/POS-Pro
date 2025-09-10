import 'package:sqflite/sqflite.dart';
import '../models/invoice_model.dart';
import '../models/invoice_item_model.dart';
import 'local/app_database.dart';

class InvoicesDao {
  // CRUD للفواتير
  Future<int> insertInvoice(Invoice invoice) async {
    final db = await AppDatabase().database;
    return await db.insert(
      'invoices',
      invoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateInvoice(Invoice invoice) async {
    final db = await AppDatabase().database;
    return await db.update(
      'invoices',
      invoice.toMap(),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<int> deleteInvoice(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Invoice>> getAllInvoices() async {
    final db = await AppDatabase().database;
    final result = await db.query('invoices');
    return result.map((map) => Invoice.fromMap(map)).toList();
  }

  Future<Invoice?> getInvoiceById(int id) async {
    final db = await AppDatabase().database;
    final result =
    await db.query('invoices', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return Invoice.fromMap(result.first);
    return null;
  }

  // CRUD لتفاصيل الفاتورة
  Future<int> insertInvoiceItem(InvoiceItem item) async {
    final db = await AppDatabase().database;
    return await db.insert(
      'invoice_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateInvoiceItem(InvoiceItem item) async {
    final db = await AppDatabase().database;
    return await db.update(
      'invoice_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteInvoiceItem(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      'invoice_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<InvoiceItem>> getItemsByInvoice(int invoiceId) async {
    final db = await AppDatabase().database;
    final result = await db
        .query('invoice_items', where: 'invoice_id = ?', whereArgs: [invoiceId]);
    return result.map((map) => InvoiceItem.fromMap(map)).toList();
  }
}
