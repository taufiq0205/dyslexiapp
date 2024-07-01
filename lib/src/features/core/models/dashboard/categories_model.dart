import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dyslexiapp/src/features/core/screens/flashcard/flashcard.dart';
import 'package:dyslexiapp/src/features/core/screens/ocr_text/scan_text.dart';

class DashboardCategoriesModel{
  final String title;
  final String heading;
  final String subHeading;
  final VoidCallback? onPress;

  DashboardCategoriesModel(this.title, this.heading, this.subHeading, this.onPress);

  static List<DashboardCategoriesModel> list = [
    DashboardCategoriesModel("JS", "Scan Text", "View through the lens", () => Get.to(() => const ScanText())),
    DashboardCategoriesModel("F", "Flashcards", "A to Z", () => Get.to(() => const FlashcardScreen())),
    
  ];
}