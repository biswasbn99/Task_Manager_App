import 'dart:convert';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String email;
  final String createdDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.email,
    required this.createdDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> jsonData) {
    return TaskModel(
      id: jsonData['_id']?.toString() ?? '',
      title: jsonData['title']?.toString() ?? '',
      description: jsonData['description']?.toString() ?? '',
      status: jsonData['status']?.toString() ?? '',
      email: jsonData['email']?.toString() ?? '',
      createdDate: jsonData['createdDate']?.toString() ?? jsonData['createDate']?.toString() ?? '',
    );
  }
}
