import 'package:sqflite/sqflite.dart';
import '../models/supplier_model.dart';
import 'local/app_database.dart';

class SuppliersDao {
  Future<int> insertSupplier(Supplier supplier) async {
    final db = await AppDatabase().database;
    return await db.insert(
      'suppliers',
      supplier.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateSupplier(Supplier supplier) async {
    final db = await AppDatabase().database;
    return await db.update(
      'suppliers',
      supplier.toMap(),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  Future<int> deleteSupplier(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      'suppliers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Supplier>> getAllSuppliers() async {
    final db = await AppDatabase().database;
    final result = await db.query('suppliers');
    return result.map((map) => Supplier.fromMap(map)).toList();
  }

  Future<Supplier?> getSupplierById(int id) async {
    final db = await AppDatabase().database;
    final result =
    await db.query('suppliers', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return Supplier.fromMap(result.first);
    return null;
  }
}
