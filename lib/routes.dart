import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:librarian_frontend/pages/pages.dart';

// class Routes {
//   static const String libraryScreen = '/library';
//   static const String loginScreen = '/login';
//   static const String signUpScreen = '/signup';
//   static const String forgotPasswordScreen = '/forgotpass';
//   static const String introScreen = '/intro';

//   static const String libraryTitle = 'Library';
//   static const String loginTitle = 'Login';
//   static const String signupTitle = 'Sign Up';
//   static const String forgotPasswordTitle = 'Forgot Password';
//   static const String introTitle = 'Intro';

//   static MaterialPageRoute<dynamic> buildRoute(
//     final RouteSettings settings,
//     final Widget builder,
//   ) =>
//       MaterialPageRoute<dynamic>(
//         settings: settings,
//         builder: (final BuildContext context) => builder,
//       );

//   static Map<String, dynamic> buildRoutes(final Store<GlobalAppState> store) =>
//       <String, dynamic>{
//         Routes.libraryScreen: (final BuildContext context) =>
//             const LibraryScreen(),
//         Routes.loginScreen: (final BuildContext context) => const LoginScreen(),
//         Routes.signUpScreen: (final BuildContext context) =>
//             const SignUpScreen(),
//         Routes.introScreen: (final BuildContext context) => const IntroScreen(),
//         Routes.forgotPasswordScreen: (final BuildContext context) =>
//             const ForgotPasswordScreen(),
//       };
// }

class RouteNames {
  static const String loginScreen = '/login';
}

class Routes {
  static List<GetPage<dynamic>> getPages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: RouteNames.loginScreen,
      page: () => const LoginScreen(),
    ),
    // GetPage<dynamic>(
    //   name: DashboardScreen.routeName,
    //   page: () => const DashboardScreen(),
    // ),
    // GetPage<dynamic>(
    //   name: LibraryScreen.routeName,
    //   page: () => const LibraryScreen(),
    // ),
    // GetPage<dynamic>(
    //   name: SettingsScreen.routeName,
    //   page: () => const SettingsScreen(),
    // ),
    // GetPage<dynamic>(
    //   name: ShoppingListScreen.routeName,
    //   page: () => const ShoppingListScreen(),
    // ),
    // GetPage<dynamic>(
    //   name: RegisterScreen.routeName,
    //   page: () => const RegisterScreen(),
    // ),
  ];
}
