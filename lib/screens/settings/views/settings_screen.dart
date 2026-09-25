import 'package:expense_repository/expense_repository.dart';
import 'package:my_expense_tracker/screens/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:my_expense_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:my_expense_tracker/screens/settings/blocs/settings_cubit/settings_cubit.dart';
import 'package:my_expense_tracker/screens/settings/blocs/settings_cubit/settings_state.dart';
import 'package:my_expense_tracker/services/export_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final List<Map<String, String>> _currencies = const [
    {'symbol': '\$', 'name': 'USD - US Dollar'},
    {'symbol': '€', 'name': 'EUR - Euro'},
    {'symbol': '£', 'name': 'GBP - British Pound'},
    {'symbol': '₦', 'name': 'NGN - Nigerian Naira'},
    {'symbol': '¥', 'name': 'JPY - Japanese Yen'},
    {'symbol': '₹', 'name': 'INR - Indian Rupee'},
    {'symbol': 'C\$', 'name': 'CAD - Canadian Dollar'},
    {'symbol': 'A\$', 'name': 'AUD - Australian Dollar'},
    {'symbol': 'R\$', 'name': 'BRL - Brazilian Real'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, authState) {
                      final user = authState.user;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                child: Text(
                                  (user != null && user.name.isNotEmpty)
                                      ? user.name[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (user != null && user.name.isNotEmpty)
                                          ? user.name
                                          : 'User',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      (user != null && user.email.isNotEmpty)
                                          ? user.email
                                          : 'No email logged',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<UserRepository>().logOut();
                                },
                                icon: const Icon(
                                  CupertinoIcons.arrow_right_square,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'Sign Out',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Preferred Currency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: _currencies.map((c) {
                          final isSelected =
                              settingsState.currencySymbol == c['symbol'];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            leading: Text(
                              c['symbol']!,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            title: Text(
                              c['name']!,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  )
                                : null,
                            onTap: () => context
                                .read<SettingsCubit>()
                                .updateCurrency(c['symbol']!),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'App Appearance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          _ThemeTile(
                            icon: CupertinoIcons.device_phone_portrait,
                            label: 'System Default',
                            mode: ThemeMode.system,
                            current: settingsState.themeMode,
                          ),
                          _ThemeTile(
                            icon: CupertinoIcons.sun_max,
                            label: 'Light Mode',
                            mode: ThemeMode.light,
                            current: settingsState.themeMode,
                          ),
                          _ThemeTile(
                            icon: CupertinoIcons.moon,
                            label: 'Dark Mode',
                            mode: ThemeMode.dark,
                            current: settingsState.themeMode,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Data & Export',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.doc_text,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        'Export Transactions (CSV)',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        'Save or share CSV report of all expenses',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        final getExpensesState = context
                            .read<GetExpensesBloc>()
                            .state;
                        final expenses =
                            (getExpensesState is GetExpensesSuccess)
                            ? getExpensesState.expenses
                            : <Expense>[];
                        ExportService.exportTransactionsToCsv(
                          context: context,
                          expenses: expenses,
                          currencySymbol: settingsState.currencySymbol,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'Expense Tracker v1.0.0',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeMode mode;
  final ThemeMode current;

  const _ThemeTile({
    required this.icon,
    required this.label,
    required this.mode,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final selected = current == mode;
    return ListTile(
      leading: Icon(
        icon,
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: selected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () => context.read<SettingsCubit>().updateThemeMode(mode),
    );
  }
}
