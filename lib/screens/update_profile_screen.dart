import 'package:flutter/material.dart';
import 'package:task_manager_app/controller/auth_controller.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/model/user_model.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/screens/main_nav_screen.dart';
import 'package:task_manager_app/utils/urls.dart';
import 'package:task_manager_app/widgets/task_manager_appbar.dart';
import 'package:task_manager_app/widgets/screen_background.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    UserModel? user = AuthController.userData;
    if (user != null) {
      _emailController.text = user.email ?? '';
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _mobileController.text = user.mobile ?? '';
    }
  }

  Future<void> updateProfile() async {
    setState(() {
      _inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
    };

    if (_passwordController.text.isNotEmpty) {
      requestBody['password'] = _passwordController.text;
    }

    final ApiResponse response = await ApiCaller.postRequest(
      URL: Urls.updateProfileURL,
      body: requestBody,
    );

    if (mounted) {
      setState(() {
        _inProgress = false;
      });
    }

    if (response.isSuccess) {
      UserModel model = UserModel(
        sId: AuthController.userData?.sId,
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobile: _mobileController.text.trim(),
      );

      await AuthController.updateUserData(model);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );
      }
    } else {
      final String errorMsg = response.errorMessage ??
          response.responseData?['data']?.toString() ??
          response.responseData?['message']?.toString() ??
          'Profile update failed';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TaskManagerAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Update Profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 25),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Photos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  enabled: false, // Email is typically read-only in profile update
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(hintText: 'First Name'),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(hintText: 'Last Name'),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(hintText: 'Mobile'),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: 'Password (leave blank to keep current)'),
                ),
                const SizedBox(height: 25),
                Visibility(
                  visible: !_inProgress,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: FilledButton(
                    onPressed: () {
                      updateProfile();
                    },
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
