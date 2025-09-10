import 'package:sqflite/sqflite.dart';

class Migration2 {
  Future<void> upgrade(Database db) async {
    // جدول الموردين
    await db.execute('''
      CREATE TABLE suppliers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        address TEXT,
        email TEXT
      );
    ''');

    // فواتير الموردين
    await db.execute('''
      CREATE TABLE purchase_invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        supplier_id INTEGER NOT NULL,
        pharmacy_id INTEGER NOT NULL,
        date TEXT NOT NULL DEFAULT (datetime('now')),
        total_amount REAL NOT NULL,
        paid_amount REAL NOT NULL DEFAULT 0,
        remaining_amount REAL NOT NULL DEFAULT 0,
        FOREIGN KEY(supplier_id) REFERENCES suppliers(id) ON DELETE CASCADE,
        FOREIGN KEY(pharmacy_id) REFERENCES pharmacies(id) ON DELETE CASCADE
      );
    ''');

    // تفاصيل الفاتورة
    await db.execute('''
      CREATE TABLE purchase_invoice_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        purchase_invoice_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        unit_cost REAL NOT NULL,
        FOREIGN KEY(purchase_invoice_id) REFERENCES purchase_invoices(id) ON DELETE CASCADE,
        FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE RESTRICT
      );
    ''');
  }
}
