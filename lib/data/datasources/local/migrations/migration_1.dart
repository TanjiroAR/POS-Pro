import 'package:sqflite/sqflite.dart';

class Migration1 {
  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE pharmacies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT,
        phone TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        pharmacy_id INTEGER,
        FOREIGN KEY (pharmacy_id) REFERENCES pharmacies (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        generic_name TEXT,
        expiry_date TEXT,
        price REAL NOT NULL,
        discount REAL DEFAULT 0,
        stock INTEGER NOT NULL,
        strength TEXT,
        source TEXT,
        category TEXT,
        pharmacy_id INTEGER,
        FOREIGN KEY (pharmacy_id) REFERENCES pharmacies (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE invoices (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        pharmacy_id INTEGER NOT NULL,
        total REAL NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (pharmacy_id) REFERENCES pharmacies (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE invoice_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoice_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (invoice_id) REFERENCES invoices (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      );
    ''');
  }
}
