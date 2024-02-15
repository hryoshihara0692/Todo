// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:todo/database/database_helper.dart';
import 'package:todo/database/todo_item.dart';
import 'package:todo/database/user_data_service.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/home/todolist_firestore.dart';
import 'package:todo/widgets/home/todolist_sqflite.dart';
import 'package:todo/widgets/side_menu.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //User
  final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

  //DB
  List<TodoItem> todoItemsList = [];
  final dbHelper = DatabaseHelper.instance;

  /**
   * ドロップダウンボタン
   */
  String? selectedTodoListId;

  @override
  void initState() {
    super.initState();
    selectedTodoListId = uid;
  }

  //画面消失時動作
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: uid != null
                ? FutureBuilder<Map<String, dynamic>>(
                    future: UserDataService.getUserData(uid!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // データ取得中の表示
                      } else if (snapshot.hasError) {
                        return Text('エラー: ${snapshot.error}');
                      } else {
                        final userData = snapshot.data;
                        if (userData != null) {
                          // userDataの各エントリをDropdownMenuItemに変換する
                          List<DropdownMenuItem<String>> dropdownItems =
                              userData.entries.map((entry) {
                            final String value = entry.key;
                            final String text = entry.value;
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(text),
                            );
                          }).toList();

                          // 初期値を設定する
                          if (selectedTodoListId == '' || selectedTodoListId == null) {
                            selectedTodoListId = uid;
                          }

                          return DropdownButton<String>(
                            value: selectedTodoListId, // 初期値を設定する
                            items: dropdownItems,
                            onChanged: (String? selectedValue) {
                              setState(() {
                                selectedTodoListId = selectedValue;
                              });
                            },
                          );
                        } else {
                          return Text("userDataがnullです");
                        }
                      }
                    },
                  )
                : Text("ログインしてないです"),
            backgroundColor: Colors.green,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            // flexibleSpace: Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage(imagePath), fit: BoxFit.cover),
            //   ),
            // ),
          ),
          drawer: SideMenu(),
          backgroundColor: Color.fromARGB(255, 122, 175, 228),

          body: Column(
            children: [
              uid != null ? TodoListFirestore(todoListId: selectedTodoListId!) : TodoListSqflite(),
              // Admob
              AdMobBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
