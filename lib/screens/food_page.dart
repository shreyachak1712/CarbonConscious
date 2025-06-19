// Refactored FoodPage using servings instead of kg
import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final List<Map<String, dynamic>> _foodEntries = [
    {'category': 'Milk (1 glass)', 'servings': 1, 'date': DateTime.now(),},
  ];

  // Emission factors per serving (kg CO2e)
  final Map<String, double> _emissionsPerServing = {
    'Milk (1 glass)': 0.48,
    'Cheese (1 slice)': 0.54,
    'Yogurt (1 cup)': 0.44,
    'Egg (1)': 0.24,
    'Beef (1 portion)': 4.05,
    'Chicken (1 portion)': 1.04,
    'Fish (1 portion)': 0.81,
    'Pork (1 portion)': 1.82,
    'Lamb (1 portion)': 5.88,
    'Vegetables (1 serving)': 0.20,
    'Fruits (1 serving)': 0.11,
    'Grains (1 cup cooked)': 0.35,
    'Coffee (1 cup)': 0.34,
    'Tea (1 cup)': 0.07,
    'Processed Food (1 pack)': 0.70,
    'Fast Food (1 meal)': 1.83,
  };

  double calculateTotalEmissions() {
    double total = 0.0;
    for (var entry in _foodEntries) {
      String category = entry['category'];
      int servings = entry['servings'];
      total += servings * (_emissionsPerServing[category] ?? 0.0);
    }
    return total;
  }

  void _addEntry() {
    setState(() {
      _foodEntries.add({'category': 'Milk (1 glass)', 'servings': 1});
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
      drawer: const CustomDrawer(),
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
                            items: _emissionsPerServing.keys.map((String value) {
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
                            initialValue: _foodEntries[index]['servings'].toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Number of Servings',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _foodEntries[index]['servings'] = int.tryParse(val) ?? 0;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                            DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _foodEntries[index]['date'] ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                            setState(() {
                            _foodEntries[index]['date'] = picked;
                            });
                            }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    const SizedBox(width: 8),
                                    Text(
                                      _foodEntries[index]['date'] == null
                                        ? 'Select Date'
                                        : 'Date: ${_foodEntries[index]['date'].toString().split(' ')[0]}',
                                    ),
                                  ],
                                ),
                              ) 
                            ),
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