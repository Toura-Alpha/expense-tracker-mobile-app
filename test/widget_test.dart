// Smoke tests for the expense tracker app.
//
// These tests exercise pure, Firebase-independent logic so they run without a
// live backend. Anything that touches Firebase is covered by bloc tests with
// fake repositories instead of widget tests.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter_test/flutter_test.dart';

Category _category({String name = 'Food'}) => Category(
      categoryId: 'cat-1',
      name: name,
      totalExpenses: 0,
      icon: 'food',
      color: 0xFFFFC107,
    );

Expense _expense({
  required double amount,
  bool isIncome = false,
  DateTime? date,
}) =>
    Expense(
      expenseId: 'exp-1',
      amount: amount,
      category: _category(),
      date: date ?? DateTime(2026, 1, 15),
      isIncome: isIncome,
      note: 'Groceries',
    );

void main() {
  group('Expense', () {
    test('round-trips through entity without losing data', () {
      final original = _expense(amount: 42.5);
      final restored = Expense.fromEntity(original.toEntity());

      expect(restored.expenseId, original.expenseId);
      expect(restored.amount, original.amount);
      expect(restored.isIncome, original.isIncome);
      expect(restored.note, original.note);
      expect(restored.date, original.date);
      expect(restored.category.name, original.category.name);
    });

    test('survives serialization to and from a Firestore document map', () {
      final original = _expense(amount: 12.75);
      final document = original.toEntity().toDocument();

      // Firestore stores DateTime as a Timestamp, so mirror that on the way in.
      document['date'] = Timestamp.fromDate(original.date);

      final restored =
          Expense.fromEntity(ExpenseEntity.fromDocument(document));

      expect(restored.amount, 12.75);
      expect(restored.date, original.date);
      expect(restored.category.color, original.category.color);
    });

    test('defaults isIncome to false for a plain expense', () {
      expect(_expense(amount: 10).isIncome, isFalse);
    });
  });

  group('Category', () {
    test('round-trips through entity', () {
      final original = _category(name: 'Travel');
      final restored = Category.fromEntity(original.toEntity());

      expect(restored.name, 'Travel');
      expect(restored.icon, 'food');
      expect(restored.color, 0xFFFFC107);
    });

    test('empty returns a fresh instance each call', () {
      // Regression: `empty` used to be a `static final` singleton that callers
      // mutated in place, corrupting the "no category selected" sentinel.
      expect(identical(Category.empty, Category.empty), isFalse);
    });

    test('mutating a copy of empty leaves Category.empty intact', () {
      final draft = Category.empty;
      draft.name = 'Dining';
      draft.categoryId = 'cat-99';
      draft.budgetLimit = 250;

      expect(Category.empty.name, isEmpty);
      expect(Category.empty.categoryId, isEmpty);
      expect(Category.empty.budgetLimit, 0.0);
      expect(Category.empty, isNot(draft));
    });

    test('compares by value so the empty sentinel check still works', () {
      expect(Category.empty, Category.empty);
      expect(Category.empty, isNot(_category()));
    });
  });

  group('Expense.empty', () {
    test('returns a fresh instance so ids can be assigned safely', () {
      final a = Expense.empty;
      final b = Expense.empty;
      a.expenseId = 'exp-a';
      a.amount = 10;

      expect(b.expenseId, isEmpty);
      expect(b.amount, 0.0);
    });

    test('copy() is independent of the original', () {
      final original = _expense(amount: 30);
      final duplicate = original.copy();
      duplicate.amount = 99;
      duplicate.isIncome = true;

      expect(original.amount, 30);
      expect(original.isIncome, isFalse);
      expect(duplicate.expenseId, original.expenseId);
    });
  });
}
