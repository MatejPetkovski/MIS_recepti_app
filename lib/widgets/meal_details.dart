import 'package:flutter/material.dart';
import '../models/meal_detail_model.dart';

class DetailImageMeal extends StatelessWidget {
  final String image;
  const DetailImageMeal({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Image.network(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class DetailTitleMeal extends StatelessWidget {
  final String id;
  final String name;

  const DetailTitleMeal({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.red,
      child: Center(
        child: Text(
          name.toUpperCase(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DetailDataMeal extends StatelessWidget {
  final MealDetailModel meal;

  const DetailDataMeal({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Состојки:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...meal.ingredients.map((i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '• ${i.ingredient} — ${i.measure}',
              style: const TextStyle(fontSize: 18),
            ),
          )),
          const SizedBox(height: 30),
          const Text(
            'Инструкции:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            meal.instructions,
            style: const TextStyle(fontSize: 18, height: 1.4),
          ),
          if (meal.youtube != null && meal.youtube!.isNotEmpty) ...[
            const SizedBox(height: 30),
            const Text(
              'YouTube линк:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              meal.youtube!,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 18)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
