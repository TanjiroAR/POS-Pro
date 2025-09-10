import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/datasources/products_dao.dart';
import '../../../data/models/product_model.dart';

class ProductFormView extends StatefulWidget {
  final Product? product;
  final Stream<String>? barcodeStream;

  const ProductFormView({super.key, this.product, this.barcodeStream});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genericNameController = TextEditingController();
  final TextEditingController _boxPriceController = TextEditingController();
  final TextEditingController _stripPriceController = TextEditingController();
  final TextEditingController _stripsInBoxController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  String category = 'مسكنات';
  DateTime? productionDate;
  DateTime? expiryDate;

  late ProductsDao productsDao;
  bool _daoReady = false;
  StreamSubscription<String>? _barcodeSubscription;

  @override
  void initState() {
    super.initState();
    _initDao();

  }

  Future<void> _initDao() async {
    final db = await AppDatabase().database;
    productsDao = ProductsDao(db);
    setState(() => _daoReady = true);

    // استماع للباركود من الماسح
    if (widget.barcodeStream != null) {
      _barcodeSubscription = widget.barcodeStream!.listen((barcode) async {
        _barcodeController.text = barcode;
        final existing = await productsDao.getProductByBarcode(barcode);
        if (existing != null) _fillFields(existing);
      });
    }

    if (widget.product != null) _fillFields(widget.product!);
  }

  void _fillFields(Product product) {
    _barcodeController.text = product.barcode;
    _nameController.text = product.name;
    _genericNameController.text = product.genericName;
    _boxPriceController.text = product.boxPrice.toString();
    _stripPriceController.text = product.stripPrice.toString();
    _stripsInBoxController.text = product.stripsInBox.toString();
    _stockController.text = product.stock.toString();
    _discountController.text = product.discount.toString();
    _supplierController.text = product.supplierName;
    category = product.category;
    productionDate = product.productionDate;
    expiryDate = product.expiryDate;
    setState(() {});
  }

  @override
  void dispose() {
    _barcodeSubscription?.cancel();
    _barcodeController.dispose();
    _nameController.dispose();
    _genericNameController.dispose();
    _boxPriceController.dispose();
    _stripPriceController.dispose();
    _stripsInBoxController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isProduction) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isProduction) {
          productionDate = picked;
        } else {
          expiryDate = picked;
        }
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_daoReady) return;
    if (!_formKey.currentState!.validate()) return;
    if (productionDate == null || expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار تاريخ الإنتاج والانتهاء')),
      );
      return;
    }

    final product = Product(
      id: widget.product?.id,
      barcode: _barcodeController.text,
      name: _nameController.text,
      genericName: _genericNameController.text,
      category: category,
      boxPrice: double.tryParse(_boxPriceController.text) ?? 0,
      stripPrice: double.tryParse(_stripPriceController.text) ?? 0,
      stripsInBox: int.tryParse(_stripsInBoxController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      discount: double.tryParse(_discountController.text) ?? 0,
      supplierName: _supplierController.text,
      productionDate: productionDate,
      expiryDate: expiryDate,
    );

    if (widget.product == null) {
      await productsDao.insertProduct(product);
    } else {
      await productsDao.updateProduct(product);
    }

    if (mounted) Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    if (!_daoReady) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'إضافة منتج' : 'تعديل منتج')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _barcodeController, decoration: const InputDecoration(labelText: 'Barcode')),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextFormField(controller: _genericNameController, decoration: const InputDecoration(labelText: 'Generic Name')),
              DropdownButtonFormField<String>(
                value: category,
                items: ['مسكنات', 'مضادات حيوية', 'شراب', 'أدوية أخرى']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => category = val!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(controller: _boxPriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Box Price')),
              TextFormField(controller: _stripPriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Strip Price')),
              TextFormField(controller: _stripsInBoxController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Strips in Box')),
              TextFormField(controller: _stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock')),
              TextFormField(controller: _discountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Discount (%)')),
              TextFormField(controller: _supplierController, decoration: const InputDecoration(labelText: 'Supplier Name')),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(productionDate == null
                        ? 'Production Date'
                        : 'Production: ${productionDate!.day}/${productionDate!.month}/${productionDate!.year}'),
                  ),
                  TextButton(onPressed: () => _pickDate(context, true), child: const Text('Select')),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(expiryDate == null
                        ? 'Expiry Date'
                        : 'Expiry: ${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}'),
                  ),
                  TextButton(onPressed: () => _pickDate(context, false), child: const Text('Select')),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _saveProduct, child: const Text('Save Product')),
            ],
          ),
        ),
      ),
    );
  }
}
