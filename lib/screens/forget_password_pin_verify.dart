import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/forget_password_set_password.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/utils/app_color.dart';
import 'package:task_manager_app/widgets/screen_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgetPasswordPinVerify extends StatefulWidget {
  const ForgetPasswordPinVerify({super.key});

  @override
  State<ForgetPasswordPinVerify> createState() =>
      _ForgetPasswordPinVerifyState();
}

class _ForgetPasswordPinVerifyState extends State<ForgetPasswordPinVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 150),
              Text(
                'PIN Verification',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 5),
              Text(
                'A 6 digit verification pin will send to your email address',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 25),
              PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: true,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,

                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(7),
                  fieldWidth: 40,
                  fieldHeight: 50,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  inactiveColor: Colors.grey.shade200,
                  selectedColor: AppColor.Pcolor,
                ),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 25),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgetPasswordSetPassword(),
                    ),
                  );
                },
                child: Text('Verify'),
              ),

              SizedBox(height: 55),

              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
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
    );
  }
}
