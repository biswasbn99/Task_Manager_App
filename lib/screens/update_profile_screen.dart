import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/task_manager_app_bar.dart';
import 'package:task_manager_app/widgets/screen_background.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManagerAppBar(),

      body: ScreenBackground(child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                            SizedBox(height: 150),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 25),
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
                          child: Text('Photos',style: TextStyle(color: Colors.white),),
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(child: Text('Upload Image',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800))),
                      ],
                    ),
                  ),
                    SizedBox(height: 25),
                  TextFormField(decoration: InputDecoration(hintText: 'Email')),
                  SizedBox(height: 25),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'First Name')),
                  SizedBox(height: 25),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Last Name')),
                  SizedBox(height: 25),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Mobile')),
                  SizedBox(height: 25),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Password')),
                  SizedBox(height: 25),
                  FilledButton(
                    onPressed: () {
                     
                    },
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
            ],
          ),
        ),
      )),
    );
  }
}
