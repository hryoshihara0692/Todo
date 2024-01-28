import 'package:flutter/material.dart';

class TodoItem {
  String id;
  String content;
  int isChecked;
  final TextEditingController controller;

  TodoItem({required this.id, required this.content, required this.isChecked, required this.controller});
}