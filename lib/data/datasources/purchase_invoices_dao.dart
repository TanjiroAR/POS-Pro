import 'package:sqflite/sqflite.dart';
import '../models/purchase_invoice_model.dart';
import '../models/purchase_invoice_item_model.dart';
import 'local/app_database.dart';

class PurchaseInvoicesDao {
  // CRUD لفواتير الموردين
  Future<int> insertPurchaseInvoice(PurchaseInvoice invoice) async {
    final db = await AppDatabase().database;
    return await db.insert(
      'purchase_invoices',
      invoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePurchaseInvoice(PurchaseInvoice invoice) async {
    final db = await AppDatabase().database;
    return await db.update(
      'purchase_invoices',
      invoice.toMap(),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<int> deletePurchaseInvoice(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      'purchase_invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<PurchaseInvoice>> getAllPurchaseInvoices() async {
    final db = await AppDatabase().database;
    final result = await db.query('purchase_invoices');
    return result.map((map) => PurchaseInvoice.fromMap(map)).toList();
  }

  Future<PurchaseInvoice?> getPurchaseInvoiceById(int id) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      'purchase_invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return PurchaseInvoice.fromMap(result.first);
    return null;
  }

  // CRUD لتفاصيل فواتير الموردين
  Future<int> insertPurchaseInvoiceItem(PurchaseInvoiceItem item) async {
    final db = await AppDatabase().database;
    return await db.insert(
      'purchase_invoice_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePurchaseInvoiceItem(PurchaseInvoiceItem item) async {
    final db = await AppDatabase().database;
    return await db.update(
      'purchase_invoice_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deletePurchaseInvoiceItem(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      'purchase_invoice_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<PurchaseInvoiceItem>> getItemsByPurchaseInvoice(int invoiceId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      'purchase_invoice_items',
      where: 'purchase_invoice_id = ?',
      whereArgs: [invoiceId],
    );
    return result.map((map) => PurchaseInvoiceItem.fromMap(map)).toList();
  }
}
