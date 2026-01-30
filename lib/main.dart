import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Form',
      debugShowCheckedModeBanner: false,
      home: const MiniFormPage(),
    );
  }
}

class MiniFormPage extends StatefulWidget {
  const MiniFormPage({super.key});

  @override
  State<MiniFormPage> createState() => _MiniFormPageState();
}

class _MiniFormPageState extends State<MiniFormPage> {
  // controllers for the input fields
  final nameController = TextEditingController();
  final messageController = TextEditingController();

  // key for form validation
  final formKey = GlobalKey<FormState>();

  // values to show in preview
  String name = '';
  String message = '';
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          name = nameController.text;
                          message = messageController.text;
                          isSubmitted = true;
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (isSubmitted)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Name: $name'),
                      const SizedBox(height: 4),
                      Text('Message: $message'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
