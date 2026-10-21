import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/screens/forget_password_set_password.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/utils/app_color.dart';
import 'package:task_manager_app/utils/urls.dart';
import 'package:task_manager_app/widgets/screen_background.dart';

class ForgetPasswordPinVerify extends StatefulWidget {
  final String email;

  const ForgetPasswordPinVerify({super.key, required this.email});

  @override
  State<ForgetPasswordPinVerify> createState() =>
      _ForgetPasswordPinVerifyState();
}

class _ForgetPasswordPinVerifyState extends State<ForgetPasswordPinVerify> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  Future<void> _verifyOtp() async {
    final String otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit PIN')),
      );
      return;
    }

    setState(() {
      _inProgress = true;
    });

    final ApiResponse response = await ApiCaller.getRequest(
      URL: Urls.recoverVerifyOtpURL(widget.email, otp),
    );

    if (mounted) {
      setState(() {
        _inProgress = false;
      });
    }

    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Verified successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordSetPassword(
              email: widget.email,
              otp: otp,
            ),
          ),
        );
      }
    } else {
      final String errorMsg = response.errorMessage ??
          response.responseData?['data']?.toString() ??
          'Invalid OTP. Please try again.';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
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
                    'PIN Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'A 6 digit verification pin has been sent to ${widget.email}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 25),
                  PinCodeTextField(
                    appContext: context,
                    controller: _otpController,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(7),
                      fieldWidth: 45,
                      fieldHeight: 50,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      activeColor: AppColor.Pcolor,
                      inactiveColor: Colors.grey.shade300,
                      selectedColor: AppColor.Pcolor,
                    ),
                    enableActiveFill: true,
                    backgroundColor: Colors.transparent,
                    onCompleted: (pin) {
                      _verifyOtp();
                    },
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 25),
                  Visibility(
                    visible: !_inProgress,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: FilledButton(
                      onPressed: _verifyOtp,
                      child: const Text(
                        'Verify',
                        style: TextStyle(fontSize: 16),
                      ),
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
