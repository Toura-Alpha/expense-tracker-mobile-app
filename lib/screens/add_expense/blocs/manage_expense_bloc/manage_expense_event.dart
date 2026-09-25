part of 'manage_expense_bloc.dart';

sealed class ManageExpenseEvent extends Equatable {
  const ManageExpenseEvent();

  @override
  List<Object?> get props => [];
}

class DeleteExpense extends ManageExpenseEvent {
  final String expenseId;

  const DeleteExpense(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}

class UpdateExpense extends ManageExpenseEvent {
  final Expense expense;

  const UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}
