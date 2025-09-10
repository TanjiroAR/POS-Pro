import 'package:sqflite/sqflite.dart';
import '../models/payment_model.dart';
import 'local/app_database.dart';

class PaymentsDao {
  Future<int> insertPayment(Payment payment) async {
    final db = await AppDatabase().database;
    return await db.insert(
      'payments',
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePayment(Payment payment) async {
    final db = await AppDatabase().database;
    return await db.update(
      'payments',
      payment.toMap(),
      where: 'id = ?',
      whereArgs: [payment.id],
    );
  }

  Future<int> deletePayment(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      'payments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Payment>> getAllPayments() async {
    final db = await AppDatabase().database;
    final result = await db.query('payments');
    return result.map((map) => Payment.fromMap(map)).toList();
  }

  Future<List<Payment>> getPaymentsByRef(String kind, int refId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      'payments',
      where: 'kind = ? AND ref_id = ?',
      whereArgs: [kind, refId],
    );
    return result.map((map) => Payment.fromMap(map)).toList();
  }
}
