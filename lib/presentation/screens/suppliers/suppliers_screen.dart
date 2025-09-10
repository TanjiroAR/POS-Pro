import 'package:flutter/material.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> suppliers = [
    {
      'name': 'شركة النور',
      'phone': '01112345678',
      'address': 'القاهرة',
      'email': 'info@elnour.com',
      'invoices': 5
    },
    {
      'name': 'مؤسسة الصحة',
      'phone': '01187654321',
      'address': 'الجيزة',
      'email': 'contact@health.com',
      'invoices': 2
    },
  ];

  void addSupplier() {
    // لاحقًا فتح شاشة SupplierFormView
  }

  void editSupplier(int index) {
    // لاحقًا فتح شاشة تعديل المورد
  }

  void deleteSupplier(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف المورد ${suppliers[index]['name']}؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              setState(() {
                suppliers.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void viewInvoices(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('الفواتير الخاصة بـ ${suppliers[index]['name']}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: suppliers[index]['invoices'],
            itemBuilder: (context, i) {
              return ListTile(
                title: Text('فاتورة رقم ${i + 1}'),
                subtitle: const Text('تفاصيل الفاتورة هنا'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSuppliers = suppliers
        .where((s) =>
    s['name'].toLowerCase().contains(searchController.text.toLowerCase()) ||
        s['phone'].contains(searchController.text))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // حقل البحث وأزرار الإضافة
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'ابحث عن المورد',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: addSupplier,
                icon: const Icon(Icons.add),
                label: const Text('إضافة مورد'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('الاسم')),
                  DataColumn(label: Text('الهاتف')),
                  DataColumn(label: Text('العنوان')),
                  DataColumn(label: Text('البريد')),
                  DataColumn(label: Text('الفواتير')),
                  DataColumn(label: Text('تعديل')),
                  DataColumn(label: Text('حذف')),
                ],
                rows: List.generate(filteredSuppliers.length, (index) {
                  final supplier = filteredSuppliers[index];
                  return DataRow(cells: [
                    DataCell(Text(supplier['name'])),
                    DataCell(Text(supplier['phone'] ?? '-')),
                    DataCell(Text(supplier['address'] ?? '-')),
                    DataCell(Text(supplier['email'] ?? '-')),
                    DataCell(
                      TextButton(
                        onPressed: () => viewInvoices(index),
                        child: Text('${supplier['invoices']} فاتورة'),
                      ),
                    ),
                    DataCell(IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => editSupplier(index),
                    )),
                    DataCell(IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteSupplier(index),
                    )),
                  ]);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
