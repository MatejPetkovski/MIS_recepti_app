import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/meal_model.dart';
import '../models/meal_detail_model.dart';

class ApiService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<CategoryModel>> getCategories() async {
    final uri = Uri.parse('$_base/categories.php');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final List items = data['categories'] ?? [];
      return items.map((e) => CategoryModel.fromJson(e)).toList();
    }
    throw Exception('Грешка при вчитување на категории');
  }

  Future<List<MealModel>> getMealsByCategory(String category) async {
    final uri = Uri.parse('$_base/filter.php?c=${Uri.encodeComponent(category)}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final List items = data['meals'] ?? [];
      return items.map((e) => MealModel.fromJson(e)).toList();
    }
    throw Exception('Грешка при вчитување рецепти за $category');
  }

  Future<List<MealDetailModel>> searchMeals(String query) async {
    final uri = Uri.parse('$_base/search.php?s=${Uri.encodeComponent(query)}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final items = data['meals'];
      if (items == null) return [];
      return (items as List).map((e) => MealDetailModel.fromJson(e)).toList();
    }
    throw Exception('Настана грешка при пребарување');
  }

  Future<MealDetailModel> getMealById(String id) async {
    final uri = Uri.parse('$_base/lookup.php?i=${Uri.encodeComponent(id)}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final items = data['meals'] as List? ?? [];
      if (items.isEmpty) throw Exception('Meal not found');
      return MealDetailModel.fromJson(items[0]);
    }
    throw Exception('Грешка при вчитување на описот');
  }

  Future<MealDetailModel> getRandomMeal() async {
    final uri = Uri.parse('$_base/random.php');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final items = data['meals'] as List? ?? [];
      if (items.isEmpty) throw Exception('Грешка');
      return MealDetailModel.fromJson(items[0]);
    }
    throw Exception('Грешка при вчитување на рандом рецепт');
  }
}
