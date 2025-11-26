class IngredientPair {
  final String ingredient;
  final String measure;

  IngredientPair({required this.ingredient, required this.measure});
}

class MealDetailModel {
  final String id;
  final String meal;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String? youtube;
  final String? tags;
  final List<IngredientPair> ingredients;

  MealDetailModel({
    required this.id,
    required this.meal,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtube,
    required this.tags,
    required this.ingredients,
  });

  factory MealDetailModel.fromJson(Map<String, dynamic> json) {
    List<IngredientPair> pairs = [];
    for (int i = 1; i <= 20; i++) {
      final ingKey = 'strIngredient$i';
      final measKey = 'strMeasure$i';
      final rawIng = (json[ingKey] ?? '').toString().trim();
      final rawMeas = (json[measKey] ?? '').toString().trim();
      if (rawIng.isNotEmpty) {
        pairs.add(IngredientPair(ingredient: rawIng, measure: rawMeas));
      }
    }

    final rawYoutube = (json['strYoutube'] ?? '').toString().trim();
    final rawTags = (json['strTags'] ?? '').toString().trim();

    return MealDetailModel(
      id: json['idMeal']?.toString() ?? '',
      meal: json['strMeal']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '',
      area: json['strArea']?.toString() ?? '',
      instructions: json['strInstructions']?.toString() ?? '',
      thumbnail: json['strMealThumb']?.toString() ?? '',
      youtube: rawYoutube.isEmpty ? null : rawYoutube,
      tags: rawTags.isEmpty ? null : rawTags,
      ingredients: pairs,
    );
  }
}
