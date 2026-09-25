import 'package:expense_repository/expense_repository.dart';
import 'package:my_expense_tracker/screens/settings/blocs/settings_cubit/settings_cubit.dart';
import 'package:my_expense_tracker/services/export_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'chart.dart';
import 'pie_chart.dart';

class StatScreen extends StatefulWidget {
  final List<Expense> expenses;
  const StatScreen(this.expenses, {super.key});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  int _selectedView = 0; // 0: Trend Bar Chart, 1: Category Breakdown
  DateTime _selectedMonth = DateTime.now();
  int _filterType = 0; // 0: All, 1: Expenses, 2: Income

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<SettingsCubit>().state.currencySymbol;

    // Filter transactions by selected month (Year + Month)
    final monthlyExpenses = widget.expenses.where((e) {
      return e.date.year == _selectedMonth.year &&
          e.date.month == _selectedMonth.month;
    }).toList();

    // Filter by type (All / Expense / Income)
    final filteredExpenses = monthlyExpenses.where((e) {
      if (_filterType == 1) return !e.isIncome;
      if (_filterType == 2) return e.isIncome;
      return true;
    }).toList();

    // Calculate totals for summary card
    final totalIncome = monthlyExpenses
        .where((e) => e.isIncome)
        .fold<double>(0.0, (sum, e) => sum + e.amount);
    final totalSpent = monthlyExpenses
        .where((e) => !e.isIncome)
        .fold<double>(0.0, (sum, e) => sum + e.amount);
    final netCashflow = totalIncome - totalSpent;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row ──────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Analytics',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          ExportService.exportTransactionsToCsv(
                            context: context,
                            expenses: filteredExpenses.isNotEmpty
                                ? filteredExpenses
                                : widget.expenses,
                            currencySymbol: currency,
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.share_up,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        tooltip: 'Export CSV',
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment<int>(
                            value: 0,
                            icon: Icon(CupertinoIcons.graph_square, size: 16),
                            label: Text('Trend'),
                          ),
                          ButtonSegment<int>(
                            value: 1,
                            icon: Icon(CupertinoIcons.chart_pie, size: 16),
                            label: Text('Categories'),
                          ),
                        ],
                        selected: {_selectedView},
                        onSelectionChanged: (Set<int> newSelection) {
                          setState(() {
                            _selectedView = newSelection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Month Picker & Filter Pills ──────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedMonth = DateTime(
                                _selectedMonth.year,
                                _selectedMonth.month - 1,
                              );
                            });
                          },
                        ),
                        InkWell(
                          onTap: () => _pickMonth(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Text(
                              DateFormat('MMMM yyyy').format(_selectedMonth),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedMonth = DateTime(
                                _selectedMonth.year,
                                _selectedMonth.month + 1,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Type Filter Pills
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterPill(
                    label: 'All',
                    isSelected: _filterType == 0,
                    onTap: () => setState(() => _filterType = 0),
                  ),
                  _FilterPill(
                    label: 'Expenses',
                    isSelected: _filterType == 1,
                    onTap: () => setState(() => _filterType = 1),
                  ),
                  _FilterPill(
                    label: 'Income',
                    isSelected: _filterType == 2,
                    onTap: () => setState(() => _filterType = 2),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Summary Card ─────────────────────────────────────────────
              _SummaryCard(
                totalIncome: totalIncome,
                totalSpent: totalSpent,
                netCashflow: netCashflow,
                currencySymbol: currency,
              ),
              const SizedBox(height: 16),

              // ── Chart Container ──────────────────────────────────────────
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).cardTheme.color ??
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withValues(alpha: 0.24)
                          : Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: filteredExpenses.isEmpty
                      ? const _EmptyState()
                      : (_selectedView == 0
                            ? SizedBox(
                                height: 280,
                                child: MyChart(
                                  expenses: filteredExpenses,
                                  selectedMonth: _selectedMonth,
                                ),
                              )
                            : CategoryPieChart(expenses: filteredExpenses)),
                ),
              ),
              const SizedBox(height: 24),

              // ── Top Transactions Header ──────────────────────────────────
              if (filteredExpenses.isNotEmpty) ...[
                Text(
                  'Top Transactions (${DateFormat('MMMM').format(_selectedMonth)})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ...filteredExpenses
                    .take(5)
                    .map((item) => _TopTransactionTile(item, currency)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
    }
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalSpent;
  final double netCashflow;
  final String currencySymbol;

  const _SummaryCard({
    required this.totalIncome,
    required this.totalSpent,
    required this.netCashflow,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardTheme.color ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: 12,
        spacing: 12,
        children: [
          _SummaryItem(
            label: 'Income',
            amount: totalIncome,
            color: Colors.green,
            currencySymbol: currencySymbol,
          ),
          Container(
            height: 30,
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          _SummaryItem(
            label: 'Spent',
            amount: totalSpent,
            color: Colors.redAccent,
            currencySymbol: currencySymbol,
          ),
          Container(
            height: 30,
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
          _SummaryItem(
            label: 'Net',
            amount: netCashflow,
            color: netCashflow >= 0 ? Colors.blue : Colors.orange,
            currencySymbol: currencySymbol,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final String currencySymbol;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$currencySymbol${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chart_bar,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 8),
          Text(
            'No transactions recorded\nfor this selection.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTransactionTile extends StatelessWidget {
  final Expense item;
  final String currency;

  const _TopTransactionTile(this.item, this.currency);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(item.category.color),
          child: Image.asset(
            'assets/${item.category.icon}.png',
            scale: 2,
            color: Colors.white,
          ),
        ),
        title: Text(
          item.category.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: item.note != null && item.note!.isNotEmpty
            ? Text(
                item.note!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              )
            : Text(
                DateFormat('dd MMM yyyy').format(item.date),
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
        trailing: Text(
          '${item.isIncome ? "+" : "-"}$currency${item.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: item.isIncome ? Colors.green : Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
