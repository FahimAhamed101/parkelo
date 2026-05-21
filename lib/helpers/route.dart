import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../views/Feature/SplashScreen/splash_screen.dart';
import '../views/Feature/Authentication/login_screen.dart';

class AppRoutes {

  static const String splashScreen = "/splash_screen";
  static const String loginScreen = "/login_screen";


  static List<GetPage> routes = [

    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),

  ];
}