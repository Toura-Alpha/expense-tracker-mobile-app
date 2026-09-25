import 'package:expense_repository/expense_repository.dart';
import 'package:my_expense_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:my_expense_tracker/screens/settings/blocs/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetPlannerScreen extends StatelessWidget {
  final List<Expense> expenses;
  const BudgetPlannerScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final expenseItems = expenses.where((e) => !e.isIncome).toList();
    final double totalSpent = expenseItems.fold(
      0.0,
      (sum, e) => sum + e.amount,
    );
    final currency = context.watch<SettingsCubit>().state.currencySymbol;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Monthly Budget Planner'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
        builder: (context, state) {
          if (state is GetCategoriesSuccess) {
            final categoriesWithBudget = state.categories
                .where((c) => c.budgetLimit > 0)
                .toList();
            final double totalBudget = categoriesWithBudget.fold(
              0.0,
              (sum, c) => sum + c.budgetLimit,
            );

            final overallProgress = totalBudget > 0
                ? (totalSpent / totalBudget).clamp(0.0, 1.0)
                : 0.0;
            final bool isOverallOverBudget =
                totalBudget > 0 && totalSpent > totalBudget;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Budget Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overall Monthly Budget',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$currency${totalSpent.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Limit: $currency${totalBudget.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: overallProgress,
                              minHeight: 10,
                              backgroundColor: Colors.white30,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isOverallOverBudget
                                    ? Colors.redAccent
                                    : Colors.greenAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Category Spending Caps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (categoriesWithBudget.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'No budget limits set yet. Add budget limits when creating categories!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: categoriesWithBudget.map((category) {
                          final categorySpent = expenseItems
                              .where((e) => e.category.name == category.name)
                              .fold(0.0, (sum, e) => sum + e.amount);

                          final ratio = (categorySpent / category.budgetLimit)
                              .clamp(0.0, 1.0);
                          final isOver = categorySpent > category.budgetLimit;
                          final isNearLimit =
                              !isOver &&
                              categorySpent >= (category.budgetLimit * 0.8);

                          Color progressColor = Colors.green;
                          if (isOver) {
                            progressColor = Colors.redAccent;
                          } else if (isNearLimit) {
                            progressColor = Colors.orangeAccent;
                          }

                          return Card(
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: Color(category.color),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'assets/${category.icon}.png',
                                          scale: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        category.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (isOver)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const Text(
                                            'Over Budget!',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      else
                                        Text(
                                          '$currency${categorySpent.toStringAsFixed(0)} / $currency${category.budgetLimit.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: ratio,
                                      minHeight: 8,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        progressColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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
    );
  }
}
