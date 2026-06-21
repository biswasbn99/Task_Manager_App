import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/utils/asset_path.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;
  ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            AssetPaths.backgroundSvg,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
