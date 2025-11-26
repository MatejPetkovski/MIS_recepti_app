import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'details.dart';
import '../models/meal_detail_model.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;
  const MealsByCategoryScreen({super.key, this.category = ''});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService _api = ApiService();
  List<MealModel> _meals = [];
  List<MealModel> _filtered = [];
  bool _loading = true;
  bool _isSearchingApi = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => _loading = true);
    try {
      final meals = await _api.getMealsByCategory(widget.category);
      setState(() {
        _meals = meals;
        _filtered = meals;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Грешка при вчитување на рецепти')));
    }
  }

  void _filter(String q) {
    setState(() {
      _query = q;
      if (q.isEmpty) {
        _filtered = _meals;
      } else {
        _filtered = _meals.where((m) => m.meal.toLowerCase().contains(q.toLowerCase())).toList();
      }
    });
  }

  Future<void> _searchInApi(String query) async {
    if (query.isEmpty) return;
    setState(() => _isSearchingApi = true);
    try {
      final results = await _api.searchMeals(query);
      final filteredByCategory = results
          .where((d) => d.category.toLowerCase() == widget.category.toLowerCase())
          .map((d) => MealModel(id: d.id, meal: d.meal, thumbnail: d.thumbnail))
          .toList();
      setState(() {
        _filtered = filteredByCategory;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Настана грешка при пребарување')));
    } finally {
      if (mounted) setState(() => _isSearchingApi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.category.isEmpty ? 'Рецепти' : widget.category;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Пребарувај рецепти во "$title"',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) => _filter(v),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty && _query.isNotEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Не постојат рецепти за "$_query" in $title', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _isSearchingApi ? null : () => _searchInApi(_query),
                    child: _isSearchingApi
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Search in API'),
                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final meal = _filtered[index];
                  return GestureDetector(
                    onTap: () async {
                      try {
                        final detail = await _api.getMealById(meal.id);
                        if (!mounted) return;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const DetailsPage(),
                          settings: RouteSettings(arguments: detail),
                        ));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Грешка при вчитување на описот')));
                      }
                    },
                    child: MealCard(meal: meal),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
