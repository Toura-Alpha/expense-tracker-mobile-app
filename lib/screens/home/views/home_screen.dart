import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:my_expense_tracker/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:my_expense_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:my_expense_tracker/screens/add_expense/views/add_expense.dart';
import 'package:my_expense_tracker/screens/budget/views/budget_planner_screen.dart';
import 'package:my_expense_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:my_expense_tracker/screens/home/views/main_screen.dart';
import 'package:my_expense_tracker/screens/settings/views/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import '../../stats/stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if (state is GetExpensesSuccess) {
          Widget currentBody;
          if (index == 0) {
            currentBody = MainScreen(state.expenses);
          } else if (index == 1) {
            currentBody = BlocProvider(
              create: (context) =>
                  GetCategoriesBloc(FirebaseExpenseRepo())
                    ..add(GetCategories()),
              child: BudgetPlannerScreen(expenses: state.expenses),
            );
          } else if (index == 2) {
            currentBody = StatScreen(state.expenses);
          } else {
            currentBody = const SettingsScreen();
          }

          return Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: SizedBox(
                height: 72,
                child: BottomAppBar(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: const CircularNotchedRectangle(),
                  notchMargin: 10,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavItem(
                          icon: CupertinoIcons.home,
                          active: index == 0,
                          onTap: () => setState(() => index = 0),
                        ),
                        _NavItem(
                          icon: CupertinoIcons.briefcase_fill,
                          active: index == 1,
                          onTap: () => setState(() => index = 1),
                        ),
                        const SizedBox(width: 72),
                        _NavItem(
                          icon: CupertinoIcons.graph_square_fill,
                          active: index == 2,
                          onTap: () => setState(() => index = 2),
                        ),
                        _NavItem(
                          icon: CupertinoIcons.settings,
                          active: index == 3,
                          onTap: () => setState(() => index = 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: FloatingActionButton(
                onPressed: () async {
                  Expense? newExpense = await Navigator.push(
                    context,
                    MaterialPageRoute<Expense>(
                      builder: (BuildContext context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) =>
                                CreateCategoryBloc(FirebaseExpenseRepo()),
                          ),
                          BlocProvider(
                            create: (context) =>
                                GetCategoriesBloc(FirebaseExpenseRepo())
                                  ..add(GetCategories()),
                          ),
                          BlocProvider(
                            create: (context) =>
                                CreateExpenseBloc(FirebaseExpenseRepo()),
                          ),
                        ],
                        child: const AddExpense(),
                      ),
                    ),
                  );

                  if (newExpense != null && context.mounted) {
                    context.read<GetExpensesBloc>().add(GetExpenses());
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder(),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.tertiary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ],
                      transform: const GradientRotation(pi / 4),
                    ),
                  ),
                  child: const Icon(CupertinoIcons.add, size: 28),
                ),
              ),
            ),
            body: currentBody,
          );
        } else if (state is GetExpensesFailure) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.cloud,
                      size: 60,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Couldn't load your expenses",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Check your connection and try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () =>
                          context.read<GetExpensesBloc>().add(GetExpenses()),
                      icon: const Icon(CupertinoIcons.refresh),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(height: 48, child: Icon(icon, color: color, size: 24)),
      ),
    );
  }
}
