// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:todo/database/todo_item.dart';
import 'package:todo/database/user_data_service.dart';
import 'package:todo/pages/todo_list_edit.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/todolist_firestore.dart';
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

  User? user = FirebaseAuth.instance.currentUser;

  //DB
  List<TodoItem> todoItemsList = [];

  /**
   * Todoソート
   */
  final sortColumnSPKeyName = "SortColumnTodo";
  final descendingTodoSPKeyName = "DescendingTodo";
  final selectedTodoListIdSPKeyName = "SelectedTodoListID";
  final sortTypeSPKeyName = "SortTypeTodoList";
  final descendingTodoListSPKeyName = "DescendingTodoList";
  final todoListOrderSPKeyName = 'todoListOrder';

  String _sortColumnTodoValue = 'CreatedAt';
  bool _descendingTodoValue = false;
  String _sortTypeTodoListValue = 'CreatedAt';
  bool _descendingTodoListValue = false;
  List<String> _spNameList = [];

  /**
   * ドロップダウンボタン
   */
  String? _selectedTodoListId = '';

  @override
  void initState() {
    super.initState();
    _initSharedPreferencesData();
    print('¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥');
    print(user);
    if (user != null) {
      if (user!.isAnonymous) {
        print('匿名でログインしています');
      } else {
        user!.providerData.forEach((provider) {
          switch (provider.providerId) {
            case 'password':
              print('メールアドレスとパスワードで認証されました');
              break;
            case 'google.com':
              print('Googleアカウントで認証されました');
              break;
            case 'apple.com':
              print('Appleアカウントで認証されました');
              break;
            default:
              print('未知の認証プロバイダ: ${provider.providerId}');
              break;
          }
        });
      }
    } else {
      print('ユーザーはログインしていません');
    }
    print(uid);
    print('¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥¥');
  }

  //画面消失時動作
  @override
  void dispose() {
    super.dispose();
  }

  void _initSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(sortColumnSPKeyName)) {
      // setState(() {
      final sortColumnTodoValue = prefs.getString(sortColumnSPKeyName);
      _sortColumnTodoValue = sortColumnTodoValue!;
      // });
    }
    if (prefs.containsKey(descendingTodoSPKeyName)) {
      // setState(() {
      final descendingTodoValue = prefs.getBool(descendingTodoSPKeyName);
      _descendingTodoValue = descendingTodoValue!;
      // });
    }
    if (prefs.containsKey(sortTypeSPKeyName)) {
      // setState(() {
      final sortTypeTodoListValue = prefs.getString(sortTypeSPKeyName);
      _sortTypeTodoListValue = sortTypeTodoListValue!;
      // });
    }
    if (prefs.containsKey(descendingTodoListSPKeyName)) {
      // setState(() {
      final descendingTodoListValue =
          prefs.getBool(descendingTodoListSPKeyName);
      _descendingTodoListValue = descendingTodoListValue!;
      // });
    }
    // ユーザーデータを取得して、selectedTodoListIdを設定
    if (prefs.containsKey(selectedTodoListIdSPKeyName)) {
      print('前回選択していたドロップダウン情報(selectedTodoListIdSPKeyName)があります');
      // setState(() {
      final selectedTodoListId = prefs.getString(selectedTodoListIdSPKeyName);
      _selectedTodoListId = selectedTodoListId!;
      // });
    } else {
      // print('||||||||||||||||||||||||||||||||||||||||||||||||||||');
      // print('ありません))))))))))))');
      // print('||||||||||||||||||||||||||||||||||||||||||||||||||||');
      final userData = await UserDataService.getUserData(uid!);
      final todoLists = userData['TodoLists'];
      setState(() {
        if (todoLists != null) {
          _selectedTodoListId = todoLists.keys.firstWhere(
            (key) => key is String && key.contains(uid!),
            // orElse: () => '',
          );
        }
      });

      // print('||||||||||||||||||||||||||||||||||||||||||||||||||||');
      // print(_selectedTodoListId);
      // print('||||||||||||||||||||||||||||||||||||||||||||||||||||');
      // setState(() {
      //   final todoLists = userData['TodoLists'];
      //   if (todoLists != null) {
      //     _selectedTodoListId = todoLists.keys.firstWhere(
      //       (key) => key is String && key.contains(uid!),
      //       // orElse: () => '',
      //     );
      //   }
      // });
      // print('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
      // print(_selectedTodoListId);
      // print('||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
    }
    if (prefs.containsKey(todoListOrderSPKeyName)) {
      // setState(() {
      final spNameList = prefs.getStringList(todoListOrderSPKeyName);
      _spNameList = spNameList!;
      // });
    }
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
                          List<String> firestoreTodoListIDs = [];
                          // List<dynamic> test = userData['TodoListIDs'];
                          // firestoreTodoListIDs = test.cast<String>();

                          // List<MapEntry<String, dynamic>> todoEntries =
                          //     userData.entries.toList();
                          Map<String, dynamic> todoEntries =
                              userData['TodoLists'];

                          // List<String> todoLists = [];
                          Map<String, dynamic> todoLists = {};

                          if (_spNameList.isNotEmpty) {
                            List<String> sortedTodoListIDs = [];
                            List<String> newTodoListIDs = [];

                            for (var todoListID in _spNameList) {
                              if (todoEntries.containsKey(todoListID)) {
                                sortedTodoListIDs.add(todoListID);
                                newTodoListIDs.add(todoListID);
                              }
                            }

                            // newListに存在しないTodoListを追加する
                            todoEntries.forEach((key, value) {
                              if (!newTodoListIDs.contains(key)) {
                                sortedTodoListIDs.add(key);
                              }
                            });
                            // sortedTodoListIDsの要素を確認し、todoEntriesの対応するキーの値をtodoListsに追加する
                            sortedTodoListIDs.forEach((todoListID) {
                              if (todoEntries.containsKey(todoListID)) {
                                todoLists[todoListID] = todoEntries[todoListID];
                              }
                            });
                          } else {
                            // todoLists = firestoreTodoListIDs;
                            // todoLists.sort();

                            Map<String, dynamic> tmpTodoLists =
                                userData['TodoLists'];
                            // エントリをリストに変換し、値でソートする
                            List<MapEntry<String, dynamic>> sortedEntries =
                                tmpTodoLists.entries.toList()
                                  ..sort((a, b) => a.value.compareTo(b.value));

                            // ソート後のtodoLists
                            Map<String, dynamic> sortedTodoLists =
                                Map.fromEntries(sortedEntries);

                            todoLists = sortedTodoLists;

                            // List<MapEntry<String, dynamic>> sortedEntries =
                            //     userData['TodoLists'].toList()
                            //       ..sort((a, b) =>
                            //           a.key.compareTo(b.key)); // キーの昇順でソート
                            // Map.fromEntries(sortedEntries);
                            // todoLists.addAll(
                            //     sortedEntries.map((entry) => entry.key) as Map<String, dynamic>);
                            // print(todoLists);
                          }

                          // List<DropdownMenuItem<String>> dropdownItems =
                          //     todoLists.map((entry) {
                          //   if (entry.contains(uid!)) {
                          //     // 初期値を設定する
                          //     if (_selectedTodoListId == '' ||
                          //         _selectedTodoListId == null) {
                          //       _selectedTodoListId = entry;
                          //     }
                          //   }
                          //   return DropdownMenuItem<String>(
                          //     value: entry,
                          //     child: Container(
                          //       width: 250, // 横幅を指定する
                          //       child: Text(entry),
                          //     ),
                          //   );
                          // }).toList();

                          // print('~~~~~~~~~~~~~~~~~~~~~');
                          // print(_selectedTodoListId);
                          // print('~~~~~~~~~~~~~~~~~~~~~');

                          List<DropdownMenuItem<String>> dropdownItems =
                              todoLists.entries.map((entry) {
                            // ここで_entry_にTodoリストの情報が入るので、必要に応じて処理を行う
                            String todoListId = entry.key;
                            if (entry.key.contains(uid!)) {
                              if (_selectedTodoListId == '' ||
                                  _selectedTodoListId == null) {
                                _selectedTodoListId = entry.key;
                              }
                            }
                            return DropdownMenuItem<String>(
                              value: todoListId,
                              child: Container(
                                width: 250, // 横幅を指定する
                                child: Text(entry.value.toString()),
                              ),
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
                          // return Text("userData");
                        } else {
                          return Text("userDataがnullです");
                        }
                      }
                    },
                  )
                : Text('uidがnull'),
            actions: [
              IconButton(
                // icon: Icon(Icons.person_add_alt_rounded),
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // （2） 実際に表示するページ(ウィジェット)を指定する
                      builder: (context) => TodoListEditPage(todoListId: _selectedTodoListId!,),
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
                  : Text('error'),
              // Admob
              AdMobBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
