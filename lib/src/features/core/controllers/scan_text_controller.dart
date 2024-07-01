import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:dyslexiapp/src/features/core/screens/ocr_text/result_scan.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanTextController extends GetxController with WidgetsBindingObserver {
  var isPermissionGranted = false.obs;
  CameraController? cameraController;
  final textRecognizer = TextRecognizer();
  final RxBool isCameraInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    isPermissionGranted.value = status == PermissionStatus.granted;
    if (isPermissionGranted.value) {
      final cameras = await availableCameras();
      _initCameraController(cameras);
    }
  }

  void _startCamera() {
    if (cameraController != null) {
      _cameraSelected(cameraController!.description);
    }
  }

  void _stopCamera() {
    cameraController?.dispose();
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await cameraController!.initialize();
    await cameraController!.setFlashMode(FlashMode.off);

    isCameraInitialized.value = true;
  }

  Future<void> scanImage(BuildContext context) async {
    if (cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);

      await navigator.push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ResultScan(text: recognizedText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }
}