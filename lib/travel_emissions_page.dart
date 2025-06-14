import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TravelEntry {
  String mode;
  double distance;
  DateTime? startDate;
  DateTime? endDate;
  String frequency;

  TravelEntry({
    required this.mode,
    this.distance = 0.0,
    this.startDate,
    this.endDate,
    this.frequency = 'Daily',
  });
}

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});

  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  final Map<String, List<TravelEntry>> _monthlyEntries = {};
  // List<TravelEntry> _previousWeekEntries = [];
  // bool _usePreviousWeekData = false;

  static const Map<String, double> _emissionFactors = {
    'Car (Petrol)': 0.192,
    'Car (Diesel)': 0.171,
    'Car (CNG)': 0.121,
    'Car (Electric)': 0.05,
    'Taxi (Petrol)': 0.182,
    'Taxi (CNG)': 0.14,
    'Auto Rickshaw (CNG)': 0.105,
    'Bus (Diesel)': 0.105,
    'Bus (Electric)': 0.03,
    'Metro': 0.026,
    'Train (Electric)': 0.041,
    'Train (Diesel)': 0.06,
    'Flight (Short Haul)': 0.255,
    'Flight (Medium Haul)': 0.225,
    'Flight (Long Haul)': 0.195,
    'Bike (Petrol)': 0.072,
    'Scooter (Electric)': 0.02,
    'Bicycle': 0.0,
    'Walking': 0.0,
  };

  static final List<String> _modes = _emissionFactors.keys.toList();
  static final List<String> _frequencies = ['Daily', 'Weekly', 'One-time'];

  void _addNewMonth() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final monthKey = DateFormat('MMMM yyyy').format(selectedDate);
      if (!_monthlyEntries.containsKey(monthKey)) {
        setState(() {
          _monthlyEntries[monthKey] = [TravelEntry(mode: _modes[0])];
        });
      }
    }
  }

  int _calculateDays(DateTime start, DateTime end, String frequency) {
    int totalDays = end.difference(start).inDays + 1;
    switch (frequency) {
      case 'Daily':
        return totalDays;
      case 'Weekly':
        return ((totalDays + 6) / 7).floor(); // round up to full weeks
      case 'One-time':
        return 1;
      default:
        return totalDays;
    }
  }

  double _calculateEmissionsForEntry(TravelEntry entry) {
    if (entry.startDate == null || entry.endDate == null) return 0.0;
    final days = _calculateDays(entry.startDate!, entry.endDate!, entry.frequency);
    final factor = _emissionFactors[entry.mode] ?? 0.0;
    return entry.distance * days * factor;
  }

  double _calculateTotalEmissions() {
    double total = 0.0;
    _monthlyEntries.forEach((month, entries) {
      for (var entry in entries) {
        total += _calculateEmissionsForEntry(entry);
      }
    });
    return total;
  }

  Widget _buildMonthSection(String month, List<TravelEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(month, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ...entries.asMap().entries.map((entryData) {
          final index = entryData.key;
          final entry = entryData.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: entry.mode,
                    items: _modes.map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(mode),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        entry.mode = val!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Mode of Transport",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: entry.frequency,
                    items: _frequencies.map((freq) {
                      return DropdownMenuItem(
                        value: freq,
                        child: Text(freq),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        entry.frequency = val!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Frequency",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Distance per ${'Day/Trip'} (in km)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        entry.distance = double.tryParse(val) ?? 0.0;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: entry.startDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                entry.startDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(entry.startDate == null
                                ? "Start Date"
                                : DateFormat('dd MMM yyyy').format(entry.startDate!)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: entry.endDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                entry.endDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(entry.endDate == null
                                ? "End Date"
                                : DateFormat('dd MMM yyyy').format(entry.endDate!)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (entries.length > 1)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            entries.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                entries.add(TravelEntry(mode: _modes[0]));
              });
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Entry for this Month"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Travel Emissions Tracker"),
        backgroundColor: Colors.green[700],
      ),
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Checkbox(
            //       value: _usePreviousWeekData,
            //       onChanged: (value) {
            //         setState(() {
            //           _usePreviousWeekData = value!;
            //           if (_usePreviousWeekData && _previousWeekEntries.isNotEmpty) {
            //             _entries = List.from(_previousWeekEntries);
            //           }
            //         });
            //       },
            //     ),
            //     const Text("Same as last week")
            //   ],
            // ),
            Expanded(
              child: ListView(
                children: _monthlyEntries.entries
                    .map((entry) => _buildMonthSection(entry.key, entry.value))
                    .toList(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addNewMonth,
              icon: const Icon(Icons.calendar_month),
              label: const Text("Add Another Month"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            ),
            const SizedBox(height: 20),
            Text(
              "Total Emissions: ${_calculateTotalEmissions().toStringAsFixed(2)} kg CO₂",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
