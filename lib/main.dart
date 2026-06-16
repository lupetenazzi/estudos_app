import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estudos_app/presentation/tasks/tasks_page.dart';
import 'package:estudos_app/presentation/auth/login_page.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kuoehveyypvycbrqqnyp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1b2VodmV5eXB2eWNicnFxbnlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA5OTg2MDUsImV4cCI6MjA5NjU3NDYwNX0.qavFn4xmsKb5AE1YDmFt4R7-SydtGyRco9kno7-LkIo',
  );

  await NotificationService.initialize();

  // Adicione temporariamente no main.dart antes do runApp:
  await Supabase.instance.client.auth.signOut();

  runApp(const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estudos App',
      theme: AppTheme.lightTheme,      
      home: Supabase.instance.client.auth.currentSession != null
        ? const TasksPage()
        : const LoginPage(),
      );
  }
}