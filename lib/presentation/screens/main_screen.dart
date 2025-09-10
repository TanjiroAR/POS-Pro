import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:pos_pro/presentation/screens/pos/pos_screen.dart';
import 'package:pos_pro/presentation/screens/reports/reports_screen.dart';
import 'package:pos_pro/presentation/screens/suppliers/suppliers_screen.dart';
import 'customers/customers_screen.dart';
import 'inventory/inventory_screen.dart';
import 'inventory/product_form_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  String? selectedCom;
  List<String> availablePorts = [];
  SerialPort? scannerPort;
  SerialPortReader? scannerReader;
  String lastScannedBarcode = '';

  // Stream للباركود لإرسال أي مسح إلى أي صفحة
  final StreamController<String> _barcodeStreamController = StreamController.broadcast();

  final List<Widget> screens = const [
    PosScreen(),
    InventoryScreen(),
    CustomersScreen(),
    SuppliersScreen(),
    ReportsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    availablePorts = SerialPort.availablePorts;

    // بعد بناء الواجهة، نحاول الاتصال بالماسح
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (availablePorts.isNotEmpty) {
        selectedCom = availablePorts.first;
        connectScanner(selectedCom!);
      }
    });
  }

  void connectScanner(String com) {
    scannerReader?.close();
    scannerPort?.close();

    scannerPort = SerialPort(com);

    if (!scannerPort!.openReadWrite()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ فشل الاتصال بالماسح على $com'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ تم الاتصال بالماسح على $com'),
        backgroundColor: Colors.green,
      ),
    );

    scannerReader = SerialPortReader(scannerPort!);
    scannerReader!.stream.listen((data) {
      final barcode = String.fromCharCodes(data).trim();
      if (kDebugMode) print('Scanned: $barcode');

      setState(() => lastScannedBarcode = barcode);
      _barcodeStreamController.add(barcode); // إرسال الباركود لأي صفحة مفتوحة
    });
  }

  @override
  void dispose() {
    scannerReader?.close();
    scannerPort?.close();
    _barcodeStreamController.close();
    super.dispose();
  }

  void openAddProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormView(
          barcodeStream: _barcodeStreamController.stream,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openAddProduct,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => setState(() => selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.point_of_sale),
                selectedIcon: Icon(Icons.point_of_sale),
                label: Text('POS'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory),
                selectedIcon: Icon(Icons.inventory),
                label: Text('Inventory'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                selectedIcon: Icon(Icons.people),
                label: Text('Customers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.local_shipping),
                selectedIcon: Icon(Icons.local_shipping),
                label: Text('Suppliers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('Reports'),
              ),
            ],
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (availablePorts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No COM ports found'),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedCom,
                      items: availablePorts
                          .map((port) => DropdownMenuItem(value: port, child: Text(port)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCom = value;
                            connectScanner(value);
                          });
                        }
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  lastScannedBarcode,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: screens[selectedIndex]),
        ],
      ),
    );
  }
}
