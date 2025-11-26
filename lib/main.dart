import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/meals_by_category.dart';
import 'screens/details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Рецепти',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const HomeScreen(),
        "/meals_by_category": (context) => const MealsByCategoryScreen(),
        "/details": (context) => const DetailsPage(),
      },
    );
  }
}
