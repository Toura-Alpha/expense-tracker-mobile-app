class CategoryEntity {
  String categoryId;
  String name;
  int totalExpenses;
  String icon;
  int color;
  double budgetLimit;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
    this.budgetLimit = 0.0,
  });

  Map<String, Object?> toDocument() {
    return {
      'categoryId': categoryId,
      'name': name,
      'totalExpenses': totalExpenses,
      'icon': icon,
      'color': color,
      'budgetLimit': budgetLimit,
    };
  }

  static CategoryEntity fromDocument(Map<String, dynamic> doc) {
    return CategoryEntity(
      categoryId: doc['categoryId'],
      name: doc['name'],
      totalExpenses: doc['totalExpenses'],
      icon: doc['icon'],
      color: doc['color'],
      budgetLimit: (doc['budgetLimit'] as num?)?.toDouble() ?? 0.0,
    );
  }
}