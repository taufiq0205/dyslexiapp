import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dyslexiapp/src/constants/colors.dart';
import 'package:dyslexiapp/src/features/core/screens/flashcard/flashcard.dart';
import 'package:dyslexiapp/src/features/core/screens/ocr_text/scan_text.dart';

class DashboardCategoriesModel {
  final String title;
  final String heading;
  final String subHeading;
  final VoidCallback? onPress;

  DashboardCategoriesModel(
      this.title, this.heading, this.subHeading, this.onPress);

  static List<DashboardCategoriesModel> list = [
    DashboardCategoriesModel("JS", "Scan Text", "View through the lens",
        () => Get.to(() => const ScanText())),
    DashboardCategoriesModel("F", "Flashcards", "A to Z",
        () => Get.to(() => const FlashcardScreen())),
  ];
}

class DashboardCategories extends StatelessWidget {
  const DashboardCategories({
    Key? key,
    required this.txtTheme,
  }) : super(key: key);

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    final list = DashboardCategoriesModel.list;
    return SizedBox(
      height: 45,
      child: ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => GestureDetector(
          onTap: list[index].onPress,
          child: SizedBox(
            width: 170,
            height: 45,
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: tDarkColor,
                  ),
                  child: Center(
                    child: Text(
                      list[index].title,
                      style: txtTheme.titleLarge?.apply(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: GestureDetector(
                    onTap: list[index].onPress,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          list[index].heading,
                          style: txtTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          list[index].subHeading,
                          style: txtTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
