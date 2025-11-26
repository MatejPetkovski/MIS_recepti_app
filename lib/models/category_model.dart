class CategoryModel {
  final String id;
  final String category;
  final String thumbnail;
  final String desc;

  CategoryModel({
    required this.id,
    required this.category,
    required this.thumbnail,
    required this.desc,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['idCategory']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '',
      thumbnail: json['strCategoryThumb']?.toString() ?? '',
      desc: json['strCategoryDescription']?.toString() ?? '',
    );
  }
}
