import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final String currencySymbol;
  final ThemeMode themeMode;

  const SettingsState({
    this.currencySymbol = '\$',
    this.themeMode = ThemeMode.system,
  });

  SettingsState copyWith({
    String? currencySymbol,
    ThemeMode? themeMode,
  }) {
    return SettingsState(
      currencySymbol: currencySymbol ?? this.currencySymbol,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [currencySymbol, themeMode];
}
