import 'package:flutter/material.dart';
import 'package:task_manager_app/controller/auth_controller.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/screens/update_profile_screen.dart';
import 'package:task_manager_app/utils/app_color.dart';

class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskManagerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.Pcolor,
      title: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
          );
        },
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/images/profilePic.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AuthController.userData?.firstName ?? ''} ${AuthController.userData?.lastName ?? ''}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  AuthController.userData?.email ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await AuthController.clearUserData();
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (predicate) => false,
              );
            }
          },
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
