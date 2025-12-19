import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  ExpenseItem({super.key, required this.expense});

  final Expense expense;

  final formatter = DateFormat.yMd();

  String get expenseDate => formatter.format(expense.date);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${expense.amount.toStringAsPrecision(2)} \$"),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Expense.expenseIcon(expense.category)),
                ),
                Text(expenseDate),
              ],
            ),
          ],
        ),
      ),
    );
  }
}