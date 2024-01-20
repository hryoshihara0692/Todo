import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Item {
  final String id;
  final TextEditingController controller;
  final String text;

  Item({
    required this.id,
    required this.text,
    required this.controller,
  });

  factory Item.create(String text) {
    var uuid = Uuid();
    var newUuid = uuid.v4();
    // // IDに被りがなくなるまで、ループ
    // while (userDataList.any((userData) => userData.id == newId)) {
    //   // 被りがあるので、IDを再生成する
    //   newId = uuid.v4();
    // }
    return Item(
      id: newUuid,
      text: text,
      controller: TextEditingController(text: text),
    );
  }

  Item change(String text) {
    return Item(id: this.id, text: text, controller: this.controller);
  }

  void dispose() {
    controller.dispose();
  }

  @override
  String toString() {
    return text;
  }
}
