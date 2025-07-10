import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'screens/login/role_selector_screen.dart';
import 'screens/login/otp_login_screen.dart';
import 'screens/login/staff_login_screen.dart';
import 'screens/dashboard/attendee_dashboard.dart';
import 'screens/dashboard/staff_dashboard.dart';
import 'screens/map/live_safety_map_screen.dart';
import 'screens/navigation/smart_navigation_screen.dart';
import 'screens/emergency/emergency_sos_screen.dart';
import 'screens/chat/gemini_chat_screen.dart';
import 'screens/alerts/live_broadcasts_screen.dart';
import 'screens/incidents/incident_replay_screen.dart';
import 'screens/lost_found/lost_found_screen.dart';
import 'screens/sentiment/crowd_sentiment_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: DrishtiApp()));
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const RoleSelectorScreen(),
    ),
    GoRoute(
      path: '/otp-login',
      builder: (context, state) => const OTPLoginScreen(),
    ),
    GoRoute(
      path: '/staff-login',
      builder: (context, state) => const StaffLoginScreen(),
    ),
    GoRoute(
      path: '/attendee-dashboard',
      builder: (context, state) => const AttendeeDashboard(),
    ),
    GoRoute(
      path: '/staff-dashboard',
      builder: (context, state) => const StaffDashboard(),
    ),
    GoRoute(
      path: '/safety-map',
      builder: (context, state) => const LiveSafetyMapScreen(),
    ),
    GoRoute(
      path: '/navigation',
      builder: (context, state) => const SmartNavigationScreen(),
    ),
    GoRoute(
      path: '/emergency',
      builder: (context, state) => const EmergencySOSScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const GeminiChatScreen(),
    ),
    GoRoute(
      path: '/alerts',
      builder: (context, state) => const LiveBroadcastsScreen(),
    ),
    GoRoute(
      path: '/incidents',
      builder: (context, state) => const IncidentReplayScreen(),
    ),
    GoRoute(
      path: '/lost-found',
      builder: (context, state) => const LostFoundScreen(),
    ),
    GoRoute(
      path: '/sentiment',
      builder: (context, state) => const CrowdSentimentScreen(),
    ),
  ],
);

class DrishtiApp extends ConsumerWidget {
  const DrishtiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Drishti AI - Public Safety',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
