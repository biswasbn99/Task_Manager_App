import 'package:flutter/material.dart';
import 'package:task_manager_app/utils/app_color.dart';
import 'package:task_manager_app/widgets/screen_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 150,),
                Text('Get Started With',
            style: Theme.of(context).textTheme.titleLarge,),
           SizedBox(height: 25,),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 25,),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 25,),
            FilledButton(onPressed: (){}, child: Text('Login')),

           SizedBox(height: 55,),

            Center(
              child: Column(
                children: [
                  TextButton(onPressed: (){}, child: Text('Forget Password?',
                    style: TextStyle(color: Colors.grey),),),
                  RichText(text: TextSpan(text: "Don't have an account? ",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: 'Sign up',style: TextStyle(color: AppColor.Pcolor),
                      )
                    ],
                  )),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
