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
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

Future<void> _signIn()async{
  Map<String,dynamic>requestBody={
    "email":_emailController.text,
    "password":_passwordController.text
  };

  final ApiResponse response=await ApiCaller.postRequest(URL: Urls.signInURL,body: requestBody);

  if(response.isSuccess){
    UserModel model=UserModel.fromJson(response.responseDate['data']);
    String accessToken=response.responseDate['token'];
    
    AuthController.saveUserData(model, accessToken);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainNavScreen()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign In Success... ')));
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.responseDate['data'])));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key:_formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Text(
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator:(value){
                      if(value==null || value.isEmpty){
                        return 'Please Enter Email';
                      }else{
                        return null;
                      }
                    } ,
                    ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return 'Please Enter Your Password';
                      }else{
                        return null;
                      }
                    },
                    ),
                  SizedBox(height: 25),
                  FilledButton(
                    onPressed: () {
                     if(_formKey.currentState!.validate()){
                      _signIn();
                     }
                    },
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
              
                  SizedBox(height: 55),
              
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPasswordEmailVerify(),
                              ),
                            );
                          },
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
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
                                        builder: (context) => SignUpScreen(),
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
