import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class ResultScanController extends GetxController {
  var displayText = "".obs;
  var overlayColor = Rx<Color>(Colors.white);

  late FlutterTts flutterTts;

  @override
  void dispose() {
    // Stop the TTS engine when the controller is disposed
    flutterTts.stop();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    flutterTts = FlutterTts();
    _setVoice(); // Set the default voice when the controller initializes
  }

  void _setVoice() async {
  // Get available voices
  List<dynamic> voices = await flutterTts.getVoices;
  // Set a male adult voice as the default
  Map<String, String>? voice = voices.firstWhere(
    (voice) =>
        voice['locale'] == 'en-US' &&
        voice['name'].toString().contains('male') &&
        voice['name'].toString().toLowerCase().contains('adult'),
    orElse: () => null,
  ) as Map<String, String>?;
  print('Selected Voice: $voice');
  if (voice != null) {
    await flutterTts.setVoice(voice);
  }
}


  void updateText(String text, String format) {
    // Handle text formatting based on the provided format
    // For simplicity, assuming the text is already formatted
    displayText.value = text;
  }
void speak(String text) async {
    await flutterTts.setSpeechRate(0.3); // Adjust speech rate here (0.5 is slower)
    await flutterTts.speak(text);
  }
  void applyColorOverlay(String color) {
    // Apply color overlay to the text
    // For simplicity, assuming color overlay logic
    // based on the provided color
    overlayColor.value = _getColorFromName(color);
  }

  

  Color _getColorFromName(String colorName) {
    // Convert color name to Color object
    // For simplicity, assuming predefined colors
    switch (colorName) {
      case 'Green':
        return Colors.green.withOpacity(0.3);
      case 'Blue':
        return Colors.blue.withOpacity(0.3);
      case 'Yellow':
        return Colors.yellow.withOpacity(0.3);
      default:
        return Colors.white;
    }
  }
}
