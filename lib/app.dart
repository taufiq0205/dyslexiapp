import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dyslexiapp/src/utils/app_bindings.dart';
import 'package:dyslexiapp/src/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

