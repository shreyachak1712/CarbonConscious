import 'package:flutter/material.dart';
import 'dart:math';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({super.key});

  @override
  State<ElectricityPage> createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  final List<Map<String, dynamic>> _entries = [
    {'source': 'Grid Electricity', 'value': '', 'type': 'kWh'},
  ];

  final List<String> _sources = [
    'Grid Electricity',
    'Solar Electricity',
    'Generator (Diesel)',
    'Generator (Petrol)',
  ];

  double _totalEmissions = 0.0;

  // CO2 emission factors (in kg CO2 per unit)
  final Map<String, double> _emissionFactors = {
    'Grid Electricity': 0.82,         // kg CO₂ per kWh (India average)
    'Solar Electricity': 0.0,         // Renewable
    'Generator (Diesel)': 2.68,       // kg CO₂ per litre
    'Generator (Petrol)': 2.31,       // kg CO₂ per litre
  };

  void _calculateTotalEmissions() {
    double total = 0.0;

    for (var entry in _entries) {
      final source = entry['source'];
      final value = double.tryParse(entry['value']) ?? 0.0;
      final factor = _emissionFactors[source] ?? 0.0;

      // For generators, input is in liters. For others, in kWh
      total += value * factor;
    }

    setState(() {
      _totalEmissions = total;
    });
  }

  void _addEntry() {
    setState(() {
      _entries.add({'source': 'Grid Electricity', 'value': '', 'type': 'kWh'});
    });
  }

  void _removeEntry(int index) {
    setState(() {
      _entries.removeAt(index);
      _calculateTotalEmissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electricity Emissions'),
        backgroundColor: Colors.green[700],
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Enter your monthly electricity usage:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  final isGenerator = entry['source'].contains("Generator");

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Source dropdown
                          DropdownButtonFormField<String>(
                            value: entry['source'],
                            decoration: const InputDecoration(
                              labelText: "Source",
                            ),
                            items: _sources.map((String source) {
                              return DropdownMenuItem(
                                value: source,
                                child: Text(source),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                entry['source'] = value!;
                                entry['type'] = value.contains("Generator") ? 'Litres' : 'kWh';
                              });
                              _calculateTotalEmissions();
                            },
                          ),

                          const SizedBox(height: 10),

                          // Value input
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Usage (${entry['type']})",
                              prefixIcon: const Icon(Icons.electric_bolt),
                            ),
                            onChanged: (value) {
                              entry['value'] = value;
                              _calculateTotalEmissions();
                            },
                          ),

                          // Remove button
                          if (_entries.length > 1)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => _removeEntry(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text('Remove', style: TextStyle(color: Colors.red)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _addEntry,
              icon: const Icon(Icons.add),
              label: const Text("Add Another Source"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            ),
            const SizedBox(height: 20),

            // Total CO₂ display
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Estimated Monthly Emissions:",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${_totalEmissions.toStringAsFixed(2)} kg CO₂",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[900]),
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
