import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/back_end/firebase_options.dart';
import 'package:hackathon/back_end/auth_service.dart';
import 'package:hackathon/front_end/campus_os_dashboard.dart';
import 'package:hackathon/front_end/screens/auth_screen.dart';
import 'package:hackathon/front_end/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Exception catch (e) {
    debugPrint('Firebase initialization exception: $e');
  }

  runApp(const CampusOSApp());
}

class CampusOSApp extends StatelessWidget {
  const CampusOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: AppColors.contentBg,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const CampusOSDashboardScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
