import 'package:flutter/material.dart';
import 'package:task_manager_app/app.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/login_provider.dart';
import 'package:task_manager_app/providers/signup_provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_)=>SignUpProvider()),
      ChangeNotifierProvider(create: (_)=>TaskProvider()),
    ],
    child: TaskManagerApp(),
  ));
}
