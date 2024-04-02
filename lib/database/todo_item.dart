import 'package:flutter/material.dart';

class TodoItem {
  String id;
  // String? todoListId;
  String content;
  int isChecked;
  DateTime createdAt;
  DateTime updatedAt;
  final TextEditingController controller;
  FocusNode focusNode;

  TodoItem({
    required this.id,
    // required this.todoListId,
    required this.content,
    required this.isChecked,
    required this.createdAt,
    required this.updatedAt,
    required this.controller,
    required this.focusNode,
  });
}