import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/screens/login_screen.dart';
import 'package:task_manager_app/utils/app_color.dart';
import 'package:task_manager_app/utils/urls.dart';
import 'package:task_manager_app/widgets/screen_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _firstNameController=TextEditingController();
  final TextEditingController _lastNameController=TextEditingController();
  final TextEditingController _mobileController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();

  Future<void> signUp()async{
  Map<String,dynamic>requestBody={
    "email":_emailController.text,
    "firstName":_firstNameController.text,
    "lastName":_lastNameController.text,
    "mobile":_mobileController.text,
      "password":_passwordController.text
  };
  final ApiResponse response=await ApiCaller.postRequest(URL: Urls.signUpURL,body: requestBody);

  if(response.isSuccess){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign Up Success...')));
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.responseData['data'])));
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Text(
                    'Join With Us',
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
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: 'FirstName'),
                    validator: (value) {
                      if(value==null || value.isEmpty){
                        return 'Please Enter First Name';
                      }else{
                        return null;
                      }
                    },
                    ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: 'LastName'),
                    validator: (value) {
                      if(value==null || value.isEmpty){
                        return 'Please Enter Your Last Name';
                      }else{
                        return null;
                      }
                    },
                    ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (value) {
                      if(value==null || value.isEmpty){
                       return 'Please Enter Mobile Number';
                      }else{
                        return null;
                      }
                    },
                    ),
                  SizedBox(height: 25),
                  TextFormField(
                    obscureText: true,
                    controller:_passwordController ,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if(value==null || value.isEmpty){
                        return 'Please Enter Password';
                      }else{
                        return null;
                      }
                    },
                    ),
                  SizedBox(height: 25),
                  FilledButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        signUp();
                      }
                    },
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
                  SizedBox(height: 55,),
              
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
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
