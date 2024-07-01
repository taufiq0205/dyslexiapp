import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dyslexiapp/src/constants/image_strings.dart';
import 'package:dyslexiapp/src/constants/text_strings.dart';
import 'package:dyslexiapp/src/features/core/controllers/flashcard_controller.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

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
          tFlashcard,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            ScreenRowAlphabet(
                image1: AssetImage(tAFlashcardImage),
                image2: AssetImage(tBFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tCFlashcardImage),
                image2: AssetImage(tDFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tEFlashcardImage),
                image2: AssetImage(tFFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tGFlashcardImage),
                image2: AssetImage(tHFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tIFlashcardImage),
                image2: AssetImage(tJFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tKFlashcardImage),
                image2: AssetImage(tLFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tMFlashcardImage),
                image2: AssetImage(tNFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tOFlashcardImage),
                image2: AssetImage(tPFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tQFlashcardImage),
                image2: AssetImage(tRFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tSFlashcardImage),
                image2: AssetImage(tTFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tUFlashcardImage),
                image2: AssetImage(tVFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tWFlashcardImage),
                image2: AssetImage(tXFlashcardImage),
              ),
              SizedBox(height: 5),
              ScreenRowAlphabet(
                image1: AssetImage(tYFlashcardImage),
                image2: AssetImage(tZFlashcardImage),
              ),
            
            
          ],),
        ),
      ),
    );
  }
}
