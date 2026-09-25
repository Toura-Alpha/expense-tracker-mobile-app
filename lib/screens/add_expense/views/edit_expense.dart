import 'package:expense_repository/expense_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_expense_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:my_expense_tracker/screens/add_expense/blocs/manage_expense_bloc/manage_expense_bloc.dart';
import 'package:my_expense_tracker/screens/add_expense/views/category_creation.dart';

class EditExpense extends StatefulWidget {
  final Expense initialExpense;
  const EditExpense({super.key, required this.initialExpense});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  late TextEditingController expenseController;
  late TextEditingController categoryController;
  late TextEditingController dateController;
  late TextEditingController noteController;
  late Expense expense;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Work on a copy: the original is held in the GetExpensesBloc state and
    // must not be mutated in place while the user is editing.
    expense = widget.initialExpense.copy();
    expenseController = TextEditingController(
      text: expense.amount.toStringAsFixed(2),
    );
    categoryController = TextEditingController(text: expense.category.name);
    dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(expense.date),
    );
    noteController = TextEditingController(text: expense.note ?? '');
  }

  @override
  void dispose() {
    expenseController.dispose();
    categoryController.dispose();
    dateController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ManageExpenseBloc, ManageExpenseState>(
      listener: (context, state) {
        if (state is UpdateExpenseSuccess) {
          Navigator.pop(context, true);
        } else if (state is ManageExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is ManageExpenseFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Failed to update transaction'),
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text("Edit Transaction"),
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 120,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment<bool>(
                              value: false,
                              label: Text('Expense'),
                              icon: Icon(
                                Icons.arrow_downward,
                                color: Colors.redAccent,
                              ),
                            ),
                            ButtonSegment<bool>(
                              value: true,
                              label: Text('Income'),
                              icon: Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                              ),
                            ),
                          ],
                          selected: {expense.isIncome},
                          onSelectionChanged: (Set<bool> newSelection) {
                            setState(() {
                              expense.isIncome = newSelection.first;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            controller: expenseController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.attach_money,
                                size: 16,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: categoryController,
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: expense.category == Category.empty
                                ? Colors.white
                                : Color(expense.category.color),
                            prefixIcon: expense.category == Category.empty
                                ? const Icon(
                                    Icons.list,
                                    size: 16,
                                    color: Colors.grey,
                                  )
                                : Image.asset(
                                    'assets/${expense.category.icon}.png',
                                    scale: 2,
                                  ),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                var newCategory = await getCategoryCreation(
                                  context,
                                );
                                if (newCategory != null && context.mounted) {
                                  context.read<GetCategoriesBloc>().add(
                                    GetCategories(),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            hintText: 'Category',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 180),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.categories.length,
                              itemBuilder: (context, int i) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        expense.category = state.categories[i];
                                        categoryController.text =
                                            expense.category.name;
                                      });
                                    },
                                    leading: Image.asset(
                                      'assets/${state.categories[i].icon}.png',
                                      scale: 2,
                                    ),
                                    title: Text(state.categories[i].name),
                                    tileColor: Color(state.categories[i].color),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: dateController,
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: expense.date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );

                            if (newDate != null) {
                              setState(() {
                                dateController.text = DateFormat(
                                  'dd/MM/yyyy',
                                ).format(newDate);
                                expense.date = newDate;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            hintText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: noteController,
                          minLines: 1,
                          maxLines: 3,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.note_alt_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            hintText: 'Note / Memo (Optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: kToolbarHeight,
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : TextButton(
                                  onPressed: () {
                                    final parsedAmount = double.tryParse(
                                      expenseController.text,
                                    );
                                    if (parsedAmount == null ||
                                        parsedAmount <= 0) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please enter a valid amount',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    final rawNote = noteController.text.trim();
                                    setState(() {
                                      expense.amount = parsedAmount;
                                      expense.note = rawNote.isNotEmpty
                                          ? rawNote
                                          : null;
                                    });

                                    context.read<ManageExpenseBloc>().add(
                                      UpdateExpense(expense),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Update Transaction',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
