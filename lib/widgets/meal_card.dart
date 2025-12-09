import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/favorites_service.dart';

class MealCard extends StatefulWidget {
  final MealModel meal;
  const MealCard({super.key, required this.meal});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  final favoritesService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = favoritesService.isFavorite(widget.meal);

    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red.shade300, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.meal.thumbnail,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
                const Divider(),
                Text(
                  widget.meal.meal,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              setState(() {
                favoritesService.toggleFavorite(widget.meal);
              });
            },
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
