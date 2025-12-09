import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import '../widgets/category_card.dart';
import 'meals_by_category.dart';
import 'details.dart';
import '../models/meal_detail_model.dart';
import 'favorites.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _api = ApiService();
  List<CategoryModel> _categories = [];
  List<CategoryModel> _filtered = [];
  bool _loading = true;
  bool _isRandomLoading = false;
  String _query = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _loading = true);
    try {
      final cats = await _api.getCategories();
      setState(() {
        _categories = cats;
        _filtered = cats;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Грешка при вчитување категории')));
    }
  }

  void _filter(String q) {
    setState(() {
      _query = q;
      if (q.isEmpty) {
        _filtered = _categories;
      } else {
        _filtered = _categories.where((c) {
          final name = c.category.toLowerCase();
          final desc = c.desc.toLowerCase();
          final ql = q.toLowerCase();
          return name.contains(ql) || desc.contains(ql);
        }).toList();
      }
    });
  }

  Future<void> _openRandomMeal() async {
    setState(() => _isRandomLoading = true);
    try {
      final meal = await _api.getRandomMeal();
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const DetailsPage(),
        settings: RouteSettings(arguments: meal),
      ));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Грешка при вчитување рандом рецепт')));
    } finally {
      if (mounted) setState(() => _isRandomLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Рецепти'),
        actions: [
          IconButton(
            onPressed: _isRandomLoading ? null : _openRandomMeal,
            icon: const Icon(Icons.book),
            tooltip: 'Рандом рецепт на денот',
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
            tooltip: 'Омилени рецепти',
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Пребарувај категории',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _filter,
            ),
          ),
          Expanded(
            child: _filtered.isEmpty && _query.isNotEmpty
                ? Center(child: Text('Не се пронајдени категории за "$_query"'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final c = _filtered[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MealsByCategoryScreen(category: c.category),
                    ));
                  },
                  child: CategoryCard(category: c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
