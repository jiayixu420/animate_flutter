import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scattered Boxes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScatteredBoxesScreen(),
    );
  }
}

class ScatteredBoxesScreen extends StatefulWidget {
  const ScatteredBoxesScreen({super.key});

  @override
  _ScatteredBoxesScreenState createState() => _ScatteredBoxesScreenState();
}

class _ScatteredBoxesScreenState extends State<ScatteredBoxesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<Offset> letterPositions = List.generate(10, (index) => const Offset(0, 0));
  bool isScattered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      isScattered = !isScattered;
    });

    if (isScattered) {
      _scatterAndGather();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _scatterAndGather() async {
    await scatterLetters();
    await _gatherLetters();
    await _returnLetters();
  }

  Future<void> scatterLetters() async {
    setState(() {
      letterPositions = List.generate(10, (index) {
        final random = Random();
        const scatterRange = 50;
        const originalPoint = Offset(0, 0);
        final dx = originalPoint.dx + random.nextInt(scatterRange * 2) - scatterRange;
        final dy = originalPoint.dy + random.nextInt(scatterRange * 2) - scatterRange;
        return Offset(dx.toDouble(), dy.toDouble());
      });
    });
    _animationController.reset();
    await _animationController.forward();
  }

  Future<void> _gatherLetters() async {
    setState(() {
      double initPositionX = MediaQuery.of(context).size.width / 2;
      double initPositionY = MediaQuery.of(context).size.height / 2;
      letterPositions = List.generate(10, (index) => Offset(initPositionX - 30, - (initPositionY - 10)));
    });
    _animationController.reset();
    await _animationController.forward();
  }

  Future<void> _returnLetters() async {
    setState(() {
      letterPositions = List.generate(10, (index) => const Offset(0, 0));
      isScattered = false;
    });
    _animationController.reset();
    await _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Animation',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "\$",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 30 ,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: ElevatedButton(
                onPressed: _toggleAnimation,
                child: const Text('Animate'),
              ),
            ),
            for (var i = 0; i < letterPositions.length; i++)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: MediaQuery.of(context).size.width / 2 + letterPositions[i].dx,
                top: MediaQuery.of(context).size.height / 2 + letterPositions[i].dy,
                child: const LetterWidget(),
              ),
          ],
        ),
      ),
    );
  }
}

class LetterWidget extends StatelessWidget {
  const LetterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 30,
      height: 30,
      child: Text(
        "\$",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
}
