import 'package:expense_repository/expense_repository.dart';
import 'package:my_expense_tracker/screens/auth/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:my_expense_tracker/screens/auth/views/welcome_screen.dart';
import 'package:my_expense_tracker/screens/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:my_expense_tracker/screens/settings/blocs/settings_cubit/settings_cubit.dart';
import 'package:my_expense_tracker/screens/settings/blocs/settings_cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'screens/home/views/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Expense Tracker",
          themeMode: settings.themeMode,
          // ── Light Theme ──────────────────────────────────────────────
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00B2E7),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xFF00B2E7),
              secondary: const Color(0xFFE064F7),
              tertiary: const Color(0xFFFF8D6C),
              surface: const Color(0xFFF5F7FB),
              surfaceContainerHighest: const Color(0xFFEAF1F8),
              onSurface: const Color(0xFF1A2433),
              outline: const Color(0xFF7D8AA5),
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F7FB),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 0,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF00B2E7), width: 1.5),
              ),
            ),
            textTheme: ThemeData.light().textTheme.apply(
              bodyColor: const Color(0xFF1A2433),
              displayColor: const Color(0xFF1A2433),
            ),
            dividerColor: const Color(0xFFD9E2EC),
          ),
          // ── Dark Theme ───────────────────────────────────────────────
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00B2E7),
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFF5BC8FF),
              secondary: const Color(0xFFE8A5FF),
              tertiary: const Color(0xFFFFB39B),
              surface: const Color(0xFF111827),
              surfaceContainerHighest: const Color(0xFF1F2937),
              onSurface: const Color(0xFFE5ECF7),
              outline: const Color(0xFF9AA8BD),
            ),
            scaffoldBackgroundColor: const Color(0xFF111827),
            cardTheme: CardThemeData(
              color: const Color(0xFF1F2937),
              elevation: 0,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            inputDecorationTheme: InputDecorationTheme(
              fillColor: const Color(0xFF1F2937),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF5BC8FF), width: 1.5),
              ),
            ),
            textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: const Color(0xFFE5ECF7),
              displayColor: const Color(0xFFE5ECF7),
            ),
            dividerColor: const Color(0xFF394B63),
          ),
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state.status == AuthenticationStatus.authenticated) {
                return BlocProvider(
                  create: (context) =>
                      GetExpensesBloc(FirebaseExpenseRepo())
                        ..add(GetExpenses()),
                  child: const HomeScreen(),
                );
              } else {
                return WelcomeScreen(context.read<UserRepository>());
              }
            },
          ),
        );
      },
    );
  }
}
