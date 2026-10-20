import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/controller/auth_controller.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/model/user_model.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/screens/forget_password_email_verify.dart';
import 'package:task_manager_app/screens/main_nav_screen.dart';
import 'package:task_manager_app/screens/sign_up_screen.dart';
import 'package:task_manager_app/utils/app_color.dart';
import 'package:task_manager_app/utils/urls.dart';
import 'package:task_manager_app/widgets/screen_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  Future<void> _signIn() async {
    setState(() {
      _inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "password": _passwordController.text
    };

    final ApiResponse response = await ApiCaller.postRequest(
      URL: Urls.signInURL,
      body: requestBody,
    );

    if (mounted) {
      setState(() {
        _inProgress = false;
      });
    }

    if (response.isSuccess) {
      UserModel model = UserModel.fromJson(response.responseData['data']);
      String accessToken = response.responseData['token'];

      // Must await saving to SharedPreferences and static variables
      await AuthController.saveUserData(model, accessToken);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign In Success... ')),
        );
      }
    } else {
      final String errorMsg = response.errorMessage ??
          response.responseData?['data']?.toString() ??
          'Sign in failed. Please check credentials.';

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
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Text(
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  Visibility(
                    visible: !_inProgress,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signIn();
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 55),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordEmailVerify(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  color: AppColor.Pcolor,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
