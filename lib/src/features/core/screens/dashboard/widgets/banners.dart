import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dyslexiapp/src/features/core/screens/exercise/exercise_list.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/image_strings.dart';
import '../../../../../constants/text_strings.dart';
import 'package:dyslexiapp/src/constants/sizes.dart';

class DashboardBanners extends StatelessWidget {
  const DashboardBanners({
    Key? key,
    required this.txtTheme,
    required this.isDark,
  }) : super(key: key);

  final TextTheme txtTheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //1st banner
        Expanded(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              //For Dark Color
              color: isDark ? tSecondaryColor : tCardBgColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Image(image: AssetImage(tBookmarkIcon))),
                    Flexible(child: Image(image: AssetImage(tBannerImage1))),
                  ],
                ),
                const SizedBox(height: 25),
                Text(tDashboardBannerTitle1, style: txtTheme.headlineMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(tDashboardBannerSubTitle1, style: txtTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
        const SizedBox(width: tDashboardCardPadding),
        //2nd Banner
        Expanded(
          child: Column(
            children: [
              //Card
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  //For Dark Color
                  color: isDark ? tSecondaryColor : tCardBgColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Image(image: AssetImage(tBookmarkIcon))),
                        Flexible(child: Image(image: AssetImage(tBannerImage2))),
                      ],
                    ),
                    Text(tDashboardBannerTitle2, style: txtTheme.headlineMedium, overflow: TextOverflow.ellipsis),
                    Text(tDashboardBannerSubTitle2, style: txtTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: OutlinedButton(onPressed: () => Get.to(() => const ExerciseList()), child: const Text(tDashboardButton)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
