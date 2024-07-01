import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dyslexiapp/src/constants/image_strings.dart';
import 'package:dyslexiapp/src/features/core/screens/reading_quiz/reading_quiz.dart';
import 'package:dyslexiapp/src/features/core/screens/spelling_quiz/spelling_quiz.dart';

class DashboardTopCoursesModel {
  final String title;
  final String heading;
  final String subHeading;
  final String image;
  final VoidCallback? onPress;

  DashboardTopCoursesModel(
      this.title, this.heading, this.subHeading, this.image, this.onPress);

  static List<DashboardTopCoursesModel> list = [
    DashboardTopCoursesModel(
        "Reading Quiz: Part 1",
        "10 Questions",
        "Speak the words!",
        tTopCourseImage1,
        () => Get.to(() => const ReadingQuizScreen())),
    DashboardTopCoursesModel(
        "Spelling Quiz: Part 1",
        "10 Questions",
        "Spell the words!",
        tTopCourseImage1,
        () => Get.to(() => SpellingQuizScreen())),
  ];
}
