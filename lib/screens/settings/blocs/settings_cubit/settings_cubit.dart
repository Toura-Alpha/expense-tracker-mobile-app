import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const String _currencyKey = 'currency_symbol';
  static const String _themeModeKey = 'theme_mode';

  SettingsCubit() : super(const SettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final symbol = prefs.getString(_currencyKey) ?? '\$';
    final themeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final mode = ThemeMode.values[themeIndex];

    emit(SettingsState(currencySymbol: symbol, themeMode: mode));
  }

  Future<void> updateCurrency(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, symbol);
    emit(state.copyWith(currencySymbol: symbol));
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }
}
