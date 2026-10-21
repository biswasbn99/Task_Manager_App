import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/screens/forget_password_pin_verify.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/utils/app_color.dart';
import 'package:task_manager_app/utils/urls.dart';
import 'package:task_manager_app/widgets/screen_background.dart';

class ForgetPasswordEmailVerify extends StatefulWidget {
  const ForgetPasswordEmailVerify({super.key});

  @override
  State<ForgetPasswordEmailVerify> createState() =>
      _ForgetPasswordEmailVerifyState();
}

class _ForgetPasswordEmailVerifyState extends State<ForgetPasswordEmailVerify> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  Future<void> _verifyEmail() async {
    setState(() {
      _inProgress = true;
    });

    final String email = _emailController.text.trim();
    final ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.recoverVerifyEmailURL(email),
    );

    if (mounted) {
      setState(() {
        _inProgress = false;
      });
    }

    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A 6-digit OTP has been sent to your email.'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordPinVerify(email: email),
          ),
        );
      }
    } else {
      final String errorMsg = response.errorMessage ??
          response.responseData?['data']?.toString() ??
          'Failed to verify email. Try again.';

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
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'A 6 digit verification pin will be sent to your email address',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
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
                          _verifyEmail();
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 55),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: AppColor.Pcolor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                          ),
                        ],
                      ),
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
