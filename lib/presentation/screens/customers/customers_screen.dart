import 'package:flutter/material.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> customers = [
    {
      'name': 'أحمد علي',
      'phone': '01012345678',
      'address': 'القاهرة',
      'email': 'ahmed@example.com',
      'debt': 200
    },
    {
      'name': 'منى محمد',
      'phone': '01087654321',
      'address': 'الجيزة',
      'email': 'mona@example.com',
      'debt': 0
    },
  ];

  void addCustomer() {
    // لاحقًا فتح شاشة CustomerFormView
  }

  void editCustomer(int index) {
    // لاحقًا فتح شاشة تعديل العميل
  }

  void deleteCustomer(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف العميل ${customers[index]['name']}؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              setState(() {
                customers.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = customers
        .where((c) =>
    c['name'].toLowerCase().contains(searchController.text.toLowerCase()) ||
        c['phone'].contains(searchController.text))
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
                    labelText: 'ابحث عن العميل',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: addCustomer,
                icon: const Icon(Icons.add),
                label: const Text('إضافة عميل'),
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
                  DataColumn(label: Text('الديون')),
                  DataColumn(label: Text('تعديل')),
                  DataColumn(label: Text('حذف')),
                ],
                rows: List.generate(filteredCustomers.length, (index) {
                  final customer = filteredCustomers[index];
                  return DataRow(cells: [
                    DataCell(Text(customer['name'])),
                    DataCell(Text(customer['phone'] ?? '-')),
                    DataCell(Text(customer['address'] ?? '-')),
                    DataCell(Text(customer['email'] ?? '-')),
                    DataCell(Text('${customer['debt']} جنيه')),
                    DataCell(IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => editCustomer(index),
                    )),
                    DataCell(IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteCustomer(index),
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
