import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import '../../../utils/appColor/app_colors.dart';
import '../../../helpers/route.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _scheduleNavigation(const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _scheduleNavigation(Duration delay) {
    _navigationTimer?.cancel();
    _navigationTimer = Timer(delay, () {
      if (!mounted) return;
      Get.offAllNamed(AppRoutes.loginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueNav,
      body: SizedBox.expand(
        child: RiveWidgetBuilder(
          fileLoader: FileLoader.fromAsset(
            'assets/images/parkealo_intro.riv',
            riveFactory: Factory.rive,
          ),
          artboardSelector: ArtboardSelector.byName('Artboard_Parkealo'),
          stateMachineSelector: StateMachineSelector.byName('Parkealo_SM'),
          onLoaded: (state) {
            state.controller.stateMachine.trigger('StartTrigger')?.fire();
            _scheduleNavigation(const Duration(seconds: 8));
          },
          onFailed: (error, stackTrace) {
            debugPrint('Splash Rive failed: $error');
            _scheduleNavigation(const Duration(seconds: 3));
          },
          builder: (context, state) {
            if (state is RiveLoaded) {
              return RiveWidget(
                controller: state.controller,
                fit: Fit.contain,
                alignment: Alignment.center,
              );
            }

            return const ColoredBox(
              color: AppColors.blueNav,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/parkealoAppIcon1.png'),
                  width: 160,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
