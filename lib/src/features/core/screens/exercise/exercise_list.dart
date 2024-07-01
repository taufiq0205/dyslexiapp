import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dyslexiapp/src/constants/text_strings.dart';
import 'package:dyslexiapp/src/features/core/screens/exercise/reading/reading_exercise.dart';
import 'package:dyslexiapp/src/features/core/screens/exercise/spelling/spelling_exercise.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key});

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  int selectedExercise = 0;

  List<dynamic> exercises = [
    {
      'image': 'assets/images/exercise/alphabet-a.png',
      'selected_image': 'assets/images/exercise/alphabet-a.png',
      'name': 'Alphabet A',
      'description': 'Reading Exercise: A',
      'onPress': () => Get.to(() => ReadingExerciseScreen())
    },
    {
      'image': 'assets/images/exercise/alphabet-b.png',
      'selected_image': 'assets/images/exercise/alphabet-b.png',
      'name': 'Alphabet B',
      'description': 'Spelling Exercise: B',
      'onPress': () => Get.to(() => const SpellingExerciseScreen())
    },
  ];

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text(tExerciseList,
              style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            IconButton(
                onPressed: () {},
                icon:
                    Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              FadeInDown(
                from: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Your Desired Exercises",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FadeInDown(
                from: 50,
                child: Text(
                  "What do you want to learn?",
                  style:
                      TextStyle(color: Colors.blueGrey.shade400, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedExercise = index;
                        });
                        exercises[index]['onPress']();
                      },
                      child: FadeInUp(
                        delay: Duration(milliseconds: index * 100),
                        child: AnimatedContainer(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: EdgeInsets.only(bottom: 20),
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: selectedExercise == index
                                      ? Colors.blue
                                      : Colors.white.withOpacity(0),
                                  width: 2),
                              boxShadow: [
                                selectedExercise == index
                                    ? BoxShadow(
                                        color: Colors.blue.shade100,
                                        offset: Offset(0, 3),
                                        blurRadius: 10)
                                    : BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: Offset(0, 3),
                                        blurRadius: 10)
                              ]),
                          child: Row(
                            children: [
                              selectedExercise == index
                                  ? Image.asset(
                                      exercises[index]['selected_image'],
                                      width: 50,
                                    )
                                  : Image.asset(
                                      exercises[index]['image'],
                                      width: 50,
                                    ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercises[index]['name'],
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      exercises[index]['description'],
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: selectedExercise == index
                                    ? Colors.blue
                                    : Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
