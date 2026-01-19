import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Temporarily disabled due to build conflicts
// import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'core/database/app_database.dart';
// import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Database
    await AppDatabase().database;
  } catch (e) {
    debugPrint('Database initialization error: $e');
  }
  
  runApp(const ProviderScope(child: AncientKeyApp()));
}
