import 'package:flutter/material.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final TextEditingController searchController = TextEditingController();
  final List<Map<String, dynamic>> products = [
    {'name': 'Paracetamol', 'price': 20},
    {'name': 'Amoxicillin', 'price': 50},
    {'name': 'Vitamin C', 'price': 30},
    {'name': 'Cough Syrup', 'price': 40},
  ];

  final List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      final index = cart.indexWhere((p) => p['name'] == product['name']);
      if (index >= 0) {
        cart[index]['quantity'] += 1;
      } else {
        cart.add({...product, 'quantity': 1});
      }
    });
  }

  double get totalPrice =>
      cart.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((p) =>
        p['name'].toLowerCase().contains(searchController.text.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // حقل البحث
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'ابحث عن المنتج',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                // GridView للمنتجات
                Expanded(
                  flex: 3,
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3 / 2,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () => addToCart(product),
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(product['name'],
                                    style:
                                    const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text('${product['price']} جنيه'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // السلة
                Expanded(
                  flex: 2,
                  child: Card(
                    color: Colors.grey[50],
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('السلة',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                              itemCount: cart.length,
                              itemBuilder: (context, index) {
                                final item = cart[index];
                                return ListTile(
                                  title: Text(item['name']),
                                  subtitle: Text(
                                      'الكمية: ${item['quantity']} × ${item['price']}'),
                                  trailing: Text(
                                      '${item['quantity'] * item['price']} جنيه'),
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          Text('الإجمالي: $totalPrice جنيه',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // هنا ممكن إضافة منطق إتمام البيع
                              setState(() {
                                cart.clear();
                              });
                            },
                            child: const Text('إتمام البيع'),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../../../data/models/product_model.dart';
// import '../../../data/models/customer_model.dart';
// import '../../../data/models/invoice_item_model.dart';
// import '../../../domain/usecases/complete_sale_usecase.dart';
// import '../../../data/repositories/pos_repository.dart';
//
// class PosScreen extends StatefulWidget {
//   const PosScreen({super.key});
//
//   @override
//   State<PosScreen> createState() => _PosScreenState();
// }
//
// class _PosScreenState extends State<PosScreen> {
//   List<Product> products = [];
//   List<Product> filteredProducts = [];
//   List<InvoiceItem> cartItems = [];
//   Customer? selectedCustomer;
//   final TextEditingController paidController = TextEditingController(text: '0');
//   final TextEditingController searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }
//
//   Future<void> _loadProducts() async {
//     final db = await PosRepository().db.database;
//     final results = await db.query('products');
//
//     if (!mounted) return;
//     setState(() {
//       products = results.map((e) => Product.fromMap(e)).toList();
//       filteredProducts = List.from(products);
//     });
//   }
//
//   void _filterProducts(String query) {
//     setState(() {
//       filteredProducts = products.where((p) {
//         final q = query.toLowerCase();
//         return p.name.toLowerCase().contains(q) ||
//             (p.barcode?.contains(query) ?? false);
//       }).toList();
//     });
//   }
//
//   void _addToCart(Product product) {
//     if (product.stock <= 0) return; // لا يسمح بإضافة منتج بدون مخزون
//     setState(() {
//       final index = cartItems.indexWhere((item) => item.productId == product.id);
//       if (index >= 0) {
//         if (cartItems[index].quantity < product.stock) {
//           cartItems[index].quantity += 1;
//         }
//       } else {
//         cartItems.add(InvoiceItem(
//           productId: product.id!,
//           price: product.price,
//           quantity: 1,
//           invoiceId: null,
//         ));
//       }
//     });
//   }
//
//   double get total => cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
//
//   Future<void> _completeSale() async {
//     if (selectedCustomer == null) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('يرجى اختيار العميل أولاً')),
//       );
//       return;
//     }
//
//     final usecase = CompleteSaleUsecase(PosRepository());
//
//     await usecase.call(
//       customerId: selectedCustomer!.id!,
//       userId: 1,
//       pharmacyId: 1,
//       items: cartItems,
//       paidAmount: double.tryParse(paidController.text) ?? 0,
//     );
//
//     if (!mounted) return;
//
//     setState(() {
//       cartItems.clear();
//       paidController.text = '0';
//       searchController.clear();
//       filteredProducts = List.from(products);
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('تمت عملية البيع بنجاح')),
//     );
//
//     _loadProducts(); // تحديث المخزون
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('POS')),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // اختيار العميل
//             DropdownButton<Customer>(
//               hint: const Text('اختر العميل'),
//               value: selectedCustomer,
//               onChanged: (value) => setState(() => selectedCustomer = value),
//               items: [
//                 DropdownMenuItem(
//                   value: Customer(id: 1, name: 'عميل تجريبي', phone: null, address: null, email: null),
//                   child: Text('عميل تجريبي'),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 12),
//
//             // حقل البحث
//             TextField(
//               controller: searchController,
//               decoration: const InputDecoration(
//                 labelText: 'ابحث باسم المنتج أو الباركود',
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: _filterProducts,
//             ),
//
//             const SizedBox(height: 12),
//
//             // قائمة المنتجات
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 2.5,
//                 ),
//                 itemCount: filteredProducts.length,
//                 itemBuilder: (context, index) {
//                   final product = filteredProducts[index];
//                   return Card(
//                     child: ListTile(
//                       title: Text(product.name),
//                       subtitle: Text('${product.stock} متوفر'),
//                       trailing: Text('${product.price} ج'),
//                       onTap: () => _addToCart(product),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const Divider(),
//
//             // السلة
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartItems.length,
//                 itemBuilder: (context, index) {
//                   final item = cartItems[index];
//                   final product = products.firstWhere((p) => p.id == item.productId);
//                   return ListTile(
//                     title: Text(product.name),
//                     subtitle: Text('السعر: ${item.price} × الكمية: ${item.quantity}'),
//                     trailing: Text('المجموع: ${item.price * item.quantity}'),
//                   );
//                 },
//               ),
//             ),
//
//             const Divider(),
//
//             // المجموع الكلي والمدفوع
//             Row(
//               children: [
//                 Expanded(child: Text('المجموع: $total ج', style: const TextStyle(fontSize: 18))),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     controller: paidController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(labelText: 'المبلغ المدفوع'),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 12),
//
//             // زر إتمام البيع
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _completeSale,
//                 child: const Text('إتمام البيع', style: TextStyle(fontSize: 18)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
