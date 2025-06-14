import 'package:flutter/material.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final List<Map<String, dynamic>> _foodEntries = [
    {'category': 'Meat (Beef)', 'quantity': 0.0},
  ];

  final Map<String, double> _emissionFactors = {
    'Meat (Beef)': 27.0,         // kg CO₂e per kg
    'Meat (Lamb)': 39.2,
    'Meat (Pork)': 12.1,
    'Meat (Chicken)': 6.9,
    'Fish': 5.4,
    'Dairy (Milk)': 1.9,
    'Dairy (Cheese)': 13.5,
    'Dairy (Yogurt)': 2.2,
    'Eggs': 4.8,
    'Vegetables': 2.0,
    'Fruits': 1.1,
    'Grains (Rice, Wheat)': 2.7,
    'Beverages (Coffee)': 16.5,
    'Beverages (Tea)': 1.4,
    'Processed Foods': 7.0,
    'Fast Food': 6.1,
  };

  double calculateTotalEmissions() {
    double total = 0.0;
    for (var entry in _foodEntries) {
      String category = entry['category'];
      double quantity = entry['quantity'];
      total += quantity * (_emissionFactors[category] ?? 0.0);
    }
    return total;
  }

  void _addEntry() {
    setState(() {
      _foodEntries.add({'category': 'Meat (Beef)', 'quantity': 0.0});
    });
  }

  void _removeEntry(int index) {
    setState(() {
      _foodEntries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Food Consumption'),
        backgroundColor: Colors.green[700],
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _foodEntries.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _foodEntries[index]['category'],
                            decoration: const InputDecoration(
                              labelText: 'Food Category',
                              border: OutlineInputBorder(),
                            ),
                            items: _emissionFactors.keys.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _foodEntries[index]['category'] = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Quantity Consumed (kg)',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _foodEntries[index]['quantity'] = double.tryParse(val) ?? 0.0;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeEntry(index),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addEntry,
              icon: const Icon(Icons.add),
              label: const Text('Add Food Entry'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Food Emissions: ${calculateTotalEmissions().toStringAsFixed(2)} kg CO₂e',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
