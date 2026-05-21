import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../views/Feature/Driver/account/account_screen.dart';
import '../views/Feature/Driver/bookings/bookings_screen.dart';
import '../views/Feature/Driver/bottom_nav/bottom_nav.dart';
import '../views/Feature/Driver/favorites/favorites_screen.dart';
import '../views/Feature/SplashScreen/splash_screen.dart';
import '../views/Feature/Authentication/login_screen.dart';
import '../views/Feature/Driver/explore/explore_screen.dart';
import '../views/Feature/Driver/explore/parking_details_screen.dart';

class AppRoutes {

  static const String splashScreen = "/splash_screen";
  static const String loginScreen = "/login_screen";
  static const String bottomNavScreen = "/bottom_nav";
  static const String exploreScreen = "/explore_screen";
  static const String parkingDetailsScreen = "/parking_details_screen";
  static const String bookingsScreen = "/bookings_screen";
  static const String favoritesScreen = "/favorites_screen";
  static const String accountScreen = "/account_screen";


  static List<GetPage> routes = [

    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: bottomNavScreen, page: () => const BottomNavScreen()),
    GetPage(name: exploreScreen, page: () => const ExploreScreen()),
    GetPage(name: parkingDetailsScreen, page: () => const ParkingDetailsScreen()),
    GetPage(name: bookingsScreen, page: () => const BookingsScreen()),
    GetPage(name: favoritesScreen, page: () => const FavoritesScreen()),
    GetPage(name: accountScreen, page: () => const AccountScreen()),

  ];
}