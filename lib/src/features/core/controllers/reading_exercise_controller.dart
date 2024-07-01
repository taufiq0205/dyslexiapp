import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:dyslexiapp/src/features/core/screens/exercise/spelling/spelling_exercise.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:dyslexiapp/src/utils/helper/helper_controller.dart';

class ReadingExerciseController extends GetxController {
  late stt.SpeechToText _speech;
  var isListening = false.obs;
  var text = ''.obs;
  var progress = 0.obs;
  final totalQuestions = 10;
  var currentWord = ''.obs;
  final FlutterTts flutterTts = FlutterTts();
  var speechRate = 0.5.obs;
  var isWordVisible = true.obs;
  var isWordBlurred = false.obs;

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
    loadNextWord();
  }

  Future<void> loadNextWord() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('ReadingExercise')
          .doc('word${progress.value + 1}')
          .get();

      if (doc.exists) {
        currentWord.value = doc['word'];
        isWordVisible.value = true;
        isWordBlurred.value = false;

        Timer(const Duration(seconds: 3), () {
          isWordVisible.value = false;
          isWordBlurred.value = true;
        });
      } else {
        // Handle the case when the document does not exist
        Get.snackbar('Error', 'No more words available');
      }
    } catch (e) {
      // Handle any other errors
      Get.snackbar('Error', 'Failed to load word: $e');
    }
  }

  void startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      isListening.value = true;
      _speech.listen(
        onResult: (result) {
          text.value = result.recognizedWords;
        },
      );
    }
  }

  void stopListening() {
    _speech.stop();
    isListening.value = false;
  }

  void validateAnswer() {
    if (text.value.toLowerCase() == currentWord.value.toLowerCase()) {
      // Show Correct! snackbar
      Helper.successSnackBar(
          title: 'Correct!', message: 'Proceed with next question');
      progress.value++;
      if (progress.value < totalQuestions) {
        loadNextWord();
      } else {
        showExerciseResult();
      }
    } else {
      // Show Try Again snackbar
      Helper.errorSnackBar(
          title: 'Try Again', message: 'Try to pronounce the word slowly.');
    }
    text.value = '';
  }

  void skipWord() {
    progress.value++;
    if (progress.value < totalQuestions) {
      loadNextWord();
    } else {
      showExerciseResult();
    }
  }

  void stopListeningAndValidate() {
    stopListening();
    validateAnswer();
  }

  Future<void> showExerciseResult() async {
    Get.to(ExerciseResultScreen());
  }

  Future<void> speak() async {
    await flutterTts.setSpeechRate(speechRate.value);
    await flutterTts.speak(currentWord.value);
  }

  void showSpeechRateDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Adjust Speech Rate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Speech Rate:'),
            Obx(
              () => Slider(
                value: speechRate.value,
                onChanged: (value) {
                  speechRate.value = value;
                },
                min: 0.1,
                max: 1.0,
                divisions: 10,
                label: speechRate.value.toString(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
