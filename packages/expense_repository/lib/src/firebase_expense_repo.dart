import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  CollectionReference<Map<String, dynamic>> get _categoryCollection {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && userId.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('categories');
    }
    return FirebaseFirestore.instance.collection('categories');
  }

  CollectionReference<Map<String, dynamic>> get _expenseCollection {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && userId.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('expenses');
    }
    return FirebaseFirestore.instance.collection('expenses');
  }

  @override
  Future<void> createCategory(Category category) async {
    try {
      await _categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      return await _categoryCollection.get().then((value) => value.docs
          .map((e) =>
              Category.fromEntity(CategoryEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      await _expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      return await _expenseCollection.get().then((value) => value.docs
          .map((e) =>
              Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    try {
      await _expenseCollection
          .doc(expense.expenseId)
          .update(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _expenseCollection.doc(expenseId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}