import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final List<Map<String, dynamic>> _items = [
    {
      'category': 'Clothing',
      'item': '',
      'quantity': '',
      'price': '',
    },
  ];

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

  // CO₂ per ₹1000 spent in different categories (kg CO₂ / ₹1000)
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

  double _totalEmissions = 0.0;

  void _calculateTotalEmissions() {
    double total = 0.0;

    for (var item in _items) {
      final category = item['category'];
      final price = double.tryParse(item['price']) ?? 0.0;
      final factor = _emissionFactors[category] ?? 0.0;

      total += (price / 1000.0) * factor;
    }

    setState(() {
      _totalEmissions = total;
    });
  }

  void _addItem() {
    setState(() {
      _items.add({
        'category': 'Clothing',
        'item': '',
        'quantity': '',
        'price': '',
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _calculateTotalEmissions();
    });
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
            const Text(
              "Enter your shopping details below:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: item['category'],
                            items: _categories.map((String category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                item['category'] = value!;
                              });
                              _calculateTotalEmissions();
                            },
                            decoration: const InputDecoration(
                              labelText: "Category",
                              prefixIcon: Icon(Icons.category),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Item Name",
                              prefixIcon: Icon(Icons.shopping_bag),
                            ),
                            onChanged: (value) {
                              item['item'] = value;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Quantity",
                              prefixIcon: Icon(Icons.format_list_numbered),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              item['quantity'] = value;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Price (₹)",
                              prefixIcon: Icon(Icons.currency_rupee),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              item['price'] = value;
                              _calculateTotalEmissions();
                            },
                          ),
                          const SizedBox(height: 6),
                          if (_items.length > 1)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => _removeItem(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text("Remove", style: TextStyle(color: Colors.red)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
              label: const Text("Add Item"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    "Estimated Emissions from Shopping:",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${_totalEmissions.toStringAsFixed(2)} kg CO₂",
                    style: TextStyle(
                      fontSize: 24,
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
