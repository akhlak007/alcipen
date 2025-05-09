import 'package:flutter/material.dart';
import 'package:alcipen/screens/onboarding/splash_screen.dart';
import 'package:alcipen/screens/onboarding/role_selection_screen.dart';
import 'package:alcipen/screens/onboarding/seeker_onboarding_screen.dart';
import 'package:alcipen/screens/onboarding/writer_onboarding_screen.dart';
import 'package:alcipen/screens/seeker/seeker_home_screen.dart';
import 'package:alcipen/screens/seeker/writer_profile_screen.dart';
import 'package:alcipen/screens/seeker/schedule_handover_screen.dart';
import 'package:alcipen/screens/writer/writer_dashboard_screen.dart';
import 'package:alcipen/screens/writer/writer_profile_settings_screen.dart';
import 'package:alcipen/screens/shared/chat_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(),
    '/role-selection': (context) => const RoleSelectionScreen(),
    '/seeker-onboarding': (context) => const SeekerOnboardingScreen(),
    '/writer-onboarding': (context) => const WriterOnboardingScreen(),
    '/seeker-home': (context) => const SeekerHomeScreen(),
    '/writer-profile': (context) => const WriterProfileScreen(),
    '/schedule-handover': (context) => const ScheduleHandoverScreen(),
    '/writer-dashboard': (context) => const WriterDashboardScreen(),
    '/writer-profile-settings': (context) => const WriterProfileSettingsScreen(),
    '/chat': (context) => const ChatScreen(),
  };

  // Named route navigator with animation
  static Future<dynamic> navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        settings: RouteSettings(name: routeName, arguments: arguments),
        pageBuilder: (context, animation, secondaryAnimation) {
          final Widget page = routes[routeName]!(context);
          return page;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
  
  // Replace current route
  static Future<dynamic> navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }
  
  // Clear stack and navigate
  static Future<dynamic> navigateAndRemoveUntil(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName, 
      (Route<dynamic> route) => false,
      arguments: arguments
    );
  }
}