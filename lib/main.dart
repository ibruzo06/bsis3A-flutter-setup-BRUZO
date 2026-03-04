import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseListPage(),
    ));

// ── Expense Model ──
class Expense {
  String title;
  double amount;
  Expense({required this.title, required this.amount});
}

// ── Screen 1: Expense List ──
class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});
  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  final List<Expense> _expenses = [
    Expense(title: 'Coffee', amount: 80),
    Expense(title: 'Groceries', amount: 350),
    Expense(title: 'Grab Ride', amount: 120),
  ];

  Future<void> _openAddScreen() async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditExpensePage()),
    );
    if (result != null && mounted) {
      setState(() => _expenses.add(result));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added: ${result.title}')),
      );
    }
  }

  Future<void> _openEditScreen(int index) async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditExpensePage(existing: _expenses[index]),
      ),
    );
    if (result != null && mounted) {
      setState(() => _expenses[index] = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated: ${result.title}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('My Expenses'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _expenses.length,
          itemBuilder: (context, index) {
            final e = _expenses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    '${index + 1}',   // 👈 number instead of broken icon
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '₱${e.amount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.deepPurple),
                ),
                trailing: const Icon(Icons.edit, color: Colors.grey),
                onTap: () => _openEditScreen(index),
              ),
            );
          },
        ),
        floatingActionButton: Tooltip(
          message: 'Add Expense',
          child: FloatingActionButton(
            onPressed: _openAddScreen,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        ),
      );
}

// ── Screen 2: Add / Edit Expense ──
class AddEditExpensePage extends StatefulWidget {
  final Expense? existing;
  const AddEditExpensePage({super.key, this.existing});
  @override
  State<AddEditExpensePage> createState() => _AddEditExpensePageState();
}

class _AddEditExpensePageState extends State<AddEditExpensePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _titleError;
  String? _amountError;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _titleController.text = widget.existing!.title;
      _amountController.text = widget.existing!.amount.toString();
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);

    setState(() {
      _titleError = title.isEmpty ? 'Title cannot be empty' : null;
      _amountError = amountText.isEmpty
          ? 'Amount cannot be empty'
          : (amount == null || amount <= 0)
              ? 'Enter a valid amount greater than 0'
              : null;
    });

    if (_titleError != null || _amountError != null) return;
    Navigator.pop(context, Expense(title: title, amount: amount!));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Expense' : 'Add Expense'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditMode ? 'Update your expense' : 'What did you spend on?',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Expense title',
                  errorText: _titleError,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  errorText: _amountError,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.payments_outlined),
                  prefixText: '₱ ',
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(_isEditMode ? 'Update' : 'Save'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      );
}