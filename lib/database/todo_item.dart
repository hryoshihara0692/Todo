import 'package:flutter/material.dart';

class TodoItem {
  String id;
  String todoListId;
  String content;
  int isChecked;
  final TextEditingController controller;

  TodoItem({
    required this.id,
    required this.todoListId,
    required this.content,
    required this.isChecked,
    required this.controller,
  });
}