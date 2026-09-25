import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'manage_expense_event.dart';
part 'manage_expense_state.dart';

class ManageExpenseBloc extends Bloc<ManageExpenseEvent, ManageExpenseState> {
  final ExpenseRepository expenseRepository;

  ManageExpenseBloc(this.expenseRepository) : super(ManageExpenseInitial()) {
    on<DeleteExpense>((event, emit) async {
      emit(ManageExpenseLoading());
      try {
        await expenseRepository.deleteExpense(event.expenseId);
        emit(DeleteExpenseSuccess());
      } catch (e) {
        emit(ManageExpenseFailure(message: e.toString()));
      }
    });

    on<UpdateExpense>((event, emit) async {
      emit(ManageExpenseLoading());
      try {
        await expenseRepository.updateExpense(event.expense);
        emit(UpdateExpenseSuccess());
      } catch (e) {
        emit(ManageExpenseFailure(message: e.toString()));
      }
    });
  }
}
