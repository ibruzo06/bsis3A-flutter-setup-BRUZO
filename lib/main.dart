import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

// ── Home ──
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _expenses = [];

  Future<void> _addExpense() async {
    final title = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AddPage()),
    );
    if (title != null && mounted) {
      setState(() => _expenses.add(title));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added: $title')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Expenses')),
        body: _expenses.isEmpty
            ? const Center(child: Text('No expenses yet!'))
            : ListView(
                children: _expenses
                    .map((e) => ListTile(leading: const Icon(Icons.receipt), title: Text(e)))
                    .toList(),
              ),
        floatingActionButton: Tooltip(
          message: 'Add Expense',         // 👈 shows on long-press or hover
          child: FloatingActionButton(
            onPressed: _addExpense,
            child: const Icon(Icons.add),
          ),
        ),
      );
}

// ── Add Expense ──
class AddPage extends StatefulWidget {
  const AddPage({super.key});
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _controller = TextEditingController();

  void _save() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title!')),
      );
      return;
    }
    Navigator.pop(context, title);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Add Expense')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Expense title'),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ]),
        ),
      );
}