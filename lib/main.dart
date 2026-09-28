import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

import 'package:furry_friends_admin/views/dashboard/dashboard_view.dart';
import 'package:furry_friends_admin/views/appointments/appointment_view.dart';
import 'package:furry_friends_admin/views/users/user_account_view.dart';
import 'package:furry_friends_admin/views/pets/pet_management_view.dart';
import 'package:furry_friends_admin/views/auth/login_view.dart';
import 'package:furry_friends_admin/views/doctor/doctor_portal_view.dart';
import 'package:furry_friends_admin/models/notification_view.dart';
import 'package:furry_friends_admin/views/health/health_monitoring_view.dart';
import 'package:furry_friends_admin/views/notifications/messages_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Idagdag ang Firebase initialization bago ang runApp
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furry Friends Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'inter',
        primaryColor: const Color(0xFF183F82),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/dashboard': (context) => const DashboardView(),
        '/users': (context) => const UserAccountView(),
        '/pets': (context) => const PetManagementView(),
        '/appointments': (context) => const AppointmentManagementView(),
        '/doctor': (context) => const DoctorPortalView(),
        '/notifications': (context) => const NotificationView(),
        '/health': (context) => const HealthMonitoringView(),
        '/messages': (context) => const MessagesView(),
      },
    );
  }
}
