import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dyslexiapp/src/utils/helper/helper_controller.dart';

class SpellingExerciseScreen extends StatefulWidget {
  const SpellingExerciseScreen({super.key});

  @override
  _SpellingExerciseScreenState createState() => _SpellingExerciseScreenState();
}

class _SpellingExerciseScreenState extends State<SpellingExerciseScreen> {
  String _text = '';
  int _progress = 0;
  final int _totalQuestions = 10;
  late String _currentWord;
  bool _isWordVisible = true;

  @override
  void initState() {
    super.initState();
    _loadNextWord();
  }

  Future<void> _loadNextWord() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('SpellingExercise')
          .doc('word${_progress + 1}')
          .get();

      if (doc.exists) {
        setState(() {
          _currentWord = doc['word'];
          _isWordVisible = true;
        });

        Timer(const Duration(seconds: 3), () {
          setState(() {
            _isWordVisible = false;
          });
        });
      } else {
        // Handle the case when the document does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No more words available')),
        );
      }
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load word: $e')),
      );
    }
  }

  void _validateAnswer() {
    if (_text.toLowerCase() == _currentWord.toLowerCase()) {
      // Show Correct! snackbar
      Helper.successSnackBar(title: 'Correct! Good Job', message: 'Proceed to next question...');
      setState(() {
        _progress++;
      });
      if (_progress < _totalQuestions) {
        _loadNextWord();
      } else {
        _showExerciseResult();
      }
    } else {
      // Show Try Again snackbar
      Helper.errorSnackBar(title: 'Try Again', message: 'Take your time to see the spelled words');
    }
    setState(() {
      _text = '';
    });
  }

  void _skipWord() {
    setState(() {
      _progress++;
    });
    if (_progress < _totalQuestions) {
      _loadNextWord();
    } else {
      _showExerciseResult();
    }
  }

  Future<void> _showExerciseResult() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExerciseResultScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Spelling Exercise",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 6,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _isWordVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _currentWord,
                      style: const TextStyle(fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (value) {
                      _text = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type your answer here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _validateAnswer,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$_progress / $_totalQuestions'),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: _skipWord,
                      child: const Text('SKIP'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Exercise Result",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Exercise Completed',
              style: const TextStyle(fontSize: 32.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}