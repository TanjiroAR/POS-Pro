import 'package:sqflite/sqflite.dart';

class Migration3 {
  Future<void> upgrade(Database db) async {
    // جدول المدفوعات للعملاء والموردين
    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kind TEXT NOT NULL CHECK(kind IN ('customer','supplier')),
        ref_id INTEGER NOT NULL, -- customer_id أو supplier_id حسب النوع
        pharmacy_id INTEGER,
        date TEXT NOT NULL DEFAULT (datetime('now')),
        amount REAL NOT NULL,
        notes TEXT,
        FOREIGN KEY(pharmacy_id) REFERENCES pharmacies(id) ON DELETE SET NULL
      );
    ''');
  }
}
