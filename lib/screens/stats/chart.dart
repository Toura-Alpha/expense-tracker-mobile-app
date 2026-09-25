import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:my_expense_tracker/screens/settings/blocs/settings_cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyChart extends StatefulWidget {
  final List<Expense> expenses;
  final DateTime? selectedMonth;

  const MyChart({super.key, required this.expenses, this.selectedMonth});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  late List<double> dailyTotals;
  late List<DateTime> chartDays;
  double maxAmount = 100.0;

  @override
  void initState() {
    super.initState();
    _calculateChartData();
  }

  @override
  void didUpdateWidget(covariant MyChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expenses != widget.expenses ||
        oldWidget.selectedMonth != widget.selectedMonth) {
      _calculateChartData();
    }
  }

  void _calculateChartData() {
    if (widget.selectedMonth != null) {
      final year = widget.selectedMonth!.year;
      final month = widget.selectedMonth!.month;
      final daysInMonth = DateUtils.getDaysInMonth(year, month);

      chartDays = List.generate(
        daysInMonth,
        (i) => DateTime(year, month, i + 1),
      );
    } else {
      final now = DateTime.now();
      chartDays = List.generate(7, (i) {
        return DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: 6 - i));
      });
    }

    dailyTotals = chartDays.map((dayDate) {
      return widget.expenses
          .where(
            (e) =>
                e.date.year == dayDate.year &&
                e.date.month == dayDate.month &&
                e.date.day == dayDate.day,
          )
          .fold<double>(0.0, (sum, item) => sum + item.amount);
    }).toList();

    double highest = dailyTotals.fold(0.0, max);
    maxAmount = highest > 0 ? (highest * 1.2) : 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(mainBarData());
  }

  BarChartGroupData makeGroupData(int x, double y) {
    final double rodWidth = chartDays.length > 14
        ? 6.0
        : (chartDays.length > 7 ? 10.0 : 18.0);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            transform: const GradientRotation(pi / 40),
          ),
          width: rodWidth,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxAmount,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(
      chartDays.length,
      (i) => makeGroupData(i, dailyTotals[i]),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      maxY: maxAmount,
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: getTiles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 46,
            getTitlesWidget: leftTitles,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      barGroups: showingGroups(),
    );
  }

  Widget getTiles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    int index = value.toInt();
    if (index >= 0 && index < chartDays.length) {
      if (chartDays.length > 7 &&
          (index % 5 != 0) &&
          index != chartDays.length - 1) {
        return Container();
      }
      String dayLabel = chartDays.length <= 7
          ? DateFormat('E').format(chartDays[index])
          : DateFormat('d/M').format(chartDays[index]);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 8,
        child: Text(dayLabel, style: style),
      );
    }
    return Container();
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final currency = context.read<SettingsCubit>().state.currencySymbol;
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    if (value == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: Text('${currency}0', style: style),
      );
    } else if ((value - maxAmount / 2).abs() < (maxAmount / 4)) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: Text(
          '$currency${(maxAmount / 2).toStringAsFixed(0)}',
          style: style,
        ),
      );
    } else if ((value - maxAmount).abs() < (maxAmount / 10)) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: Text('$currency${maxAmount.toStringAsFixed(0)}', style: style),
      );
    }
    return Container();
  }
}
