import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:viska_erp_mobile/pages/splashscreen.dart';
import 'theme/colors.dart';
import 'firebase_options.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Viska Drywall',
      theme: ThemeData(
        primaryColor: AppColor.primary,
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
}
