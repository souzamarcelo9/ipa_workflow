import 'dart:async';

import 'package:viska_erp_mobile/app/modules/auth/store/auth_store.dart';
import 'package:viska_erp_mobile/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../pages/splashscreen.dart';
import '../../../../theme/colors.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final controller = Modular.get<AuthStore>();

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 30), () => print(''));
    controller.verifyLoggedUser();

  }

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
    //return const Scaffold(
        //body: Center(child: CircularProgressIndicator(color: purple)));
  }
}
