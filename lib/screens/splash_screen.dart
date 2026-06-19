import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/utils/asset_path.dart';
import 'package:task_manager_app/widgets/screen_background.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 7));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moveToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(child: Lottie.asset(AssetPaths.splashLottie)),
      ),
    );
  }
}
