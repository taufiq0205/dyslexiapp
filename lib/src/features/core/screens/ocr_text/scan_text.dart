import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dyslexiapp/src/features/core/controllers/scan_text_controller.dart';
import 'package:dyslexiapp/src/constants/text_strings.dart';

class ScanText extends StatelessWidget {
  const ScanText({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScanTextController());
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tScan, style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: Obx(() {
        if (controller.isPermissionGranted.value) {
          return Stack(
            children: [
              if (controller.isCameraInitialized.value)
                Center(child: CameraPreview(controller.cameraController!)),
              Column(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        bottom: 30.0, left: 20.0, right: 20.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => controller.scanImage(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: const Text('Scan text'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Center(
            child: Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: const Text(
                'Camera permission denied',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }),
    );
  }
}
