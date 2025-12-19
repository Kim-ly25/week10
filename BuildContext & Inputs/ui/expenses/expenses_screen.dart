import 'package:flutter/material.dart';
import '../../models/expense.dart';
import 'expense_form.dart';
import 'expense_item.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() {
    return _ExpensesScreenState();
  }
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void onAddClicked(BuildContext context) async {
    final newExpense = await showModalBottomSheet<Expense>(
      isScrollControlled: false,
      context: context,
      builder: (c) => const Center(child: ExpenseForm()),
    );

    if (newExpense == null) {
      return;
    }
    setState(() {
      _expenses.add(newExpense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => onAddClicked(context),
            icon: const Icon(Icons.add),
          ),
        ],
        backgroundColor: Colors.blue[700],
        title: const Text('Ronan-The-Best Expenses App'),
      ),
      body: _expenses.isEmpty
      ? const Center(child: Text("No expense found. Start adding some"))
      : Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 6),
              Expanded(
                child: ListView.builder(
                  itemCount: _expenses.length,
                  itemBuilder: (context, index) => Dismissible(
                    key: ValueKey(_expenses[index]),
                    onDismissed: (direction) {
                      setState(() {
                        _expenses.removeAt(index);
                      }); 
                      // message after remove
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Expense deleted")),
                      );
                    },
                    child: ExpenseItem(expense: _expenses[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
