import 'package:fl_chart/fl_chart.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:my_expense_tracker/screens/settings/blocs/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPieChart extends StatefulWidget {
  final List<Expense> expenses;
  const CategoryPieChart({super.key, required this.expenses});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final expenseItems = widget.expenses.where((e) => !e.isIncome).toList();
    final double totalExpenses = expenseItems.fold(
      0.0,
      (sum, item) => sum + item.amount,
    );
    final currency = context.watch<SettingsCubit>().state.currencySymbol;

    if (expenseItems.isEmpty || totalExpenses == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No expense data available yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // Group expenses by category name
    final Map<String, CategoryGroupData> categoryGroups = {};
    for (var exp in expenseItems) {
      final name = exp.category.name;
      if (categoryGroups.containsKey(name)) {
        categoryGroups[name]!.totalAmount += exp.amount;
      } else {
        categoryGroups[name] = CategoryGroupData(
          category: exp.category,
          totalAmount: exp.amount,
        );
      }
    }

    final groupList = categoryGroups.values.toList();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 45,
              sections: List.generate(groupList.length, (i) {
                final isTouched = i == touchedIndex;
                final fontSize = isTouched ? 16.0 : 12.0;
                final radius = isTouched ? 60.0 : 50.0;
                final percentage =
                    (groupList[i].totalAmount / totalExpenses) * 100;

                return PieChartSectionData(
                  color: Color(groupList[i].category.color),
                  value: groupList[i].totalAmount,
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: groupList.map((group) {
            final percentage = (group.totalAmount / totalExpenses) * 100;
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Color(group.category.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    group.category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$currency${group.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${percentage.toStringAsFixed(1)}%)',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CategoryGroupData {
  final Category category;
  double totalAmount;

  CategoryGroupData({required this.category, required this.totalAmount});
}
