import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dyslexiapp/src/features/core/screens/dashboard/dashboard.dart';
import 'package:dyslexiapp/src/utils/helper/helper_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SpellingQuizScreen extends StatefulWidget {
  const SpellingQuizScreen({super.key});

  @override
  _SpellingQuizScreenState createState() => _SpellingQuizScreenState();
}

class _SpellingQuizScreenState extends State<SpellingQuizScreen> {
  String _text = '';
  int _progress = 0;
  int _score = 0;
  final int _totalQuestions = 10;
  late String _currentWord;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isWordVisible = true;

  @override
  void initState() {
    super.initState();
    _loadNextWord();
  }

  Future<void> _loadNextWord() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Spelling')
          .doc('word${_progress + 1}')
          .get();

      if (doc.exists) {
        setState(() {
          _currentWord = doc['word'];
          _isWordVisible = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No more words available')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load word: $e')),
      );
    }
  }

  void _validateAnswer() {
    if (_text.toLowerCase() == _currentWord.toLowerCase()) {
      Helper.successSnackBar(title: 'Correct! Good Job', message: 'Proceed to next question...');
      setState(() {
        _score++;
        _progress++;
      });
      if (_progress < _totalQuestions) {
        _loadNextWord();
      } else {
        _showQuizResult();
      }
    } else {
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
      _showQuizResult();
    }
  }

  Future<void> _showQuizResult() async {
    User? user = _auth.currentUser;

    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(user.uid);
      final userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        // Document exists, update quizScores array
        await userDoc.update({
          'quizScores': FieldValue.arrayUnion([
            {'score': _score, 'date': Timestamp.now()}
          ]),
        });
      } else {
        // Handle the case where the document does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User record not found.')),
        );
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(score: _score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Spelling Quiz",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _isWordVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _text = value;
                        });
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
            ),
            Expanded(
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

class QuizResultScreen extends StatelessWidget {
  final int score;
  const QuizResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Spelling Quiz Result",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),
            Image.asset(
              'assets/completion_image.png',
              height: 150,
            ),
            const Spacer(flex: 1),
            const Text(
              'Lesson Complete!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('TOTAL SCORE', '$score', Colors.orange),
                _buildStatCard('AMAZING', '100%', Colors.green),
              ],
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                onPressed: () => Get.to(() => const Dashboard()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
