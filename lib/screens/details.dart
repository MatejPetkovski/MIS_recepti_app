import 'package:flutter/material.dart';

import '../models/meal_detail_model.dart';
import '../widgets/meal_details.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as MealDetailModel;

    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DetailImageMeal(image: meal.thumbnail),
            const SizedBox(height: 20),
            DetailTitleMeal(id: meal.id, name: meal.meal),
            const SizedBox(height: 30),
            DetailDataMeal(meal: meal),
          ],
        ),
      ),
    );
  }
}
