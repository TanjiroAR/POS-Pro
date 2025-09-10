import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String reportType = 'المبيعات اليومية';
  DateTimeRange? dateRange;

  final List<Map<String, dynamic>> salesData = [
    {'product': 'Paracetamol', 'quantity': 20, 'total': 400, 'date': '26-08-2025'},
    {'product': 'Amoxicillin', 'quantity': 10, 'total': 500, 'date': '26-08-2025'},
  ];

  void pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateRange = picked;
      });
    }
  }

  void exportPDF() {
    // لاحقًا إضافة منطق تصدير PDF
  }

  void exportExcel() {
    // لاحقًا إضافة منطق تصدير Excel
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // اختيار نوع التقرير والتواريخ
          Row(
            children: [
              DropdownButton<String>(
                value: reportType,
                items: const [
                  DropdownMenuItem(
                      value: 'المبيعات اليومية', child: Text('المبيعات اليومية')),
                  DropdownMenuItem(
                      value: 'المبيعات الأسبوعية', child: Text('المبيعات الأسبوعية')),
                  DropdownMenuItem(
                      value: 'المبيعات الشهرية', child: Text('المبيعات الشهرية')),
                  DropdownMenuItem(
                      value: 'المخزون', child: Text('المخزون')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      reportType = value;
                    });
                  }
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                  onPressed: pickDateRange,
                  child: Text(dateRange != null
                      ? '${dateRange!.start.day}-${dateRange!.start.month}-${dateRange!.start.year} إلى ${dateRange!.end.day}-${dateRange!.end.month}-${dateRange!.end.year}'
                      : 'اختر الفترة')),
              const SizedBox(width: 16),
              ElevatedButton(onPressed: () {}, child: const Text('تحديث التقرير')),
              const SizedBox(width: 16),
              ElevatedButton(onPressed: exportPDF, child: const Text('تصدير PDF')),
              const SizedBox(width: 16),
              ElevatedButton(onPressed: exportExcel, child: const Text('تصدير Excel')),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('المنتج')),
                  DataColumn(label: Text('الكمية')),
                  DataColumn(label: Text('السعر الإجمالي')),
                  DataColumn(label: Text('التاريخ')),
                ],
                rows: salesData.map((sale) {
                  return DataRow(cells: [
                    DataCell(Text(sale['product'])),
                    DataCell(Text('${sale['quantity']}')),
                    DataCell(Text('${sale['total']} جنيه')),
                    DataCell(Text(sale['date'])),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
