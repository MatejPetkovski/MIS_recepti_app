import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../widgets/meal_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final favoritesService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    final favorites = favoritesService.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Омилени рецепти"),
      ),

      body: favorites.isEmpty
          ? const Center(
        child: Text(
          "Немате додадено омилени рецепти!",
          style: TextStyle(fontSize: 18),
        ),
      )

          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favorites.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          return MealCard(meal: favorites[index]);
        },
      ),
    );
  }

  // Rebuild screen when returning back from other pages
  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }
}
