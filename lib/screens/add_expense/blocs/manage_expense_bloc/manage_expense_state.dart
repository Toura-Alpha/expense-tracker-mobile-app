part of 'manage_expense_bloc.dart';

sealed class ManageExpenseState extends Equatable {
  const ManageExpenseState();
  
  @override
  List<Object?> get props => [];
}

final class ManageExpenseInitial extends ManageExpenseState {}
final class ManageExpenseLoading extends ManageExpenseState {}
final class DeleteExpenseSuccess extends ManageExpenseState {}
final class UpdateExpenseSuccess extends ManageExpenseState {}
final class ManageExpenseFailure extends ManageExpenseState {
  final String? message;
  const ManageExpenseFailure({this.message});

  @override
  List<Object?> get props => [message];
}
