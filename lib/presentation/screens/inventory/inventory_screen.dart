import 'package:flutter/material.dart';
import 'package:pos_pro/presentation/screens/inventory/product_form_view.dart';

import '../../../data/datasources/local/app_database.dart';
import '../../../data/models/product_model.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Product> products = [];

  Future<void> _loadProducts() async {
    final dao = await AppDatabase().productsDao;
    final list = await dao.getAllProducts();
    setState(() {
      products = list;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المخزن'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductFormView()),
              );
              _loadProducts();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Barcode')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Stock')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Discount (%)')),
          ],
          rows: products
              .map(
                (p) => DataRow(
                  cells: [
                    DataCell(Text(p.barcode)),
                    DataCell(Text(p.name)),
                    DataCell(Text(p.boxPrice.toString())),
                    DataCell(Text(p.stock.toString())),
                    DataCell(Text(p.category)),
                    DataCell(Text(p.discount.toString())),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
