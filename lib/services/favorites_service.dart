import '../models/meal_model.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();

  factory FavoritesService() => _instance;

  FavoritesService._internal();

  final List<MealModel> _favorites = [];

  List<MealModel> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(MealModel meal) {
    return _favorites.any((m) => m.id == meal.id);
  }

  void toggleFavorite(MealModel meal) {
    if (isFavorite(meal)) {
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      _favorites.add(meal);
    }
  }
}
