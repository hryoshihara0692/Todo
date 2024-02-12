// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:todo/database/database_helper.dart';
import 'package:todo/database/todo_item.dart';
import 'package:todo/database/todo_data_service.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/category_dropdown.dart';
import 'package:todo/widgets/home/todolist_firestore.dart';
import 'package:todo/widgets/home/todolist_sqflite.dart';
import 'package:todo/widgets/side_menu.dart';

import 'package:uuid/uuid.dart';

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

  // late Stream<QuerySnapshot> _todoStream;



  // //起動時動作
  // @override
  // void initState() {
  //   super.initState();

  //   //DBクエリ
  //   _queryALL();

  //   //Admobロード
  //   _adMob.load();
  // }

  @override
  void initState() {
    super.initState();
    // if (uid != null) {
    //   _todoStream = FirebaseFirestore.instance.collection('TODO').snapshots();
    // } else {
    //   // _queryAllFromSQLite();
    // }
  }

  //画面消失時動作
  @override
  void dispose() {
    super.dispose();
  }

  // //Todo追加処理
  // void _insert() async {
  //   //UUID生成
  //   var uuid = Uuid();
  //   var uuIdForTodo = uuid.v4();

  //   //未ログイン時(SQLite)
  //   if (uid == null) {
  //     //SQLite用データ作成
  //     Map<String, dynamic> row = {
  //       DatabaseHelper.columnId: uuIdForTodo,
  //       DatabaseHelper.columnTodoListId: uid,
  //       DatabaseHelper.columnContent: '',
  //       DatabaseHelper.columnIsChecked: 0,
  //     };
  //     await dbHelper.insert(row);

  //     //ログイン時(Firestore)
  //   } else {
  //     Map<String, dynamic> row = {
  //       "TodoListID": uid,
  //       "Content": '',
  //       "isChecked": 0,
  //     };
  //     TodoDataService.createTodoData(uuIdForTodo, row);
  //   }

  //   //SetStateで作ったrowをtodoItemListに追加すればOK?
  //   _queryALL();
  // }

  void _insert() async {
    //UUID生成
    var uuid = Uuid();
    var uuIdForTodo = uuid.v4();

    //未ログイン時(SQLite)
    if (uid == null) {
      //SQLite用データ作成
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: uuIdForTodo,
        DatabaseHelper.columnTodoListId: uid,
        DatabaseHelper.columnContent: '',
        DatabaseHelper.columnIsChecked: 0,
      };
      await dbHelper.insert(row);

      // リストに新しいTodoアイテムを直接追加
      TodoItem newItem = TodoItem(
        id: uuIdForTodo,
        todoListId: uid,
        content: '',
        isChecked: 0,
        controller: TextEditingController(text: ''),
      );
      setState(() {
        todoItemsList.add(newItem);
      });

      //ログイン時(Firestore)
    } else {
      Map<String, dynamic> row = {
        "TodoListID": uid,
        "Content": '',
        "isChecked": 0,
      };
      TodoDataService.createTodoData(uuIdForTodo, row);

      // リストに新しいTodoアイテムを直接追加
      TodoItem newItem = TodoItem(
        id: uuIdForTodo,
        todoListId: uid,
        content: '',
        isChecked: 0,
        controller: TextEditingController(text: ''),
      );

      setState(() {
        todoItemsList.add(newItem);
      });
    }
  }

  void _queryAllFromSQLite() async {
    final allRows = await dbHelper.queryAllRows();
    List<TodoItem> tempTodoItemList = allRows.map((row) {
      return TodoItem(
        id: row['_id'],
        todoListId: row['todoListId'],
        content: row['content'],
        isChecked: row['isChecked'],
        controller: TextEditingController(text: row['content']),
      );
    }).toList();
    setState(() {
      todoItemsList = tempTodoItemList;
    });
  }

  // //SELECTクエリ実行
  // void _queryALL() async {
  //   final allRows;

  //   //未ログイン時(SQLite)
  //   if (uid == null) {
  //     //SQLiteから全取得
  //     allRows = await dbHelper.queryAllRows();

  //     //戻り値がList<dynamic>になってしまう
  //     List<dynamic> dynamicTodoItemList = allRows.map(
  //       (row) {
  //         return TodoItem(
  //           id: row['_id'],
  //           todoListId: row['todoListId'],
  //           content: row['content'],
  //           isChecked: row['isChecked'],
  //           controller: TextEditingController(text: row['content']),
  //         );
  //       },
  //     ).toList();

  //     //List<dynamic>をList<TodoItem>に変換
  //     List<TodoItem> tempTodoItemList = [];
  //     for (var item in dynamicTodoItemList) {
  //       tempTodoItemList.add(item as TodoItem);
  //     }

  //     //Todoが0の場合、空Todoを追加する
  //     if (tempTodoItemList.isEmpty) {
  //       _insert();
  //     }

  //     //GUI側に反映
  //     setState(
  //       () {
  //         todoItemsList = tempTodoItemList;
  //       },
  //     );

  //     //ログイン時(Firestore)
  //   } else {
  //     //データ全取得
  //     allRows = await TodoDataService.getTodoData(uid);
  //     List<dynamic> dynamicTodoItemList = allRows.map(
  //       (row) {
  //         print(row);
  //         return TodoItem(
  //           id: row['DocumentID'],
  //           todoListId: row['TodoListID'],
  //           content: row['Content'],
  //           isChecked: row['isChecked'],
  //           controller: TextEditingController(text: row['Content']),
  //         );
  //       },
  //     ).toList();

  //     List<TodoItem> tempTodoItemList = [];

  //     for (var item in dynamicTodoItemList) {
  //       tempTodoItemList.add(item as TodoItem);
  //     }

  //     if (tempTodoItemList.isEmpty) {
  //       _insert();
  //     }

  //     setState(
  //       () {
  //         todoItemsList = tempTodoItemList;
  //       },
  //     );
  //   }
  // }

  void _updateContent(String id, String content) async {
    if (uid == null) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: id,
        DatabaseHelper.columnContent: content,
        // DatabaseHelper.columnIsChecked: 1,
      };
      final rowsAffected = await dbHelper.update(row);
      print('更新しました。 ID：$rowsAffected ');
      // _query();
    } else {
      TodoDataService.updateTodoContentData(id, content);
    }
  }

  // void _updateCheck(String id, int isChecked) async {
  //   if (uid == null) {
  //     Map<String, dynamic> row = {
  //       DatabaseHelper.columnId: id,
  //       DatabaseHelper.columnIsChecked: isChecked,
  //     };

  //     final rowsAffected = await dbHelper.update(row);
  //     print('更新しました。 ID：$rowsAffected ');
  //   } else{
  //     TodoDataService.updateTodoIsCheckedData(id, isChecked);
  //   }
  // }

  void _updateCheck(String id, int isChecked) async {
    // データベースに変更を反映
    if (uid == null) {
      // チェックボックスの状態を更新
      setState(() {
        for (var item in todoItemsList) {
          if (item.id == id) {
            item.isChecked = isChecked;
            break;
          }
        }
      });

      Map<String, dynamic> row = {
        DatabaseHelper.columnId: id,
        DatabaseHelper.columnIsChecked: isChecked,
      };

      final rowsAffected = await dbHelper.update(row);
      print('更新しました。 ID：$rowsAffected ');
    } else {
      TodoDataService.updateTodoIsCheckedData(id, isChecked);
    }
  }

  // 削除ボタンクリック
  void _delete(String id) async {
    if (uid == null) {
      final rowsDeleted = await dbHelper.delete(id);
      print('削除しました。 $rowsDeleted ID: $id');
      _queryAllFromSQLite();
    } else {
      TodoDataService.deleteTodoData(id);
    }
    // _queryALL();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: uid != null ? CategoryDropdown() : Text("ログインしてないです"),
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
          //Firestoreで実行時、textfieldフォーカス挙動がおかしいのでNG
          // body: Column(
          //   children: [
          //     Expanded(
          //       child: Container(
          //         padding: EdgeInsets.all(16.0),
          //         color: Color.fromARGB(255, 122, 175, 228),
          //         child: StreamBuilder(
          //           stream: uid == null
          //               ? null
          //               : FirebaseFirestore.instance
          //                   .collection('TODO')
          //                   .where('TodoListID', isEqualTo: uid)
          //                   .snapshots(),
          //           builder: (BuildContext context,
          //               AsyncSnapshot<QuerySnapshot> snapshot) {
          //             if (snapshot == null && uid != null) {
          //               return Center(
          //                 child: CircularProgressIndicator(),
          //               );
          //             }
          //             if (snapshot != null && snapshot.hasError) {
          //               return Text('Error: ${snapshot.error}');
          //             }

          //             if (snapshot != null &&
          //                 snapshot.connectionState == ConnectionState.waiting) {
          //               return Center(
          //                 child: CircularProgressIndicator(),
          //               );
          //             }

          //             final List<DocumentSnapshot> documents =
          //                 snapshot?.data?.docs ?? [];

          //             return Scrollbar(
          //               // thickness: 20,
          //               // thumbVisibility: true,
          //               child: ListView.builder(
          //                 itemCount: uid == null
          //                     ? todoItemsList.length
          //                     : documents.length,
          //                 itemBuilder: (BuildContext context, int index) {
          //                   TodoItem item = uid == null
          //                       ? todoItemsList[index]
          //                       : TodoItem(
          //                           id: documents[index].id,
          //                           todoListId: documents[index]['TodoListID'],
          //                           content: documents[index]['Content'],
          //                           isChecked: documents[index]['isChecked'],
          //                           controller: TextEditingController(
          //                               text: documents[index]['Content']),
          //                         );
          //                   return Card(
          //                     // key: ValueKey(item.id),
          //                     color: item.isChecked == 1
          //                         ? Color.fromARGB(255, 141, 141, 141)
          //                         : Colors.white,

          //                     child: ListTile(
          //                       contentPadding: EdgeInsets.zero,
          //                       // leading: Checkbox(
          //                       //   onChanged: (value) {
          //                       //     setState(() {
          //                       //       item.isChecked = value! ? 1 : 0;
          //                       //     });
          //                       //     _updateCheck(item.id, item.isChecked);
          //                       //   },
          //                       //   value: item.isChecked == 1,
          //                       // ),
          //                       leading: Checkbox(
          //                         onChanged: (value) {
          //                           print(
          //                               "------------------CheckBoxタップしてます------------------");
          //                           // FocusScope.of(context)
          //                           //     .requestFocus(FocusNode());
          //                           // チェックボックスが変更されたときの処理
          //                           setState(() {
          //                             item.isChecked = value! ? 1 : 0;
          //                           });
          //                           _updateCheck(item.id, item.isChecked);
          //                         },
          //                         value: item.isChecked == 1,
          //                       ),
          //                       title: TextField(
          //                         readOnly: item.isChecked == 1,
          //                         controller: item.controller,
          //                         decoration: InputDecoration(
          //                           border: InputBorder.none,
          //                         ),
          //                         onEditingComplete: () {
          //                           print(
          //                               "==========================================");
          //                           print("onEditingComplete");
          //                           print(
          //                               "==========================================");
          //                           if (uid == null) {
          //                             _updateContent(item.id, item.controller.text);
          //                           } else {
          //                             TodoDataService.updateTodoContentData(
          //                                 item.id, item.controller.text);
          //                           }
          //                           FocusScope.of(context)
          //                               .requestFocus(FocusNode());
          //                         },
          //                       ),
          //                       trailing: IconButton(
          //                         icon: Icon(Icons.close),
          //                         onPressed: () => _delete(item.id),
          //                       ),
          //                     ),
          //                   );
          //                 },
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         if (uid == null) ...[
          //           ElevatedButton(
          //             child: Text(
          //               'Query SQLite',
          //               style: TextStyle(fontSize: 18),
          //             ),
          //             onPressed: _queryAllFromSQLite,
          //           ),
          //           ElevatedButton(
          //             child: Text(
          //               'Insert SQLite',
          //               style: TextStyle(fontSize: 18),
          //             ),
          //             onPressed: _insert,
          //           ),
          //         ] else ...[
          //           // ElevatedButton(
          //           //   child: Text(
          //           //     'Query Firestore',
          //           //     style: TextStyle(fontSize: 18),
          //           //   ),
          //           //   onPressed: _queryAllFromFirestore,
          //           // ),
          //           ElevatedButton(
          //             child: Text(
          //               'Insert Firestore',
          //               style: TextStyle(fontSize: 18),
          //             ),
          //             onPressed: _insert,
          //           ),
          //         ],
          //       ],
          //     ),
          //     // Admob
          //     FutureBuilder(
          //       future: AdSize.getAnchoredAdaptiveBannerAdSize(
          //           Orientation.portrait,
          //           MediaQuery.of(context).size.width.truncate()),
          //       builder: (BuildContext context,
          //           AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot) {
          //         if (snapshot.hasData) {
          //           return SizedBox(
          //             width: double.infinity,
          //             child: _adMob.getAdBanner(),
          //           );
          //         } else {
          //           return Container(
          //             height: _adMob.getAdBannerHeight(),
          //             color: Colors.white,
          //           );
          //         }
          //       },
          //     ),
          //   ],
          // ),

          //※Local sqfliteはOK firestoreは動的なデータ取得不可なコード
          body: Column(
            children: [
              //※Sqflite用のボタン残してます
              // ElevatedButton(
              //   child: Text(
              //     'Query',
              //     style: TextStyle(fontSize: 35),
              //   ),
              //   // onPressed: _queryALL,
              //   onPressed: _queryAllFromSQLite,
              // ),
              // ElevatedButton(
              //   child: Text(
              //     'Insert',
              //     style: TextStyle(fontSize: 35),
              //   ),
              //   onPressed: _insert,
              // ),

              uid != null ? TodoListFirestore() : TodoListSqflite(),

              // Admob
              AdMobBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
