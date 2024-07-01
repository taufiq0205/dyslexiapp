import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dyslexiapp/src/features/core/controllers/reading_exercise_controller.dart';

class ReadingExerciseScreen extends StatelessWidget {
  ReadingExerciseScreen({Key? key}) : super(key: key);

  final ReadingExerciseController controller =
      Get.put(ReadingExerciseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Reading Exercise",
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
                    Obx(
                      () => AnimatedOpacity(
                        opacity: controller.isWordVisible.value ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            controller.currentWord.value,
                            style: const TextStyle(fontSize: 24.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible: controller.isWordBlurred.value,
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
                                controller.currentWord.value,
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
                      controller.startListening();
                    },
                    onTapUp: (details) {
                      controller.stopListeningAndValidate();
                    },
                    child: Obx(
                      () => CircleAvatar(
                        radius: 40.0,
                        child: Icon(
                          controller.isListening.value
                              ? Icons.mic
                              : Icons.mic_none,
                          size: 40.0,
                        ),
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
                    onPressed: controller.showSpeechRateDialog,
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: controller.speak,
                  ),
                  Obx(() => Text(
                      '${controller.progress.value} / ${controller.totalQuestions}')),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: controller.skipWord,
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
