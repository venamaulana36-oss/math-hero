import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MathHero());
}

class MathHero extends StatelessWidget {
  const MathHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final rand = Random();
  int soal = 1;
  int score = 0;
  int timeLeft = 5;
  Timer? timer;

  late int a, b, jawaban;
  late List<int> pilihan;

  @override
  void initState() {
    super.initState();
    buatSoal();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 5;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => timeLeft--);
      if (timeLeft == 0) next(false);
    });
  }

  void buatSoal() {
    a = rand.nextInt(10) + 1;
    b = rand.nextInt(10) + 1;
    jawaban = a * b;

    pilihan = {
      jawaban,
      jawaban + rand.nextInt(5) + 1,
      jawaban - rand.nextInt(5) - 1,
    }.toList()
      ..shuffle();
  }

  void next(bool benar) {
    timer?.cancel();
    if (benar) score += 10;

    if (soal == 10) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Selesai 🎉"),
          content: Text("Skor kamu: $score"),
        ),
      );
      return;
    }

    setState(() {
      soal++;
      buatSoal();
      startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Soal $soal / 10"),
            Text("Waktu: $timeLeft"),
            const SizedBox(height: 20),
            Text("$a × $b = ?", style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            ...pilihan.map(
              (e) => ElevatedButton(
                onPressed: () => next(e == jawaban),
                child: Text(e.toString()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
