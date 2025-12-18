import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _amountController.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void onCreate() {
    //  1 Build an expense
    if (_titleController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty)
      // Show error
      return;

    final newExpense = Expense(
      title: _titleController.text,
      amount: double.tryParse(_amountController.text) ?? 0,
      date: _selectedDate,
      category: _selectedCategory,
    );
    Navigator.pop(context, newExpense);
  }

  void onCancel() {
    // Close the modal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat.yMd().format(_selectedDate);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Title"),
            maxLength: 50,
          ),

          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount"),
          ),

          const SizedBox(height: 10),

          // CATEGORY DROPDOWN
          DropdownButton<Category>(
            value: _selectedCategory,
            isExpanded: true,
            items: Category.values.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(cat.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),

          const SizedBox(height: 10),

          // DATE PICKER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date: $dateFormatted"),
              IconButton(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onCancel,
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCreate,
                  child: const Text("Create"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
