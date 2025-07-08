import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_drawer.dart';

class ElectricityEntry {
  String state;
  double kWh;

  ElectricityEntry({required this.state, this.kWh = 0.0});
}

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({super.key});

  @override
  State<ElectricityPage> createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  final Map<String, ElectricityEntry> _monthlyEntries = {};
  String? _selectedMonth;

  final Map<String, double> _stateEmissionFactors = {
    'Andhra Pradesh': 0.95,
    'Arunachal Pradesh': 0.57,
    'Assam': 1.1,
    'Bihar': 1.1,
    'Chhattisgarh': 1.25,
    'Delhi': 0.95,
    'Goa': 0.64,
    'Gujarat': 0.84,
    'Haryana': 1.1,
    'Himachal Pradesh': 0.57,
    'Jharkhand': 1.25,
    'Karnataka': 0.72,
    'Kerala': 0.57,
    'Madhya Pradesh': 1.25,
    'Maharashtra': 0.89,
    'Manipur': 1.1,
    'Meghalaya': 1.1,
    'Mizoram': 1.1,
    'Nagaland': 1.1,
    'Odisha': 1.25,
    'Punjab': 1.1,
    'Rajasthan': 1.25,
    'Sikkim': 0.57,
    'Tamil Nadu': 0.69,
    'Telangana': 0.89,
    'Tripura': 1.1,
    'Uttar Pradesh': 1.25,
    'Uttarakhand': 0.57,
    'West Bengal': 1.1,
    'Andaman and Nicobar Islands': 1.1,
    'Chandigarh': 0.64,
    'Dadra and Nagar Haveli and Daman and Diu': 0.84,
    'Lakshadweep': 1.1,
    'Puducherry': 0.69,
    'Ladakh': 0.57,
    'Jammu and Kashmir': 0.57,
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
          _selectedMonth = monthKey;
          _monthlyEntries[monthKey] = ElectricityEntry(state: 'Maharashtra');
        });
      } else {
        setState(() {
          _selectedMonth = monthKey;
        });
      }
    }
  }

  double _calculateTotalEmissions() {
    double total = 0.0;

    _monthlyEntries.forEach((month, entry) {
      final emissionFactor = _stateEmissionFactors[entry.state] ?? 0.89;
      total += entry.kWh * emissionFactor;
    });
    return total;
  }

  Widget _buildMonthSection(String month, ElectricityEntry entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(month,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: entry.state,
                  decoration: const InputDecoration(
                    labelText: "State",
                    border: OutlineInputBorder(),
                  ),
                  items: _stateEmissionFactors.keys.map((state) {
                    return DropdownMenuItem(value: state, child: Text(state));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      entry.state = val!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Usage (kWh for the Month)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    setState(() {
                      entry.kWh = double.tryParse(val) ?? 0.0;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Electricity Emissions'),
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
              label: const Text("Add Month"),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: _selectedMonth == null
                    ? []
                    : _monthlyEntries.entries
                        .map((entry) => _buildMonthSection(entry.key, entry.value))
                        .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Estimated Total Emissions",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${_calculateTotalEmissions().toStringAsFixed(2)} kg CO₂",
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
