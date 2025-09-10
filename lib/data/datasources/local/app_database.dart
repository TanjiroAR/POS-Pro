import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

import '../products_dao.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();
  factory AppDatabase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // تهيئة sqflite للـ Desktop
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDB('pharmacy_pos.db');
    return _database!;
  }

  Future<ProductsDao> get productsDao async {
    final db = await database;
    return ProductsDao(db);
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        // Products
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            barcode TEXT,
            price REAL NOT NULL,
            stock INTEGER NOT NULL,
            discount REAL DEFAULT 0.0
          )
        ''');

        // Customers
        await db.execute('''
          CREATE TABLE customers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT,
            address TEXT,
            email TEXT
          )
        ''');

        // Suppliers
        await db.execute('''
          CREATE TABLE suppliers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT,
            address TEXT,
            email TEXT
          )
        ''');

        // Sales Invoices
        await db.execute('''
          CREATE TABLE invoices(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer_id INTEGER NOT NULL,
            user_id INTEGER NOT NULL,
            pharmacy_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            total REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE invoice_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            invoice_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            price REAL NOT NULL
          )
        ''');

        // Purchase Invoices
        await db.execute('''
          CREATE TABLE purchase_invoices(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            supplier_id INTEGER NOT NULL,
            pharmacy_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            total_amount REAL NOT NULL,
            paid_amount REAL DEFAULT 0,
            remaining_amount REAL DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE purchase_invoice_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            purchase_invoice_id INTEGER NOT NULL,
            product_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL,
            unit_cost REAL NOT NULL
          )
        ''');

        // Payments
        await db.execute('''
          CREATE TABLE payments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            kind TEXT NOT NULL, -- 'customer' أو 'supplier'
            ref_id INTEGER NOT NULL,
            pharmacy_id INTEGER,
            date TEXT NOT NULL,
            amount REAL NOT NULL,
            notes TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // هنا Migration 2
        }
        if (oldVersion < 3) {
          // هنا Migration 3
          await db.execute('ALTER TABLE products ADD COLUMN discount REAL DEFAULT 0.0');
        }
      },
    );
  }
}
