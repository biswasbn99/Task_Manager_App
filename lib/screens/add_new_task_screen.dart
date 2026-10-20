import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/api_response.dart';
import 'package:task_manager_app/data/service/api_caller.dart';
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool _inProgress = false;

  Future<void> addNewTask() async {
    setState(() {
      _inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "status": "New"
    };

    final ApiResponse response = await ApiCaller.postRequest(
      URL: Urls.createTaskURL,
      body: requestBody,
    );

    if (mounted) {
      setState(() {
        _inProgress = false;
      });
    }

    if (response.isSuccess) {
      if (mounted) {
        Navigator.pop(context, true); // Returns true to trigger auto-refresh on NewTaskScreen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New Task Successfully Created')),
        );
      }
    } else {
      final String errorMsg = response.errorMessage ??
          response.responseData?['data']?.toString() ??
          response.responseData?['message']?.toString() ??
          'Failed to create task';

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(hintText: 'Description'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
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
                          addNewTask();
                        }
                      },
                      child: const Icon(Icons.arrow_circle_right_outlined),
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
