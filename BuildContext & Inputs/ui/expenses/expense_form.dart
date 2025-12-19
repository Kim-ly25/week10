import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.food;
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showWarning(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Warning'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool isValid() {
    String title = _titleController.text.trim();
    String amountText = _amountController.text.trim();
    double? amount = double.tryParse(amountText);

    if (title.isEmpty) {
      _showWarning("The title can not empty");
      return false;
    }

    if (amount == null || amount <= 0) {
      _showWarning("The amount must be valid");
      return false;
    }

    if (_selectedDate == null) {
      _showWarning("Please select a date.");
      return false;
    }

    return true;
  }

  void onCreate() {
    if (!isValid()) {
      return;
    }

    String title = _titleController.text.trim();
    double amount = double.parse(_amountController.text);

    Expense newExpense = Expense(
      title: title,
      amount: amount,
      date: _selectedDate ?? DateTime.now(),
      category: _selectedCategory,
    );
    Navigator.pop(context, newExpense);
  }

  void onCancel() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(label: Text("Amount")),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _selectedDate == null
                          ? "No Date Selected"
                          : "${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}",
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: _pickDate,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DropdownButton(
                  value: _selectedCategory,
                  isExpanded: true,
                  items: Category.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(Expense.expenseIcon(category)),
                          SizedBox(width: 8),
                          Text(category.name.toUpperCase()),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onCancel,
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: onCreate,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        padding: WidgetStateProperty.all(EdgeInsets.all(17)),
                      ),
                      child: Text(
                        "Save Expense",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
