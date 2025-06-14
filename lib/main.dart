import 'shopping_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_dashboard.dart';
import 'travel_emissions_page.dart';
import 'food_page.dart'; 
import 'electricity_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Footprint Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomeDashboard(),
        '/travel': (context) => const TravelPage(), // New route for Travel
        '/food': (context) => const FoodPage(),
        '/electricity': (context) => const ElectricityPage(),
        '/shopping': (context) => const ShoppingPage(),

      },
    );
  }
}
