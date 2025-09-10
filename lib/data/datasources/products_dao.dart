import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';

class ProductsDao {
  final Database db;

  ProductsDao(this.db);

  Future<int> insertProduct(Product product) async {
    return await db.insert(
      'products',
      product.toMap(), // toMap() الآن يشمل الحقل discount
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateProduct(Product product) async {
    return await db.update(
      'products',
      product.toMap(), // toMap() يشمل discount
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Product>> getAllProducts({int? pharmacyId}) async {
    final result = await db.query(
      'products',
      where: pharmacyId != null ? 'pharmacy_id = ?' : null,
      whereArgs: pharmacyId != null ? [pharmacyId] : null,
    );
    return result.map((map) => Product.fromMap(map)).toList(); // fromMap() يشمل discount
  }

  Future<Product?> getProductById(int id) async {
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) return Product.fromMap(result.first); // يشمل discount
    return null;
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    final result =
    await db.query('products', where: 'barcode = ?', whereArgs: [barcode]);
    if (result.isNotEmpty) return Product.fromMap(result.first); // يشمل discount
    return null;
  }
}
