import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
import 'package:task_manager_app/screens/main_nav_screen.dart';
import 'package:task_manager_app/utils/urls.dart';
import 'package:task_manager_app/widgets/screen_background.dart';
import 'package:task_manager_app/widgets/task_manager_appbar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
   
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();

  Future<void> addNewTask() async{
    Map<String,dynamic>requestBody={
      "title":titleController.text,
      "description":descriptionController.text,
      "status":"New"
    };

    final ApiResponse response=await ApiCaller.postRequest(URL: Urls.createTaskURL,body: requestBody);

    if(response.isSuccess){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainNavScreen()));
    

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New Task Successfully Created')));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.responseDate['data'])));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskManagerAppBar(),

      body: ScreenBackground(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                            SizedBox(height: 150),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    ),
                  SizedBox(height: 25),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(hintText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }else{
                        return null;
                      }
                    },
                    ),
                  SizedBox(height: 25),
                  FilledButton(
                    onPressed: () {
                     if(_formKey.currentState!.validate()){
                       addNewTask();
                     }
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
