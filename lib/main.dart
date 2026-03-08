import 'package:flutter/material.dart';

// ── Model ──────────────────────────────────────────────────────────────────────

class Expense {
  final String title;
  final double amount;
  final String date;

  const Expense({required this.title, required this.amount, required this.date});
}

// ── Dummy Data ─────────────────────────────────────────────────────────────────

final List<Expense> _dummyExpenses = [
  Expense(title: 'Coffee', amount: 80, date: 'Mar 1'),
  Expense(title: 'Groceries', amount: 350, date: 'Mar 3'),
  Expense(title: 'Grab Ride', amount: 120, date: 'Mar 7'),
  Expense(title: 'Netflix', amount: 199, date: 'Mar 10'),
  Expense(title: 'Electricity Bill', amount: 1200, date: 'Mar 12'),
];

// ── Part A: ExpenseItem Widget ─────────────────────────────────────────────────

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  const ExpenseItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.receipt_long, color: Colors.white, size: 20),
        ),
        title: Text(expense.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(expense.date,
            style: const TextStyle(color: Colors.grey)),
        trailing: Text(
          '₱${expense.amount.toStringAsFixed(2)}',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.deepPurple),
        ),
      ),
    );
  }
}

// ── Part C: Empty State ────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text('No expenses yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Tap + to add one', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Total Banner ───────────────────────────────────────────────────────────────

class TotalBanner extends StatelessWidget {
  final double total;
  const TotalBanner({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFDDD9F3),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Expenses',
            style: TextStyle(
              fontSize: 13,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₱${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Part B: ExpenseListScreen ──────────────────────────────────────────────────

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> _expenses = [];

  double get _total => _expenses.fold(0, (sum, e) => sum + e.amount);

  void _addExpense() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (₱)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final amount = double.tryParse(amountCtrl.text.trim());
              if (title.isEmpty || amount == null) return;
              setState(() => _expenses.add(Expense(
                    title: title,
                    amount: amount,
                    date: 'Mar ${_expenses.length + 1}',
                  )));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _expenses.isEmpty
          ? const EmptyState()
          : Column(
              children: [
                // Total banner — matches the screenshot
                TotalBanner(total: _total),
                // List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _expenses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                    itemBuilder: (_, index) =>
                        ExpenseItem(expense: _expenses[index]),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Entry Point ────────────────────────────────────────────────────────────────

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseListScreen(),
    ));