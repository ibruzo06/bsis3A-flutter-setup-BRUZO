import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int step = 0; // 0 = start, 1 = quiz, 2 = end
  int index = 0;
  int selected = -1;
  int score = 0;
  String feedback = "";

  final List<Map<String, dynamic>> questions = [
    {
      "q": "Which feature would help Ana’s Sari-Sari Store in Batangas City?",
      "a": [
        "Inventory alerts",
        "Music player",
        "Photo editor",
        "Flashlight"
      ],
      "c": 0,
    },
    {
      "q": "What feature helps a salon manage customer schedules?",
      "a": [
        "Appointment booking",
        "Calculator",
        "Alarm clock",
        "Wallpaper"
      ],
      "c": 0,
    },
    {
      "q": "What app feature helps customers send feedback to a café?",
      "a": [
        "Customer feedback form",
        "Game mode",
        "Photo filter",
        "Music player"
      ],
      "c": 0,
    },
    {
      "q": "What feature helps a repair shop organize customers?",
      "a": [
        "Queue number system",
        "Weather forecast",
        "Chat stickers",
        "Flashlight"
      ],
      "c": 0,
    },
    {
      "q": "What feature helps a delivery business accept orders?",
      "a": [
        "Delivery requests",
        "Photo gallery",
        "Clock widget",
        "Calculator"
      ],
      "c": 0,
    },
  ];

  void startQuiz() {
    setState(() {
      step = 1;
      index = 0;
      selected = -1;
      score = 0;
      feedback = "";
    });
  }

  void chooseAnswer(int i) {
    if (selected != -1) return;

    setState(() {
      selected = i;
      if (i == questions[index]["c"]) {
        score++;
        feedback = "Correct ✅";
      } else {
        feedback = "Wrong ❌";
      }
    });

    // Auto next question
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        selected = -1;
        feedback = "";
        if (index < questions.length - 1) {
          index++;
        } else {
          step = 2;
        }
      });
    });
  }

  void restart() {
    setState(() {
      step = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                color: Colors.black12,
              )
            ],
          ),
          child: buildContent(),
        ),
      ),
    );
  }

  Widget buildContent() {
    // START VIEW
    if (step == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Business Quiz",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: startQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Start Quiz"),
          ),
        ],
      );
    }

    // QUIZ VIEW
    if (step == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Question ${index + 1} / ${questions.length}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            questions[index]["q"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          for (int i = 0; i < 4; i++)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed:
                    selected == -1 ? () => chooseAnswer(i) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selected == -1
                      ? Colors.indigo.shade50
                      : i == questions[index]["c"]
                          ? Colors.green
                          : i == selected
                              ? Colors.red
                              : Colors.grey.shade300,
                  foregroundColor:
                      selected == -1 ? Colors.indigo : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(questions[index]["a"][i]),
              ),
            ),

          const SizedBox(height: 10),

          Text(
            feedback,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: feedback.contains("Correct")
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      );
    }

    // END VIEW
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Finished 🎉",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Score: $score / ${questions.length}",
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: restart,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text("Restart"),
        ),
      ],
    );
  }
}