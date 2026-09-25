import '../entities/entities.dart';

class Category {
  String categoryId;
  String name;
  int totalExpenses;
  String icon;
  int color;
  double budgetLimit;

  Category({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
    this.budgetLimit = 0.0,
  });

  /// A blank category, returned fresh on every access.
  ///
  /// This is intentionally a getter rather than a `static final` field: callers
  /// used to mutate the shared instance in place, which corrupted the "no
  /// category selected" sentinel for the rest of the app session. Equality is
  /// value-based (see [operator ==]) so `category == Category.empty` still
  /// behaves as callers expect.
  static Category get empty => Category(
    categoryId: '',
    name: '',
    totalExpenses: 0,
    icon: '',
    color: 0,
    budgetLimit: 0.0,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          other.categoryId == categoryId &&
          other.name == name &&
          other.totalExpenses == totalExpenses &&
          other.icon == icon &&
          other.color == color &&
          other.budgetLimit == budgetLimit;

  @override
  int get hashCode =>
      Object.hash(categoryId, name, totalExpenses, icon, color, budgetLimit);

  @override
  String toString() => 'Category(categoryId: $categoryId, name: $name)';

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      totalExpenses: totalExpenses,
      icon: icon,
      color: color,
      budgetLimit: budgetLimit,
    );
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      categoryId: entity.categoryId,
      name: entity.name,
      totalExpenses: entity.totalExpenses,
      icon: entity.icon,
      color: entity.color,
      budgetLimit: entity.budgetLimit,
    );
  }
}