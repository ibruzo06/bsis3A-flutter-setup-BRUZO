import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ───────────────── MODEL ─────────────────

class Expense {
  String title;
  double amount;
  String date;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
  });
}

/// ─────────────── PROVIDER ────────────────

class ExpensesProvider extends ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(title: 'Coffee', amount: 80, date: 'Mar 1'),
    Expense(title: 'Groceries', amount: 350, date: 'Mar 3'),
  ];

  List<Expense> get expenses => _expenses;

  double get total =>
      _expenses.fold(0, (sum, item) => sum + item.amount);

  // CREATE
  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  // READ
  List<Expense> getExpenses() {
    return _expenses;
  }

  // UPDATE
  void editExpense(int index, Expense newExpense) {
    _expenses[index] = newExpense;
    notifyListeners();
  }

  // DELETE
  void deleteExpense(int index) {
    _expenses.removeAt(index);
    notifyListeners();
  }
}

/// ─────────────── MAIN APP ────────────────

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpensesProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseListScreen(),
    );
  }
}

/// ───────────── EXPENSE ITEM ──────────────

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final int index;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.receipt_long, color: Colors.white),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(expense.date),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₱${expense.amount}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Provider.of<ExpensesProvider>(context, listen: false)
                    .deleteExpense(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ───────────── EMPTY STATE ──────────────

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "No expenses yet",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

/// ───────────── TOTAL BANNER ─────────────

class TotalBanner extends StatelessWidget {
  final double total;

  const TotalBanner({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFDDD9F3),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Expenses',
            style: TextStyle(
              fontSize: 14,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₱${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}

/// ─────────── EXPENSE LIST SCREEN ─────────

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  void _addExpense(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              final title = titleCtrl.text;
              final amount = double.tryParse(amountCtrl.text) ?? 0;

              Provider.of<ExpensesProvider>(context, listen: false)
                  .addExpense(
                Expense(
                  title: title,
                  amount: amount,
                  date: "Mar",
                ),
              );

              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ExpensesProvider>(
        builder: (context, provider, child) {
          if (provider.expenses.isEmpty) {
            return const EmptyState();
          }

          return Column(
            children: [
              TotalBanner(total: provider.total),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.expenses.length,
                  itemBuilder: (context, index) {
                    return ExpenseItem(
                      expense: provider.expenses[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExpense(context),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}