class CategoryModel {
  final int id;
  final String name;
  final String? icon;
  final String? iconUrl;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  CategoryModel(
      {required this.id,
      required this.name,
      this.icon,
      this.iconUrl,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});

  static Future<CategoryModel> fromJson(Map<String, dynamic> json) async {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      iconUrl: json['icon_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}
