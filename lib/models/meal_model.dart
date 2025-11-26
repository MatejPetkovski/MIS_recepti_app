class MealModel {
  final String id;
  final String meal;
  final String thumbnail;

  MealModel({
    required this.id,
    required this.meal,
    required this.thumbnail,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal']?.toString() ?? '',
      meal: json['strMeal']?.toString() ?? '',
      thumbnail: json['strMealThumb']?.toString() ?? '',
    );
  }
}
