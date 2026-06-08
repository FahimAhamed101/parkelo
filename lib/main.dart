import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helpers/route.dart';
import 'utils/appColor/app_colors.dart';
import 'views/Feature/Authentication/bindings/auth_binding.dart';
import 'views/Feature/Authentication/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController(), permanent: true);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            initialBinding: AuthBinding(),
            transitionDuration: const Duration(milliseconds: 400),
            defaultTransition: Transition.rightToLeft,
            debugShowCheckedModeBanner: false,
            getPages: AppRoutes.routes,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.bg,
              textTheme: GoogleFonts.nunitoTextTheme(
                Theme.of(context).textTheme,
              ).apply(bodyColor: AppColors.text, displayColor: AppColors.text),
              appBarTheme: const AppBarTheme(
                toolbarHeight: 65,
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColors.bg,
                iconTheme: IconThemeData(color: AppColors.text),
              ),
            ),
            initialRoute: AppRoutes.splashScreen,
          );
        },
      ),
    );
  }
}
