import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/database/todo_data_service.dart';
import 'package:todo/database/todolist_data_service.dart';
import 'package:todo/database/user_data_service.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/pages/todo_list_admin.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class TodoListAddPage extends StatefulWidget {
  // final String todoListId;

  const TodoListAddPage({
    Key? key,
    // required this.todoListId,
  }) : super(key: key);

  @override
  State<TodoListAddPage> createState() => _TodoListAddPageState();
}

class _TodoListAddPageState extends State<TodoListAddPage> {
  final TextEditingController _todoListNameController = TextEditingController();
  // final TextEditingController _passController = TextEditingController();

  Map<String, dynamic> todoList = {};
  String? uid = '';
  final FocusNode _idFocusNode = FocusNode(); // 追加: フォーカスノード

  // bool isChecked = true; // valueプロパティに渡す変数
  // bool canEdit = false; // valueプロパティに渡す変数

  final AdMob _adMob = AdMob();

  List<String> userIDs = [];

  @override
  void initState() {
    super.initState();
    // _initSharedPreferencesData();
    initData();
    _adMob.load();
    // 追加: テキストフィールドにフォーカスを当てる
    Future.delayed(Duration.zero, () {
      _idFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  void initData() async {
    uid = FirebaseAuth.instance.currentUser?.uid.toString();

  //   if (widget.todoListId != '') {
  //     try {
  //       DocumentSnapshot<Map<String, dynamic>> snapshot =
  //           await FirebaseFirestore.instance
  //               .collection('TODOLIST')
  //               .doc(widget.todoListId)
  //               .get();
  //       if (snapshot.exists) {
  //         setState(() {
  //           todoList = snapshot.data()!;
  //           isChecked = todoList['EditingPermission'] == 1 ? true : false;
  //         });
  //       } else {
  //         // ドキュメントが存在しない場合の処理
  //         // 例: エラーメッセージの表示など
  //       }
  //     } catch (e) {
  //       // エラーが発生した場合の処理
  //       // 例: エラーメッセージの表示など
  //     }

  //     if (isChecked) {
  //       setState(() {
  //         canEdit = true;
  //       });
  //     } else {
  //       if (todoList['Administrator'] == uid) {
  //         setState(() {
  //           canEdit = true;
  //         });
  //       }
  //     }
  //   }
  }

  // void _showEditDialog(String todoListName) {
  //   TextEditingController _controller = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("TODOリスト名を変更する"),
  //         content: Column(
  //           children: [
  //             Text('現在のTODOリスト名'),
  //             Text(todoListName),
  //             Text('↓'),
  //             Text('変更後のTODOリスト名'),
  //             TextField(
  //               controller: _controller,
  //               decoration: InputDecoration(
  //                 labelText: "Todo List Name",
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("キャンセル"),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               setState(() {
  //                 todoListName = _controller.text;
  //               });
  //               await TodoListDataService.updateTodoListName(widget.todoListId,
  //                   todoListName, todoList['UserIDs'].cast<String>());
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (BuildContext context) =>
  //                       TodoListEditPage(todoListId: widget.todoListId),
  //                 ),
  //               );
  //             },
  //             child: Text("変更する"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showInviteDialog() {
  //   // TextEditingController _controller = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("TODOリストにメンバーを招待する"),
  //         content: Column(
  //           children: [
  //             Text('TODOリストID'),
  //             // Text(todoListName),
  //             Container(
  //               margin: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.grey), // 枠線の色を設定
  //                 // borderRadius: BorderRadius.all(
  //                 //     Radius.circular(8.0)), // 枠線の角を丸める
  //               ),
  //               child: Text(widget.todoListId),
  //             ),
  //             TextButton(
  //               style: ButtonStyle(
  //                   foregroundColor: MaterialStateProperty.all(
  //                     Colors.blue,
  //                   ),
  //                   textStyle: MaterialStateProperty.all(
  //                       TextStyle(decoration: TextDecoration.underline))),
  //               onPressed: () async {
  //                 final data = ClipboardData(text: widget.todoListId);
  //                 await Clipboard.setData(data);
  //               },
  //               child: Text('IDコピー'),
  //             ),
  //             Text('↑のIDを、招待する人に教えて下さい！'),
  //             Text('※ホーム→TODOリスト管理→参加の画面に入力します'),
  //             // TextField(
  //             //   controller: _controller,
  //             //   decoration: InputDecoration(
  //             //     labelText: "Todo List Name",
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("閉じる"),
  //           ),
  //           // TextButton(
  //           //   onPressed: () async {
  //           //     setState(() {
  //           //       todoListName = _controller.text;
  //           //     });
  //           //     await TodoListDataService.updateTodoListName(
  //           //         widget.todoListId, todoListName);
  //           //     Navigator.pushReplacement(
  //           //       context,
  //           //       MaterialPageRoute(
  //           //         builder: (BuildContext context) =>
  //           //             TodoListEditPage(todoListId: widget.todoListId),
  //           //       ),
  //           //     );
  //           //   },
  //           //   child: Text("変更する"),
  //           // ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _showDeleteDialog() {
  //   // TextEditingController _controller = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("TODOリストを削除する"),
  //         content: Column(
  //           children: [
  //             Text('TODOリストに登録されている各TODOも削除されます。'),
  //             Text('TODOリストの削除後、復元することはできません。'),
  //             Text('TODOリストに参加しているメンバーからも見えなくなります。'),
  //             // Text('変更後のTODOリスト名'),
  //             // TextField(
  //             //   controller: _controller,
  //             //   decoration: InputDecoration(
  //             //     labelText: "Todo List Name",
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text("キャンセル"),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               // setState(() {
  //               //   todoListName = _controller.text;
  //               // });

  //               final userData = await TodoListDataService.getTodoListData(
  //                   widget.todoListId);
  //               final List<String> uidList = userData['UserIDs'].cast<String>();

  //               //Userコレクションの該当のユーザデータから、本TODOリストのデータを削除する
  //               uidList.forEach((element) async {
  //                 if (element != uid) {
  //                   await UserDataService.removeTodoListFromUser(
  //                       uid!, widget.todoListId);
  //                 }
  //               });

  //               await TodoListDataService.deleteTodoListData(widget.todoListId);

  //               //マイリスト削除した場合は、マイリスト再作成
  //               if (widget.todoListId.contains(uid!)) {
  //                 String todoListID =
  //                     DateFormat('yyyyMMddHHmmss').format(DateTime.now()) +
  //                         '-' +
  //                         uid!;

  //                 Map<String, dynamic> todolistRow = {
  //                   "TodoListName": "マイリスト",
  //                   "Administrator": uid,
  //                   "UserIDs": [uid],
  //                   "EditingPermission": 0,
  //                   "CreatedAt": Timestamp.fromDate(DateTime.now()),
  //                   "UpdatedAt": Timestamp.fromDate(DateTime.now()),
  //                 };

  //                 // TODOLISTコレクションにドキュメント追加
  //                 await TodoListDataService.createTodoListData(
  //                     todoListID, todolistRow);

  //                 var uuid = Uuid();
  //                 var todoId = uuid.v4();

  //                 Map<String, dynamic> todoRow = {
  //                   "Content": "",
  //                   "isChecked": 0,
  //                   "CreatedAt": Timestamp.fromDate(DateTime.now()),
  //                   "UpdatedAt": Timestamp.fromDate(DateTime.now()),
  //                 };

  //                 // TODOコレクションにドキュメント追加
  //                 await TodoDataService.createTodoData(
  //                     todoListID, todoId, todoRow);

  //                 await UserDataService.updateUserTodoListsEasy(uid!, todoListID, 'マイリスト');
  //               }

  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (BuildContext context) => TodoListAdminPage(),
  //                 ),
  //               );
  //             },
  //             child: Text("変更する"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // bool _isShowingSnackbar = false;

  // // void showDeleteButtonSnackbar(String deleteButtonModeName) {
  // void showSnackbar() {
  //   // String modeName = '';
  //   // if (deleteButtonModeName == 'long') {
  //   //   modeName = '長押し';
  //   // } else if (deleteButtonModeName == 'single') {
  //   //   modeName = '1回タップ';
  //   // } else if (deleteButtonModeName == 'double') {
  //   //   modeName = '2回タップ';
  //   // }

  //   if (!_isShowingSnackbar) {
  //     setState(() {
  //       _isShowingSnackbar = true;
  //     });
  //     final snackBar = SnackBar(
  //       content: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               // Text('削除ボタンは$modeNameで実行できます。'),
  //               Text('「管理者のみ」が変更可能です。'),
  //             ],
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               const Text(''),
  //               // TextButton(
  //               //   style: ButtonStyle(
  //               //       foregroundColor: MaterialStateProperty.all(
  //               //         Colors.blue,
  //               //       ),
  //               //       textStyle: MaterialStateProperty.all(
  //               //           TextStyle(decoration: TextDecoration.underline))),
  //               //   onPressed: () {
  //               //     Navigator.push(
  //               //       context,
  //               //       MaterialPageRoute(
  //               //         // （2） 実際に表示するページ(ウィジェット)を指定する
  //               //         builder: (context) => SettingsPage(),
  //               //       ),
  //               //     );
  //               //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //               //   },
  //               //   child: Text('設定画面へ'),
  //               // )
  //             ],
  //           ),
  //         ],
  //       ),
  //       duration: const Duration(seconds: 10),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       margin: const EdgeInsets.only(left: 23, right: 23, bottom: 23),
  //       behavior: SnackBarBehavior.floating,
  //       showCloseIcon: true,
  //     );
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(snackBar)
  //         .closed
  //         .then((reason) {
  //       setState(() {
  //         _isShowingSnackbar = false;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(200);
    final designH = screen.designH(200);

    return Scaffold(
      appBar: AppBar(
          // title: Text('TODOリスト編集'),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       _showDeleteDialog();
          //     },
          //     icon: Icon(Icons.delete),
          //   ),
          // ],
          ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 0, 0),
                        child: Text(
                          'TODOリスト名',
                          style: TextStyle(
                            // fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          // child: Text(
                          //   // todoList['TodoListName'],
                          //   '',
                          //   style: TextStyle(
                          //     fontSize: 20.0,
                          //     // fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          child: TextField(
                            controller: _todoListNameController,
                            focusNode: _idFocusNode, // 追加: フォーカスノードを設定
                            decoration: const InputDecoration(
                              // border: OutlineInputBorder(
                              //     borderSide: BorderSide(width: 3)),
                              hintText: 'Todoリスト名を入力してください',
                            ),
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible: !canEdit, // todoListIdが空の場合に表示
                      //   child: IconButton(
                      //     icon: Icon(Icons.edit_off), // 空の場合は追加アイコンを表示
                      //     onPressed: () {
                      //       // 追加アイコンがタップされたときの処理
                      //       showSnackbar();
                      //     },
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: canEdit, // todoListIdが空でない場合に表示
                      //   child: IconButton(
                      //     icon: Icon(Icons.edit),
                      //     onPressed: () {
                      //       _showEditDialog(todoList['TodoListName']);
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0),
                  //   child: SizedBox(
                  //     height: 50,
                  //     child: TextField(
                  //       controller: _todoListNameController,
                  //       decoration: const InputDecoration(
                  //         border: OutlineInputBorder(
                  //             borderSide: BorderSide(width: 3)),
                  //         hintText: 'Todoリスト名を入力してください',
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Expanded(
                  //     child: FutureBuilder<Map<String, dynamic>>(
                  //   future:
                  //       TodoListDataService.getTodoListData(widget.todoListId),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('error: ${snapshot.error}');
                  //     } else {
                  //       final userData = snapshot.data;
                  //       final List<String> uidList = userData!['UserIDs'].cast<
                  //           String>(); // Assuming 'uid' is a List<String> in userData
                  //       // return ListView.builder(
                  //       //   itemCount: uidList.length,
                  //       //   itemBuilder: (context, index) {
                  //       //     final uid = uidList[index];
                  //       //     return FutureBuilder<DocumentSnapshot>(
                  //       //       future: FirebaseFirestore.instance
                  //       //           .collection('USER')
                  //       //           .doc(uid)
                  //       //           .get(),
                  //       //       builder: (context, userSnapshot) {
                  //       //         if (userSnapshot.connectionState ==
                  //       //             ConnectionState.waiting) {
                  //       //           return CircularProgressIndicator();
                  //       //         } else if (userSnapshot.hasError) {
                  //       //           return Text('error: ${userSnapshot.error}');
                  //       //         } else {
                  //       //           final userData = userSnapshot.data;
                  //       //           // Do something with userData from USER collection
                  //       //           return Text(userData!['UserName']);
                  //       //         }
                  //       //       },
                  //       //     );
                  //       //   },
                  //       // );
                  //       return Column(
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Padding(
                  //                 padding:
                  //                     EdgeInsets.fromLTRB(16.0, 8.0, 0, 4.0),
                  //                 child: Text(
                  //                   'TODOリストメンバー',
                  //                   style: TextStyle(
                  //                     // fontSize: 20.0,
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           Expanded(
                  //             child: Container(
                  //               margin:
                  //                   EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
                  //               decoration: BoxDecoration(
                  //                 border:
                  //                     Border.all(color: Colors.grey), // 枠線の色を設定
                  //                 // borderRadius: BorderRadius.all(
                  //                 //     Radius.circular(8.0)), // 枠線の角を丸める
                  //               ),
                  //               child: Column(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(8.0),
                  //                       child: ListView.builder(
                  //                         shrinkWrap:
                  //                             true, // ListViewをコンテナの高さに合わせる
                  //                         physics:
                  //                             NeverScrollableScrollPhysics(), // スクロールを無効にする
                  //                         itemCount: uidList.length,
                  //                         itemBuilder: (context, index) {
                  //                           final uid = uidList[index];
                  //                           return FutureBuilder<
                  //                               DocumentSnapshot>(
                  //                             future: FirebaseFirestore.instance
                  //                                 .collection('USER')
                  //                                 .doc(uid)
                  //                                 .get(),
                  //                             builder: (context, userSnapshot) {
                  //                               if (userSnapshot
                  //                                       .connectionState ==
                  //                                   ConnectionState.waiting) {
                  //                                 return CircularProgressIndicator();
                  //                               } else if (userSnapshot
                  //                                   .hasError) {
                  //                                 return Text(
                  //                                     'error: ${userSnapshot.error}');
                  //                               } else {
                  //                                 final userData =
                  //                                     userSnapshot.data;
                  //                                 return ListTile(
                  //                                   leading: CircleAvatar(
                  //                                     // 画像を表示するなど、アイコンにしたいものを設定
                  //                                     // e.g., backgroundImage: NetworkImage(userData['imageUrl']),
                  //                                     child: Text(userData![
                  //                                         'UserName']), // ユーザー名の最初の文字を表示
                  //                                   ),
                  //                                   title: Text(userData[
                  //                                       'UserName']), // ユーザー名を表示
                  //                                   subtitle: Text(userData[
                  //                                       'UserName']), // メールアドレスを表示
                  //                                   trailing: Visibility(
                  //                                     visible: uid ==
                  //                                         todoList[
                  //                                             'Administrator'], // todoListIdが空の場合に表示
                  //                                     child: Icon(
                  //                                       Icons.emoji_events,
                  //                                       color: Colors
                  //                                           .amber.shade600,
                  //                                     ),
                  //                                   ),
                  //                                   // タップされたときの動作を設定
                  //                                   onTap: () {
                  //                                     // タップされたときの処理を記述
                  //                                   },
                  //                                 );
                  //                               }
                  //                             },
                  //                           );
                  //                         },
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Container(
                  //                     margin:
                  //                         EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                  //                     child: ElevatedButton(
                  //                       onPressed: () {
                  //                         _showInviteDialog();
                  //                       },
                  //                       child: Text('招待'),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     }
                  //   },
                  // )),
                  //     child: FutureBuilder<Map<String, dynamic>>(
                  //   future:
                  //       TodoListDataService.getTodoListData(widget.todoListId),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return CircularProgressIndicator();
                  //     } else if (snapshot.hasError) {
                  //       return Text('error: ${snapshot.error}');
                  //     } else {
                  //       final userData = snapshot.data;

                  //       return Text(userData.toString());
                  //     }
                  //   },
                  // )),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.fromLTRB(16.0, 0.0, 0, 0),
                  //       child: Text(
                  //         '管理者設定',
                  //         style: TextStyle(
                  //           // fontSize: 20.0,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey), // 枠線の色を設定
                  //     // borderRadius: BorderRadius.all(
                  //     //     Radius.circular(8.0)), // 枠線の角を丸める
                  //   ),
                  //   child: Container(
                  //     margin: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  //     child: Row(
                  //       children: [
                  //         Text('メンバーがTODOリスト名を変更できる'),
                  //         Expanded(
                  //           child: Container(),
                  //         ),
                  //         Checkbox(
                  //           value: isChecked,
                  //           // onChanged: todoList['Administrator'] == uid
                  //           //     ? (value) {
                  //           //         setState(() {
                  //           //           isChecked = value!; // チェックボックスに渡す値を更新する
                  //           //           TodoListDataService
                  //           //               .updateTodoListEditingPermission(
                  //           //                   widget.todoListId, value);
                  //           //         });
                  //           //       }
                  //           //     : null, // チェックボックスのonChangedをnullに設定することで無効にする
                  //           onChanged: (value) {
                  //             setState(() {
                  //               isChecked = value!; // チェックボックスに渡す値を更新する
                  //               // TodoListDataService
                  //               //     .updateTodoListEditingPermission(
                  //               //         widget.todoListId, value);
                  //             });
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     RoundButton(
                  //       buttonName: 'キャンセル',
                  //       buttonWidth: 150,
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //     ),
                  //     const SizedBox(
                  //       width: 25,
                  //     ),
                  //     RoundButton(
                  //       buttonName: '決定する',
                  //       buttonWidth: 150,
                  //       onPressed: () {
                  //         createTodoList(_todoListNameController.text, uid);
                  //         // Navigator.pop(context);
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (BuildContext context) => HomePage(),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundButton(
                          buttonName: 'キャンセル',
                          buttonWidth: 150,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // const SizedBox(
                        //   width: 25,
                        // ),
                        RoundButton(
                          buttonName: '登録する',
                          buttonWidth: 150,
                          onPressed: () async {
                            // _createAccount(context, _idController.text,
                            //     _passController.text);
                            // print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
                            // print(_todoListNameController.text);
                            // // print(isChecked);
                            // print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
                            await createTodoList(
                                _todoListNameController.text, uid);
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return TodoListAdminPage();
                                },
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  // 右から左
                                  final Offset begin = Offset(1.0, 0.0);
                                  // 左から右
                                  // final Offset begin = Offset(-1.0, 0.0);
                                  final Offset end = Offset.zero;
                                  final Animatable<Offset> tween =
                                      Tween(begin: begin, end: end).chain(
                                          CurveTween(curve: Curves.easeInOut));
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AdMobBanner(),
        ],
      ),
    );
  }

  Future<void> createTodoList(String todoListName, String? uid) async {
    var uuid = Uuid();
    var uuidForTodoListId = uuid.v4();

    // // Firestoreのコレクション参照
    // CollectionReference users = FirebaseFirestore.instance.collection('USER');

    // DocumentReference docRef = users.doc(uid);

    // 追加するデータ
    String date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    // Map<String, dynamic> newData = {
    //   date + '-' + uuidForTodoListId: todoListName, // 新しいフィールドと値
    // };
    String todolistID = '$date-$uuidForTodoListId';

    print(date + todoListName + todolistID);

    await UserDataService.addTodoListForUserData(
        uid!, todolistID, todoListName);

    Map<String, dynamic> todolistRow = {
      "TodoListName": todoListName,
      "Administrator": uid,
      "UserIDs": [uid],
      "EditingPermission": 0,
      "CreatedAt": Timestamp.fromDate(DateTime.now()),
      "UpdatedAt": Timestamp.fromDate(DateTime.now()),
    };
    print(todolistRow);
    await TodoListDataService.createTodoListData(todolistID, todolistRow);

    // var uuid = Uuid();
    var todoId = uuid.v4();

    Map<String, dynamic> todoRow = {
      "Content": "",
      "isChecked": 0,
      "CreatedAt": Timestamp.fromDate(DateTime.now()),
      "UpdatedAt": Timestamp.fromDate(DateTime.now()),
    };

    // TODOコレクションにドキュメント追加
    await TodoDataService.createTodoData(todolistID, todoId, todoRow);

    // ドキュメントを更新（既存のデータとマージ）
    // docRef.update({
    //   'TodoLists.$date-$uuidForTodoListId': todoListName,
    // }).catchError((error) {
    //   print("ドキュメントの更新中にエラーが発生しました： $error");
    // });

    // await FirebaseFirestore.instance.collection('USER').doc(uid).add({
    //   todoListId: todoListName,
    // });
    // await FirebaseFirestore.instance.collection('USER').doc(uid).set();
  }
}
