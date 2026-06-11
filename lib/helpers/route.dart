import 'package:get/get.dart';
import '../hostPages/widgets/host_bottom_nav.dart';
import '../views/Feature/Driver/account/account_screen.dart';
import '../views/Feature/Driver/account/notification_screen.dart';
import '../views/Feature/Driver/account/common/contact_us_screen.dart';
import '../views/Feature/Driver/account/common/faq_screen.dart';
import '../views/Feature/Driver/account/common/help_support_screen.dart';
import '../views/Feature/Driver/account/common/privacy_policy_screen.dart';
import '../views/Feature/Driver/account/common/terms_condition_screen.dart';
import '../views/Feature/Driver/account/switchToHost/switch_to_host.dart';
import '../views/Feature/Driver/bookings/bookings_screen.dart';
import '../views/Feature/Driver/bookings/booking_chat_screen.dart';
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
import '../hostPages/screens/account_page.dart';
import '../hostPages/screens/account_settings_page.dart';
import '../hostPages/screens/add_withdrawal_account_page.dart';
import '../hostPages/screens/contact_us_page.dart';
import '../hostPages/screens/faq_page.dart';
import '../hostPages/screens/help_support_page.dart';
import '../hostPages/screens/homepage.dart';
import '../hostPages/screens/invite_friend_page.dart';
import '../hostPages/screens/manual_requests_page.dart';
import '../hostPages/screens/parking_qr_screen.dart';
import '../hostPages/screens/parking_spaces_page.dart';
import '../hostPages/screens/prices_page.dart';
import '../hostPages/screens/privacy_policy_page.dart';
import '../hostPages/screens/profile_info_page.dart';
import '../hostPages/screens/publish_parking_details_page.dart';
import '../hostPages/screens/publish_parking_page.dart';
import '../hostPages/screens/publish_parking_photos_page.dart';
import '../hostPages/screens/publish_parking_prices_page.dart';
import '../hostPages/screens/publish_parking_review_page.dart';
import '../hostPages/screens/publish_parking_submitted_page.dart';
import '../hostPages/screens/publish_parking_services_page.dart';
import '../hostPages/screens/publish_parking_spaces_page.dart';
import '../hostPages/screens/terms_condition_page.dart';
import '../hostPages/screens/withdrawal_page.dart';

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
  static const String bookingChatScreen = "/booking_chat_screen";
  static const String scanningScreen = "/scanning_screen";
  static const String extendTimeScreen = "/extend_time_screen";
  static const String checkoutScreen = "/checkout_screen";
  static const String favoritesScreen = "/favorites_screen";
  static const String accountScreen = "/account_screen";
  static const String notificationScreen = "/notification_screen";
  static const String vehiclesScreen = "/vehicles";
  static const String addVehicleScreen = "/vehicles/add";
  static const String editVehicleScreen = "/vehicles/edit";
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
  static const String hostHomeScreen = "/hosthome";
  static const String hostBottomNavScreen = "/host_bottom_nav";
  static const String switchToHostScreen = "/switch_to_host";

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: verificationCodeScreen, page: () => VerificationCodeScreen()),
    GetPage(
      name: setNewPasswordScreen,
      page: () => const SetNewPasswordScreen(),
    ),
    GetPage(
      name: emailVerificationScreen,
      page: () => EmailVerificationScreen(),
    ),
    GetPage(name: bottomNavScreen, page: () => const BottomNavScreen()),
    GetPage(name: exploreScreen, page: () => const ExploreScreen()),
    GetPage(
      name: parkingDetailsScreen,
      page: () => const ParkingDetailsScreen(),
    ),
    GetPage(name: confirmPayScreen, page: () => const ConfirmPayScreen()),
    GetPage(
      name: bookingConfirmedScreen,
      page: () => const BookingConfirmedScreen(),
    ),
    GetPage(name: bookingsScreen, page: () => const BookingsScreen()),
    GetPage(name: bookingChatScreen, page: () => const BookingChatScreen()),
    GetPage(name: scanningScreen, page: () => const ScanningScreen()),
    GetPage(name: extendTimeScreen, page: () => const ExtendTimeScreen()),
    GetPage(
      name: checkoutScreen,
      page: () => CheckoutScreen(totalSeconds: Get.arguments as int),
    ),
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
    GetPage(
      name: accountSettingsScreen,
      page: () => const AccountSettingsScreen(),
    ),
    GetPage(name: privacyPolicyScreen, page: () => const PrivacyPolicyScreen()),
    GetPage(
      name: termsConditionScreen,
      page: () => const TermsConditionScreen(),
    ),
    GetPage(name: helpSupportScreen, page: () => const HelpSupportScreen()),
    GetPage(name: faqScreen, page: () => const FaqScreen()),
    GetPage(name: contactUsScreen, page: () => const ContactUsScreen()),
    GetPage(name: hostHomeScreen, page: () => const HostDashboardPage()),
    GetPage(name: '/account', page: () => const AccountPage()),
    GetPage(name: '/account-settings', page: () => const AccountSettingsPage()),
    GetPage(
      name: '/add-withdrawal-account',
      page: () => const AddWithdrawalAccountPage(),
    ),
    GetPage(
      name: '/alerts',
      page: () => const HostBottomNavScreen(initialIndex: 4),
    ),
    GetPage(name: '/contact-us', page: () => const ContactUsPage()),
    GetPage(name: '/faq', page: () => const FaqPage()),
    GetPage(name: '/help-support', page: () => const HelpSupportPage()),
    GetPage(name: '/invite-friend', page: () => const InviteFriendPage()),
    GetPage(name: '/qr_page', page: () => const ParkingQrScreen()),
    GetPage(name: '/manual', page: () => const ManualRequestsPage()),
    GetPage(
      name: '/parking-spaces',
      page: () => const HostBottomNavScreen(initialIndex: 1),
    ),
    GetPage(
      name: '/parking-spaces-config',
      page: () => const ParkingSpacesConfigPage(),
    ),
    GetPage(
      name: '/prices-by-section',
      page: () => const HostBottomNavScreen(initialIndex: 3),
    ),
    GetPage(name: '/prices-global', page: () => const PricesGlobalPage()),
    GetPage(name: '/privacy-policy', page: () => const PrivacyPolicyPage()),
    GetPage(name: '/profile-info', page: () => const ProfileInfoPage()),
    GetPage(
      name: '/services',
      page: () => const HostBottomNavScreen(initialIndex: 2),
    ),
    GetPage(name: '/publish-parking', page: () => const PublishParkingPage()),
    GetPage(
      name: '/publish-parking-details',
      page: () => const PublishParkingDetailsPage(),
    ),
    GetPage(
      name: '/publish-parking-photos',
      page: () => const PublishParkingPhotosPage(),
    ),
    GetPage(
      name: '/publish-parking-prices',
      page: () => const PublishParkingPricesPage(),
    ),
    GetPage(
      name: '/publish-parking-review',
      page: () => const PublishParkingReviewPage(),
    ),
    GetPage(
      name: '/publish-parking-submitted',
      page: () => const PublishParkingSubmittedPage(),
    ),
    GetPage(
      name: '/publish-parking-services',
      page: () => const PublishParkingServicesPage(),
    ),
    GetPage(
      name: '/publish-parking-spaces',
      page: () => const PublishParkingSpacesPage(),
    ),
    GetPage(name: '/terms-condition', page: () => const TermsConditionPage()),
    GetPage(name: '/withdrawals', page: () => const IncomeWithdrawalsPage()),
    GetPage(
      name: hostBottomNavScreen,
      page: () {
        final tab = Get.arguments is int ? Get.arguments as int : 0;
        return HostBottomNavScreen(initialIndex: tab);
      },
    ),
    GetPage(name: switchToHostScreen, page: () => const SwitchToHostScreen()),
  ];
}
