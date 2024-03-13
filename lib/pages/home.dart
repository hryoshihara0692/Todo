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
import 'package:todo/pages/settings.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
   * Todoソート
   */
  final sortColumnSPKeyName = "SortColumnTodo";
  final descendingTodoSPKeyName = "DescendingTodo";
  final selectedTodoListIdSPKeyName = "SelectedTodoListID";
  final sortTypeSPKeyName = "SortTypeTodoList";
  final descendingTodoListSPKeyName = "DescendingTodoList";

  String _sortColumnTodoValue = 'CreatedAt';
  bool _descendingTodoValue = false;
  String _sortTypeTodoListValue = 'CreatedAt';
  bool _descendingTodoListValue = false;

  /**
   * ドロップダウンボタン
   */
  String? _selectedTodoListId = '';

  @override
  void initState() {
    super.initState();
    _initSharedPreferencesData();
  }

  //画面消失時動作
  @override
  void dispose() {
    super.dispose();
  }

  void _initSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(sortColumnSPKeyName)) {
      setState(() {
        final sortColumnTodoValue = prefs.getString(sortColumnSPKeyName);
        _sortColumnTodoValue = sortColumnTodoValue!;
      });
    }
    if (prefs.containsKey(descendingTodoSPKeyName)) {
      setState(() {
        final descendingTodoValue = prefs.getBool(descendingTodoSPKeyName);
        _descendingTodoValue = descendingTodoValue!;
      });
    }
    if (prefs.containsKey(sortTypeSPKeyName)) {
      setState(() {
        final sortTypeTodoListValue = prefs.getString(sortTypeSPKeyName);
        _sortTypeTodoListValue = sortTypeTodoListValue!;
      });
    }
    if (prefs.containsKey(descendingTodoListSPKeyName)) {
      setState(() {
        final descendingTodoListValue = prefs.getBool(descendingTodoListSPKeyName);
        _descendingTodoListValue = descendingTodoListValue!;
      });
    }
    // ユーザーデータを取得して、selectedTodoListIdを設定
    if (prefs.containsKey(selectedTodoListIdSPKeyName)) {
      print('前回選択していたドロップダウン情報(selectedTodoListIdSPKeyName)があります');
      setState(() {
        final selectedTodoListId = prefs.getString(selectedTodoListIdSPKeyName);
        _selectedTodoListId = selectedTodoListId!;
      });
    } else {
      print('選択していたドロップダウン情報がないため、uid($uid)でマイリストを表示する');
      final userData = await UserDataService.getUserData(uid!);
      print('userData: $userData');
      setState(() {
        _selectedTodoListId = userData.keys.firstWhere(
          (key) => key.contains(uid!),
          // orElse: () => '',
        );
      });
    }
  }

  Map<String, dynamic> sortedMapByKeyAscending(
      Map<String, dynamic> originalMap) {
    List<MapEntry<String, dynamic>> sortedEntries = originalMap.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)); // キーの昇順でソート
    return Map.fromEntries(sortedEntries);
  }

  Map<String, dynamic> sortedMapByKeyDescending(
      Map<String, dynamic> originalMap) {
    List<MapEntry<String, dynamic>> sortedEntries = originalMap.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key)); // キーの降順でソート
    return Map.fromEntries(sortedEntries);
  }

  Map<String, dynamic> sortedMapByValueAscending(
      Map<String, dynamic> originalMap) {
    List<MapEntry<String, dynamic>> sortedEntries = originalMap.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value)); // 値の昇順でソート
    return Map.fromEntries(sortedEntries);
  }

  Map<String, dynamic> sortedMapByValueDescending(
      Map<String, dynamic> originalMap) {
    List<MapEntry<String, dynamic>> sortedEntries = originalMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // 値の降順でソート
    return Map.fromEntries(sortedEntries);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: PopScope(
        canPop: false,
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
                          Map<String, dynamic> sortedUserData;

                          if (_sortTypeTodoListValue == 'CreatedAt') {
                            if(_descendingTodoListValue) {
                              sortedUserData = sortedMapByKeyDescending(userData);
                            } else {
                              sortedUserData = sortedMapByKeyAscending(userData);
                            }
                          } else if (_sortTypeTodoListValue == 'Name') {
                            if(_descendingTodoListValue) {
                              sortedUserData = sortedMapByValueDescending(userData);
                            } else {
                              sortedUserData = sortedMapByValueAscending(userData);
                            }
                          } else {
                            sortedUserData = userData;
                          }

                          // userDataの各エントリをDropdownMenuItemに変換する
                          List<DropdownMenuItem<String>> dropdownItems =
                              sortedUserData.entries.map((entry) {
                            final String value = entry.key;
                            final String text = entry.value;
                            if (value.contains(uid!)) {
                              // 初期値を設定する
                              if (_selectedTodoListId == '' ||
                                  _selectedTodoListId == null) {
                                _selectedTodoListId = value;
                                print(_selectedTodoListId);
                              }
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(text),
                            );
                          }).toList();

                          return DropdownButton<String>(
                            value: _selectedTodoListId, // 初期値を設定する
                            items: dropdownItems,
                            onChanged: (String? selectedValue) {
                              setState(() {
                                _selectedTodoListId = selectedValue;
                              });
                            },
                          );
                        } else {
                          return Text("userDataがnullです");
                        }
                      }
                    },
                  )
                : Text('uidがnull'),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // （2） 実際に表示するページ(ウィジェット)を指定する
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),
              // IconButton(
              //   icon: Icon(Icons.remove),
              //   onPressed: () => _decrementCounter(),
              // ),
            ],
            // backgroundColor: Colors.green,
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
          // backgroundColor: Color.fromARGB(255, 122, 175, 228),
          body: Column(
            children: [
              // uid != null ? TodoListFirestore(todoListId: selectedTodoListId!) : TodoListSqflite(),
              uid != null
                  ? TodoListFirestore(
                      todoListId: _selectedTodoListId!,
                      sortColumnTodoValue: _sortColumnTodoValue,
                      descendingTodoValue: _descendingTodoValue,
                    )
                  : Text('TodoListSqflite()'),
              // Admob
              AdMobBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
