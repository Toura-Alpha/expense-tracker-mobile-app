import 'dart:io';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  static Future<void> exportTransactionsToCsv({
    required BuildContext context,
    required List<Expense> expenses,
    required String currencySymbol,
  }) async {
    if (expenses.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No transactions available to export.')),
        );
      }
      return;
    }

    try {
      final buffer = StringBuffer();
      // CSV Header
      buffer.writeln('ID,Date,Time,Type,Category,Amount,Currency,Note');

      for (final e in expenses) {
        final id = _escapeCsv(e.expenseId);
        final date = DateFormat('yyyy-MM-dd').format(e.date);
        final time = DateFormat('HH:mm').format(e.date);
        final type = e.isIncome ? 'Income' : 'Expense';
        final category = _escapeCsv(e.category.name);
        final amount = e.amount.toStringAsFixed(2);
        final currency = _escapeCsv(currencySymbol);
        final note = _escapeCsv(e.note ?? '');

        buffer.writeln('$id,$date,$time,$type,$category,$amount,$currency,$note');
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/expenses_export_$timestamp.csv';
      final file = File(filePath);

      await file.writeAsString(buffer.toString());

      final xFile = XFile(filePath);
      await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          text: 'Exported Expenses CSV (${expenses.length} records)',
          subject: 'Expense Tracker Export',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export CSV: $e')),
        );
      }
    }
  }

  static String _escapeCsv(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      final escaped = field.replaceAll('"', '""');
      return '"$escaped"';
    }
    return field;
  }
}
