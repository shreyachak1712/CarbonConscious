import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../widgets/custom_drawer.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _quoteIndex = 0;

  final List<String> quotes = [
    "Did you know? A 10 km car ride emits ~2.3 kg CO₂.",
    "Small steps matter. Reduce meat intake for a smaller carbon footprint.",
    "Switching to LED bulbs can save up to 80% energy.",
    "Recycling paper can save 17 trees per ton.",
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _quoteIndex = (_quoteIndex + 1) % quotes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, color: Colors.white),
            const SizedBox(width: 8),
            const Text("CarbonConscious"),
          ],
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFd0f0c0), Color(0xFFf5fffa)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Greeting
              const Text(
                "Good evening, User!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Radial Gauge
              Center(
                child: CircularPercentIndicator(
                  radius: 90.0,
                  lineWidth: 12.0,
                  percent: 2.45 / 10,
                  animation: true,
                  animateFromLastPercent: true,
                  center: const Text(
                    "2.45 kg CO₂",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  progressColor: Colors.green[800]!,
                  backgroundColor: Colors.green[100]!,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Your Carbon Footprint Today",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 30),

              // Category Section
              const Text(
                "Track by Category",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _categoryCard(
                      context, "Travel", "assets/images/travel.webp"),
                  _categoryCard(
                      context, "Food", "assets/images/food image.jpg"),
                  _categoryCard(
                      context, "Electricity", "assets/images/electricity image.webp"),
                  _categoryCard(
                      context, "Shopping", "assets/images/shopping image.jpg"),
                ],
              ),
              const SizedBox(height: 30),

              // Tip / Quote Slider
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[100]?.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.eco, size: 32, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          quotes[_quoteIndex],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 💡 Removed the "See Sustainability Tips" button
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/${title.toLowerCase()}');
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
