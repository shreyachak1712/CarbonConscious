import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_drawer.dart';

class ShoppingItem {
  String category;
  String itemName;
  int quantity;
  double cost;

  ShoppingItem({
    required this.category,
    this.itemName = '',
    this.quantity = 1,
    this.cost = 0.0,
  });
}

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final Map<String, List<ShoppingItem>> _monthlyEntries = {};
  final List<String> _categories = [
    'Clothing',
    'Electronics',
    'Books',
    'Cosmetics',
    'Furniture',
    'Toys',
    'Accessories',
    'Shoes',
    'Kitchenware',
    'Stationery',
    'Gadgets',
    'Groceries',
    'Miscellaneous',
  ];

  final Map<String, double> _emissionFactors = {
    'Clothing': 25.0,
    'Electronics': 50.0,
    'Books': 5.0,
    'Cosmetics': 20.0,
    'Furniture': 40.0,
    'Toys': 15.0,
    'Accessories': 18.0,
    'Shoes': 22.0,
    'Kitchenware': 12.0,
    'Stationery': 6.0,
    'Gadgets': 45.0,
    'Groceries': 10.0,
    'Miscellaneous': 15.0,
  };

  void _addNewMonth() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      final monthKey = DateFormat('MMMM yyyy').format(selectedDate);
      if (!_monthlyEntries.containsKey(monthKey)) {
        setState(() {
          _monthlyEntries[monthKey] = [
            ShoppingItem(category: 'Clothing'),
          ];
        });
      }
    }
  }

  void _addItem(String month) {
    setState(() {
      _monthlyEntries[month]?.add(ShoppingItem(category: 'Clothing'));
    });
  }

  void _removeItem(String month, int index) {
    setState(() {
      _monthlyEntries[month]?.removeAt(index);
    });
  }

  double _calculateEmissionsForItem(ShoppingItem item) {
    final factor = _emissionFactors[item.category] ?? 0.0;
    return ((item.cost * item.quantity) / 1000.0) * factor;
  }

  double _calculateTotalEmissions() {
    double total = 0.0;
    _monthlyEntries.forEach((month, items) {
      for (var item in items) {
        total += _calculateEmissionsForItem(item);
      }
    });
    return total;
  }

  Widget _buildMonthSection(String month, List<ShoppingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            month,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  DropdownButtonFormField<String>(
                    value: item.category,
                    items: _categories.map((category) {
                      return DropdownMenuItem(value: category, child: Text(category));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        item.category = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Category",
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Item Name
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      prefixIcon: Icon(Icons.shopping_bag),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      item.itemName = value;
                    },
                  ),
                  const SizedBox(height: 10),

                  // Quantity
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      prefixIcon: Icon(Icons.format_list_numbered),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        item.quantity = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Cost
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Cost per Item (₹)",
                      prefixIcon: Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        item.cost = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  const SizedBox(height: 6),

                  // Remove Button
                  if (items.length > 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _removeItem(month, index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text("Remove", style: TextStyle(color: Colors.red)),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),

        // Add Item Button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => _addItem(month),
            icon: const Icon(Icons.add),
            label: const Text("Add Item for this Month"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text("Shopping Emissions"),
        backgroundColor: Colors.green[700],
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _addNewMonth,
              icon: const Icon(Icons.calendar_month),
              label: const Text("Add New Month"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _monthlyEntries.entries
                    .map((entry) => _buildMonthSection(entry.key, entry.value))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            // Final Total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Total Emissions from Shopping",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${_calculateTotalEmissions().toStringAsFixed(2)} kg CO₂",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
