import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/database/user_data_service.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/pages/todo_list_add.dart';
import 'package:todo/pages/todo_list_edit.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListAdminPage extends StatefulWidget {
  // const AccountRegistrationPage({super.key});
  const TodoListAdminPage({super.key});

  @override
  State<TodoListAdminPage> createState() => _TodoListAdminPageState();
}

class _TodoListAdminPageState extends State<TodoListAdminPage> {
  final TextEditingController _todoListNameController = TextEditingController();
  // final TextEditingController _passController = TextEditingController();

  final AdMob _adMob = AdMob();

  final todoListOrderSPKeyName = 'todoListOrder';

  @override
  void initState() {
    super.initState();
    _initSharedPreferencesData();
    _adMob.load();
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  List<String> _spNameList = [];

  void _initSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(todoListOrderSPKeyName)) {
      setState(() {
        final spNameList = prefs.getStringList(todoListOrderSPKeyName);
        _spNameList = spNameList!;
      });
    }
  }

  void _setSharedPreferenceTodoListOrder(List<String> todoListOrder) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(todoListOrderSPKeyName, todoListOrder);
  }

  void _showJoinDialog() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("TODOリストにメンバーを参加する"),
          content: Column(
            children: [
              Text('TODOリストID'),
              // Text(todoListName),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // 枠線の色を設定
                  // borderRadius: BorderRadius.all(
                  //     Radius.circular(8.0)), // 枠線の角を丸める
                ),
                // child: Text(widget.todoListId),
                child: Text('a'),
              ),
              // TextButton(
              //   style: ButtonStyle(
              //       foregroundColor: MaterialStateProperty.all(
              //         Colors.blue,
              //       ),
              //       textStyle: MaterialStateProperty.all(
              //           TextStyle(decoration: TextDecoration.underline))),
              //   onPressed: () async {
              //     final data = ClipboardData(text: widget.todoListId);
              //     await Clipboard.setData(data);
              //   },
              //   child: Text('IDコピー'),
              // ),
              Text('↑のIDを、招待する人に教えて下さい！'),
              Text('※ホーム→TODOリスト管理→参加の画面に入力します'),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Todo List Name",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("閉じる"),
            ),
            TextButton(
              onPressed: () async {
                // setState(() {
                //   todoListName = _controller.text;
                // });
                // await TodoListDataService.updateTodoListName(
                //     widget.todoListId, todoListName);
                String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

                try {
                  await UserDataService.updateUserTodoLists(
                      uid!, _controller.text);
                  // メソッドがエラーなく正常に完了した場合の処理
                } catch (e) {
                  print('エラーが発生しました: $e');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(),
                    ),
                  );
                  // エラーが発生した場合の処理
                }

                try {} catch (e) {}
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (BuildContext context) =>
                //         TodoListEditPage(todoListId: widget.todoListId),
                //   ),
                // );
              },
              child: Text("参加する"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(200);
    final designH = screen.designH(200);

    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    return Scaffold(
        appBar: AppBar(
          title: Text('TODOリスト管理'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove(todoListOrderSPKeyName);
                },
                child: Text('テスト用ボタン「SP削除」'),
              ),
              Text('TODOリスト一覧'),
              Text('TODOリストを長押しすると、並び替えができます！'),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  // child: FutureBuilder<Map<String, dynamic>>(
                  //   future: UserDataService.getUserData(uid!),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('エラー: ${snapshot.error}');
                  //     } else {
                  //       final userData = snapshot.data;
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: UserDataService.getUserData(uid!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // データ取得中の表示
                      } else if (snapshot.hasError) {
                        return Text('エラー: ${snapshot.error}');
                      } else if (snapshot.data == null) {
                        return Text('データが見つかりませんでした');
                      } else {
                        // データが存在する場合の処理
                        final userData = snapshot.data;
                        // ここでデータを使った処理を続ける

                        if (userData != null) {
                          // List<MapEntry<String, dynamic>> todoEntries =
                          //     userData.entries.toList();
                          Map<String, dynamic> todoEntries =
                              userData['TodoLists'];

                          // print(todoEntries);

                          if (_spNameList.isNotEmpty) {
                            // newListの順番に従ってtodoListNameを並び替える
                            List<String> sortedTodoListIDs = [];
                            List<String> newTodoListIDs = [];

                            _spNameList.forEach((todoListID) {
                              if (todoEntries.containsKey(todoListID)) {
                                sortedTodoListIDs.add(todoListID);
                                newTodoListIDs.add(todoListID);
                              }
                            });

                            // newListに存在しないTodoListを追加する
                            todoEntries.forEach((key, value) {
                              if (!newTodoListIDs.contains(key)) {
                                sortedTodoListIDs.add(key);
                              }
                            });

                            // return ReorderableListView(
                            //   onReorder: (oldIndex, newIndex) {
                            //     setState(() {
                            //       if (newIndex > oldIndex) {
                            //         newIndex -= 1;
                            //       }
                            //       final String item =
                            //           sortedTodoListIDs.removeAt(oldIndex);
                            //       sortedTodoListIDs.insert(newIndex, item);
                            //       List<String> reorderedList =
                            //           sortedTodoListIDs;
                            //       _setSharedPreferenceTodoListOrder(
                            //           reorderedList);
                            //       _spNameList = sortedTodoListIDs;
                            //     });
                            //   },
                            //   children: sortedTodoListIDs
                            //       .asMap()
                            //       .entries
                            //       .map((entry) {
                            //     final int index = entry.key;
                            //     final String todoListID = entry.value;
                            //     return Container(
                            //       key: Key(todoListID),
                            //       color: index % 2 == 0
                            //           ? Colors.grey[200]
                            //           : Colors.white, // 背景色を交互に変更
                            //       child: ListTile(
                            //         title: Text(todoListID),
                            //         trailing: Wrap(
                            //           children: [
                            //             IconButton(
                            //               icon: Icon(Icons.edit),
                            //               onPressed: () {},
                            //             ),
                            //             IconButton(
                            //               icon: Icon(Icons.delete),
                            //               onPressed: () {},
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   }).toList(),
                            // );
                            return ReorderableListView(
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final String item =
                                      sortedTodoListIDs.removeAt(oldIndex);
                                  sortedTodoListIDs.insert(newIndex, item);
                                  List<String> reorderedList =
                                      sortedTodoListIDs;
                                  _setSharedPreferenceTodoListOrder(
                                      reorderedList);
                                  _spNameList = sortedTodoListIDs;
                                });
                              },
                              children: sortedTodoListIDs
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final int index = entry.key;
                                final String todoListID = entry.value;
                                final String todoListName =
                                    todoEntries[todoListID];
                                return Container(
                                  key: Key(todoListID),
                                  color: index % 2 == 0
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  child: ListTile(
                                    title:
                                        Text(todoListName), // todoEntries の値を表示
                                    trailing: Wrap(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) {
                                                  return TodoListEditPage(
                                                    todoListId: todoListID,
                                                  );
                                                },
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  // 右から左
                                                  final Offset begin =
                                                      Offset(1.0, 0.0);
                                                  // 左から右
                                                  // final Offset begin = Offset(-1.0, 0.0);
                                                  final Offset end =
                                                      Offset.zero;
                                                  final Animatable<Offset>
                                                      tween = Tween(
                                                              begin: begin,
                                                              end: end)
                                                          .chain(CurveTween(
                                                              curve: Curves
                                                                  .easeInOut));
                                                  final Animation<Offset>
                                                      offsetAnimation =
                                                      animation.drive(tween);
                                                  return SlideTransition(
                                                    position: offsetAnimation,
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            // List<MapEntry<String, dynamic>> sortedEntries =
                            //     userData.entries.toList()
                            //       ..sort((a, b) =>
                            //           a.key.compareTo(b.key)); // キーの昇順でソート
                            // userData の TodoLists フィールドをリストに変換する
                            // List<MapEntry<String, dynamic>> sortedEntries =
                            //     userData['TodoLists'].entries.toList();

                            // sortedEntries.sort((a, b) => a.value.compareTo(b.value));

                            // Map.fromEntries(sortedEntries);
                            // List<String> todoLists = [];
                            // todoLists.addAll(
                            //     sortedEntries.map((entry) => entry.key));
                            // return ReorderableListView(
                            //   onReorder: (oldIndex, newIndex) {
                            //     setState(() {
                            //       if (newIndex > oldIndex) {
                            //         newIndex -= 1;
                            //       }
                            //       final String item =
                            //           todoLists.removeAt(oldIndex);
                            //       todoLists.insert(newIndex, item);
                            //       List<String> reorderedList = todoLists;
                            //       _setSharedPreferenceTodoListOrder(
                            //           reorderedList);
                            //       _spNameList = todoLists;
                            //     });
                            //   },
                            //   children: todoLists.asMap().entries.map((entry) {
                            //     final int index = entry.key;
                            //     final String todoListID = entry.value;
                            //     print('~~~~~~~~~~~~~~~~~~~');
                            //     print(index);
                            //     print(todoListID);
                            //     print('~~~~~~~~~~~~~~~~~~~');
                            //     return Container(
                            //       key: Key(todoListID),
                            //       color: index % 2 == 0
                            //           ? Colors.grey[200]
                            //           : Colors.white, // 背景色を交互に変更
                            //       child: ListTile(
                            //         title: Text(todoListID),
                            //         trailing: IconButton(
                            //           icon: Icon(Icons.edit),
                            //           onPressed: () {},
                            //         ),
                            //       ),
                            //     );
                            //   }).toList(),
                            // );
                            List<MapEntry<String, dynamic>> sortedEntries =
                                userData['TodoLists'].entries.toList();

                            sortedEntries
                                .sort((a, b) => a.value.compareTo(b.value));

                            return ReorderableListView(
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final String item =
                                      sortedEntries.removeAt(oldIndex).key;
                                  sortedEntries.insert(
                                      newIndex,
                                      MapEntry(
                                          item, '')); // 現在は値は利用していないため、空文字列を設定
                                  _setSharedPreferenceTodoListOrder(
                                      sortedEntries
                                          .map((entry) => entry.key)
                                          .toList());
                                  _spNameList = sortedEntries
                                      .map((entry) => entry.key)
                                      .toList();
                                });
                              },
                              children:
                                  sortedEntries.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final String todoListID = entry.value.key;
                                return Container(
                                  key: Key(todoListID),
                                  color: index % 2 == 0
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  child: ListTile(
                                    title: Text(
                                        entry.value.value), // ソートされたエントリの値を表示
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return TodoListEditPage(
                                                todoListId: todoListID,
                                              );
                                            },
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              // 右から左
                                              final Offset begin =
                                                  Offset(1.0, 0.0);
                                              // 左から右
                                              // final Offset begin = Offset(-1.0, 0.0);
                                              final Offset end = Offset.zero;
                                              final Animatable<Offset> tween =
                                                  Tween(begin: begin, end: end)
                                                      .chain(CurveTween(
                                                          curve: Curves
                                                              .easeInOut));
                                              final Animation<Offset>
                                                  offsetAnimation =
                                                  animation.drive(tween);
                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        } else {
                          return Text("userDataがnullです");
                        }
                      }
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton(
                    // focusColor: Colors.red,
                    // hoverColor: Colors.blue,
                    splashColor: Colors.green,
                    backgroundColor: Colors.yellow,
                    // foregroundColor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return TodoListAddPage();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            // 右から左
                            final Offset begin = Offset(1.0, 0.0);
                            // 左から右
                            // final Offset begin = Offset(-1.0, 0.0);
                            final Offset end = Offset.zero;
                            final Animatable<Offset> tween =
                                Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<Offset> offsetAnimation =
                                animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.post_add),
                        Text(' TODOリスト追加 '),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton(
                    // focusColor: Colors.red,
                    // hoverColor: Colors.blue,
                    splashColor: Colors.green,
                    backgroundColor: Colors.yellow,
                    // foregroundColor: Colors.black,
                    onPressed: () {
                      _showJoinDialog();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.post_add),
                        Text(' TODOリスト参加 '),
                      ],
                    ),
                  ),
                ),
              ),
              AdMobBanner(),
            ],
          ),
        )

        // body: SafeArea(
        //   child: Column(
        //     children: [
        // Container(
        //   width: designW,
        //   // height: designH,
        //   decoration: const BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: Colors.blue,
        //   ),
        //   margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
        //   child: const Center(child: Text('Flex 1')),
        // ),
        // Expanded(
        //   child: Container(
        //     color: Colors.pink,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SizedBox(
        //           height: 50,
        //           child: TextField(
        //             controller: _todoListNameController,
        //             decoration: const InputDecoration(
        //               border: OutlineInputBorder(
        //                   borderSide: BorderSide(width: 3)),
        //               hintText: 'TodoList名',
        //             ),
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 25.0,
        //         ),
        //         const SizedBox(
        //           height: 25.0,
        //         ),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             RoundButton(
        //               buttonName: 'キャンセル',
        //               buttonWidth: 150,
        //               onPressed: () {
        //                 Navigator.pop(context);
        //               },
        //             ),
        //             const SizedBox(
        //               width: 25,
        //             ),
        //             RoundButton(
        //               buttonName: 'TodoList登録',
        //               buttonWidth: 150,
        //               onPressed: () {
        //                 createTodoList(_todoListNameController.text, uid);
        //                 // Navigator.pop(context);
        //                 Navigator.pushReplacement(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (BuildContext context) => HomePage(),
        //                   ),
        //                 );
        //               },
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // AdMobBanner(),
        // ],
        // ),
        // ),
        );
  }

  // Future<void> createTodoList(String todoListName, String? uid) async {
  //   var uuid = Uuid();
  //   var todoListId = uuid.v4();

  //   // Firestoreのコレクション参照
  //   CollectionReference users = FirebaseFirestore.instance.collection('USER');

  //   DocumentReference docRef = users.doc(uid);

  //   // 追加するデータ
  //   String date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
  //   Map<String, dynamic> newData = {
  //     date + '-' + todoListId: todoListName, // 新しいフィールドと値
  //   };

  //   // ドキュメントを更新（既存のデータとマージ）
  //   docRef.set(newData, SetOptions(merge: true)).then((value) {
  //     print("ドキュメントが正常に更新されました");
  //   }).catchError((error) {
  //     print("ドキュメントの更新中にエラーが発生しました： $error");
  //   });

  //   // await FirebaseFirestore.instance.collection('USER').doc(uid).add({
  //   //   todoListId: todoListName,
  //   // });
  //   // await FirebaseFirestore.instance.collection('USER').doc(uid).set();
  // }

  // void _createAccount(BuildContext context, String id, String pass) async {
  //   try {
  //     /// credential にはアカウント情報が記録される
  //     final credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: id,
  //       password: pass,
  //     );

  //     final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();
  //     Map<String, dynamic> data = <String, dynamic>{};
  //     await FirebaseFirestore.instance.collection('USER').doc(uid).set(data);

  //     // Navigator.pushNamed(context, '/');
  //     // context.push('/');
  //     Navigator.pop(context);
  //   }

  //   /// アカウントに失敗した場合のエラー処理
  //   on FirebaseAuthException catch (e) {
  //     /// パスワードが弱い場合
  //     if (e.code == 'weak-password') {
  //       print('パスワードが弱いです');
  //     }

  //     /// メールアドレスが既に使用中の場合
  //     else if (e.code == 'email-already-in-use') {
  //       print('すでに使用されているメールアドレスです');
  //     }
  //     // メールアドレスがおかしい場合
  //     else if (e.code == 'invalid-email') {
  //       print('メールアドレスが有効ではありません。');
  //     }

  //     /// その他エラー
  //     else {
  //       print('アカウント作成エラー');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
