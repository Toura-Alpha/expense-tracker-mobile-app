import 'package:expense_repository/expense_repository.dart';

class Expense {
  String expenseId;
  Category category;
  DateTime date;
  double amount;
  bool isIncome;
  String? note;

  Expense({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
    this.isIncome = false,
    this.note,
  });

  /// A blank expense, returned fresh on every access.
  ///
  /// A getter rather than a `static final` field so that callers assigning
  /// fields onto it (e.g. generating an id on a new expense) do not mutate a
  /// shared global instance.
  static Expense get empty => Expense(
    expenseId: '',
    category: Category.empty,
    date: DateTime.now(),
    amount: 0.0,
    isIncome: false,
    note: null,
  );

  Expense copy() => Expense(
    expenseId: expenseId,
    category: category,
    date: date,
    amount: amount,
    isIncome: isIncome,
    note: note,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          other.expenseId == expenseId &&
          other.amount == amount &&
          other.isIncome == isIncome &&
          other.note == note &&
          other.date == date &&
          other.category == category;

  @override
  int get hashCode =>
      Object.hash(expenseId, amount, isIncome, note, date, category);

  @override
  String toString() => 'Expense(expenseId: $expenseId, amount: $amount)';

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      category: category,
      date: date,
      amount: amount,
      isIncome: isIncome,
      note: note,
    );
  }

  static Expense fromEntity(ExpenseEntity entity) {
    return Expense(
      expenseId: entity.expenseId,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
      isIncome: entity.isIncome,
      note: entity.note,
    );
  }
}