import 'package:get/get.dart';
import '../views/Feature/Driver/account/account_screen.dart';
import '../views/Feature/Driver/account/notification_screen.dart';
import '../views/Feature/Driver/account/common/contact_us_screen.dart';
import '../views/Feature/Driver/account/common/faq_screen.dart';
import '../views/Feature/Driver/account/common/help_support_screen.dart';
import '../views/Feature/Driver/account/common/privacy_policy_screen.dart';
import '../views/Feature/Driver/account/common/terms_condition_screen.dart';
import '../views/Feature/Driver/bookings/bookings_screen.dart';
import '../views/Feature/Driver/bookings/scanning_screen.dart';
import '../views/Feature/Driver/bookings/extend_time_screen.dart';
import '../views/Feature/Driver/bookings/checkout_screen.dart';
import '../views/Feature/Driver/bottom_nav/bottom_nav.dart';
import '../views/Feature/Driver/favorites/favorites_screen.dart';
import '../views/Feature/SplashScreen/splash_screen.dart';
import '../views/Feature/Authentication/forgot_password_screen.dart';
import '../views/Feature/Authentication/set_new_password_screen.dart';
import '../views/Feature/Authentication/verification_code_screen.dart';
import '../views/Feature/Authentication/login_screen.dart';
import '../views/Feature/Authentication/sign_up_screen.dart';
import '../views/Feature/Authentication/email_verification_screen.dart';
import '../views/Feature/Driver/explore/explore_screen.dart';
import '../views/Feature/Driver/explore/parking_details_screen.dart';
import '../views/Feature/Driver/explore/confirm_pay_screen.dart';
import '../views/Feature/Driver/explore/booking_confirmed_screen.dart';
import '../views/Feature/Driver/account/vehicles/vehicles_screen.dart';
import '../views/Feature/Driver/account/vehicles/add_vehicle_screen.dart';
import '../views/Feature/Driver/account/vehicles/edit_vehicle_screen.dart';
import '../views/Feature/Driver/account/payment/payment_screen.dart';
import '../views/Feature/Driver/account/profile/profile_info_screen.dart';
import '../views/Feature/Driver/account/profile/edit_profile_screen.dart';
import '../views/Feature/Driver/account/invite_friend/invite_friend_screen.dart';
import '../views/Feature/Driver/account/settings/account_settings_screen.dart';


class AppRoutes {

  static const String splashScreen = "/splash_screen";
  static const String loginScreen = "/login_screen";
  static const String signUpScreen = "/sign_up_screen";
  static const String forgotPasswordScreen = "/forgot_password_screen";
  static const String verificationCodeScreen = "/verification_code_screen";
  static const String setNewPasswordScreen = "/set_new_password_screen";
  static const String emailVerificationScreen = "/email_verification_screen";
  static const String bottomNavScreen = "/bottom_nav";
  static const String exploreScreen = "/explore_screen";
  static const String parkingDetailsScreen = "/parking_details_screen";
  static const String confirmPayScreen = "/confirm_pay_screen";
  static const String bookingConfirmedScreen = "/booking_confirmed_screen";
  static const String bookingsScreen = "/bookings_screen";
  static const String scanningScreen = "/scanning_screen";
  static const String extendTimeScreen = "/extend_time_screen";
  static const String checkoutScreen = "/checkout_screen";
  static const String favoritesScreen = "/favorites_screen";
  static const String accountScreen = "/account_screen";
  static const String notificationScreen = "/notification_screen";
  static const String vehiclesScreen = "/vehicles_screen";
  static const String addVehicleScreen = "/add_vehicle_screen";
  static const String editVehicleScreen = "/edit_vehicle_screen";
  static const String paymentScreen = "/payment_screen";
  static const String profileInfoScreen = "/profile_info_screen";
  static const String editProfileScreen = "/edit_profile_screen";
  static const String inviteFriendScreen = "/invite_friend_screen";
  static const String accountSettingsScreen = "/account_settings_screen";
  static const String privacyPolicyScreen = "/privacy_policy_screen";
  static const String termsConditionScreen = "/terms_condition_screen";
  static const String helpSupportScreen = "/help_support_screen";
  static const String faqScreen = "/faq_screen";
  static const String contactUsScreen = "/contact_us_screen";


  static List<GetPage> routes = [

    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: verificationCodeScreen, page: () => VerificationCodeScreen()),
    GetPage(name: setNewPasswordScreen, page: () => const SetNewPasswordScreen()),
    GetPage(name: emailVerificationScreen, page: () => EmailVerificationScreen()),
    GetPage(name: bottomNavScreen, page: () => const BottomNavScreen()),
    GetPage(name: exploreScreen, page: () => const ExploreScreen()),
    GetPage(name: parkingDetailsScreen, page: () => const ParkingDetailsScreen()),
    GetPage(name: confirmPayScreen, page: () => const ConfirmPayScreen()),
    GetPage(name: bookingConfirmedScreen, page: () => const BookingConfirmedScreen()),
    GetPage(name: bookingsScreen, page: () => const BookingsScreen()),
    GetPage(name: scanningScreen, page: () => const ScanningScreen()),
    GetPage(name: extendTimeScreen, page: () => const ExtendTimeScreen()),
    GetPage(name: checkoutScreen, page: () => CheckoutScreen(totalSeconds: Get.arguments as int)),
    GetPage(name: favoritesScreen, page: () => const FavoritesScreen()),
    GetPage(name: accountScreen, page: () => const AccountScreen()),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
    GetPage(name: vehiclesScreen, page: () => const VehiclesScreen()),
    GetPage(name: addVehicleScreen, page: () => const AddVehicleScreen()),
    GetPage(name: editVehicleScreen, page: () => const EditVehicleScreen()),
    GetPage(name: paymentScreen, page: () => const PaymentScreen()),
    GetPage(name: profileInfoScreen, page: () => const ProfileInfoScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(name: inviteFriendScreen, page: () => const InviteFriendScreen()),
    GetPage(name: accountSettingsScreen, page: () => const AccountSettingsScreen()),
    GetPage(name: privacyPolicyScreen, page: () => const PrivacyPolicyScreen()),
    GetPage(name: termsConditionScreen, page: () => const TermsConditionScreen()),
    GetPage(name: helpSupportScreen, page: () => const HelpSupportScreen()),
    GetPage(name: faqScreen, page: () => const FaqScreen()),
    GetPage(name: contactUsScreen, page: () => const ContactUsScreen()),

  ];
}