import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kuoehveyypvycbrqqnyp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1b2VodmV5eXB2eWNicnFxbnlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA5OTg2MDUsImV4cCI6MjA5NjU3NDYwNX0.qavFn4xmsKb5AE1YDmFt4R7-SydtGyRco9kno7-LkIo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estudos App',
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text('Estudos App')),
        body: const Center(child: Text('Supabase conectado!')),
      ),
    );
  }
}