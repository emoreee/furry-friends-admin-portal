import 'package:flutter/material.dart';
import 'package:furry_friends_admin/views/appointments/appointment_view.dart';
import 'package:furry_friends_admin/views/auth/login_view.dart';
import 'package:furry_friends_admin/views/dashboard/dashboard_view.dart';
import 'package:furry_friends_admin/views/pets/pet_management_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:furry_friends_admin/firebase_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Vet Care Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/dashboard': (context) => const DashboardView(),
        '/pets': (context) => const PetManagementView(),
        '/appointments': (context) => const AppointmentManagementView(),
      },
    );
  }
}
