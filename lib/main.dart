import 'screens/shopping_page.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_dashboard.dart';
import 'screens/travel_emissions_page.dart';
import 'screens/food_page.dart'; 
import 'screens/electricity_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarbonConscious',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
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
