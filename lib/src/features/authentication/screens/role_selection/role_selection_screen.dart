import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dyslexiapp/src/features/authentication/screens/login/login_screen.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Before you continue...'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoleOption(
                  imagePath: 'assets/images/role_selection/students.png', // Add your image to assets
                  title: 'I am a student!',
                  subtitle: 'pew pew pew',
                  onTap: () => Get.to(() => const LoginScreen()),
                ),
                const SizedBox(height: 20),
                RoleOption(
                  imagePath: 'assets/images/role_selection/teacher.png', // Add your image to assets
                  title: 'I am a teacher!',
                  subtitle: 'Check your level here!',
                  onTap: () => Get.to(() => const LoginScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoleOption extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const RoleOption({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: constraints.maxWidth > 600 ? 250 : 200, // Responsive height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image(image: AssetImage(imagePath), height: 100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
