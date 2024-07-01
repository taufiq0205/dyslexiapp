import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dyslexiapp/src/utils/helper/helper_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_auth/firebase_auth.dart';

class ReadingQuizScreen extends StatefulWidget {
  const ReadingQuizScreen({super.key});

  @override
  _ReadingQuizScreenState createState() => _ReadingQuizScreenState();
}

class _ReadingQuizScreenState extends State<ReadingQuizScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  int _progress = 0;
  int _score = 0;
  final int _totalQuestions = 10;
  late String _currentWord;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterTts _flutterTts = FlutterTts();
  double _speechRate = 0.5;
  bool _isWordVisible = true;
  bool _isWordBlurred = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadNextWord();
  }

  Future<void> _loadNextWord() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Reading')
          .doc('word${_progress + 1}')
          .get();

      if (doc.exists) {
        setState(() {
          _currentWord = doc['word'];
          _isWordVisible = true;
          _isWordBlurred = false;
        });

        Timer(const Duration(seconds: 3), () {
          setState(() {
            _isWordVisible = false;
            _isWordBlurred = true;
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

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) => setState(() {
          _text = result.recognizedWords;
        }),
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _validateAnswer() {
    if (_text.toLowerCase() == _currentWord.toLowerCase()) {
      // Show Correct! snackbar
      Helper.successSnackBar(
          title: 'Correct!', message: 'Proceed with next question');
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
      // Show Try Again snackbar
      Helper.errorSnackBar(
          title: 'Try Again', message: 'Try to pronounce the word slowly.');
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

  void _stopListeningAndValidate() {
    _stopListening();
    _validateAnswer();
  }

  Future<void> _showQuizResult() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Update the existing user document with quiz score
      final userDoc =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);

      try {
        DocumentSnapshot userSnapshot = await userDoc.get();

        if (userSnapshot.exists) {
          // User document exists, update it
          await userDoc.update({
            'quizScores': FieldValue.arrayUnion([
              {'score': _score, 'date': Timestamp.now()}
            ]),
          });
        } else {
          // User document does not exist, create it
          await userDoc.set({
            'quizScores': [
              {'score': _score, 'date': Timestamp.now()}
            ]
          });
        }

        // Navigate to the quiz result screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizResultScreen(score: _score),
          ),
        );
      } catch (error) {
        // Handle any errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save quiz result: $error')),
        );
      }
    }
  }

  Future<void> _speak() async {
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.speak(_currentWord);
  }

  void _showSpeechRateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adjust Speech Rate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Speech Rate:'),
              Slider(
                value: _speechRate,
                onChanged: (value) {
                  setState(() {
                    _speechRate = value;
                  });
                },
                min: 0.1,
                max: 1.0,
                divisions: 10,
                label: _speechRate.toString(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
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
          "Reading Quiz",
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
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
                    Visibility(
                      visible: _isWordBlurred,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock, size: 40.0),
                            Text(
                              _currentWord,
                              style: const TextStyle(
                                fontSize: 24.0,
                                color: Colors.transparent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTapDown: (details) {
                      _startListening();
                    },
                    onTapUp: (details) {
                      _stopListeningAndValidate();
                    },
                    child: CircleAvatar(
                      radius: 40.0,
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        size: 40.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Tap then Speak', textAlign: TextAlign.center),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: _showSpeechRateDialog,
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: _speak,
                  ),
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
    final height = MediaQuery.of(context).size.height;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Reading Quiz Result",
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
              'Your Score: $score',
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
