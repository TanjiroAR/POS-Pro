import 'package:sqflite/sqflite.dart';
import '../models/customer_model.dart';
import 'local/app_database.dart';

class CustomersDao {
  Future<int> insertCustomer(Customer customer) async {
    final db = await AppDatabase().database;
    return await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await AppDatabase().database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await AppDatabase().database;
    final result = await db.query('customers');
    return result.map((map) => Customer.fromMap(map)).toList();
  }

  Future<Customer?> getCustomerById(int id) async {
    final db = await AppDatabase().database;
    final result =
    await db.query('customers', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return Customer.fromMap(result.first);
    return null;
  }
}
