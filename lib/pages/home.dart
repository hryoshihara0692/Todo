// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:todo/components/ad_mob.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/database/todo_item.dart';
import 'package:todo/widgets/side_menu.dart';

import 'package:uuid/uuid.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> todoItemsList = [];

  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    _queryALL();
    _adMob.load();
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

  final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

  // 登録ボタンクリック
  void _insert() async {
    var uuid = Uuid();
    var todoId = uuid.v4();

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: todoId,
      DatabaseHelper.columnTodoListId: uid,
      DatabaseHelper.columnContent: '',
      DatabaseHelper.columnIsChecked: 0,
    };
    final id = await dbHelper.insert(row);
    print('登録しました。id: $id');
    _queryALL();
  }

  // 照会ボタンクリック
  void _queryALL() async {
    final allRows = await dbHelper.queryAllRows();
    print('全てのデータを照会しました。');

    // データベースから取得した行データをTodoItemに変換してリストに追加
    List<TodoItem> tempTodoItemList = allRows.map(
      (row) {
        print(row);
        return TodoItem(
          id: row['_id'],
          todoListId: row['todoListId'],
          content: row['content'],
          isChecked: row['isChecked'],
          controller: TextEditingController(text: row['content']),
        );
      },
    ).toList();

    if(tempTodoItemList.isEmpty){
      _insert();
    }

    setState(
      () {
        todoItemsList = tempTodoItemList;
      },
    );
  }

  void _updateContent(String id, String content) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnContent: content,
      // DatabaseHelper.columnIsChecked: 1,
    };
    final rowsAffected = await dbHelper.update(row);
    print('更新しました。 ID：$rowsAffected ');
    // _query();
  }

  void _updateCheck(String id, int isChecked) async {
    // int changedIsChecked = isChecked == 1 ? 0 : 1;
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      // DatabaseHelper.columnContent: content,
      DatabaseHelper.columnIsChecked: isChecked,
    };

    final rowsAffected = await dbHelper.update(row);
    print('更新しました。 ID：$rowsAffected ');
    // _query();
  }

  // 削除ボタンクリック
  void _delete(String id) async {
    // final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('削除しました。 $rowsDeleted ID: $id');
    _queryALL();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  // color: Colors.white,
                  child: Scrollbar(
                    thickness: 20,
                    thumbVisibility: true,
                    child: ListView.builder(
                      padding: EdgeInsets.only(right: 25.0),
                      itemCount: todoItemsList.length,
                      itemBuilder: (context, index) {
                        TodoItem item = todoItemsList[index];
                        // print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                        // print(item);
                        // print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                        //チェックボックス外れてる＝普通のテキストボックス
                        if (item.isChecked == 0) {
                          return Material(
                            color: Color.fromARGB(255, 122, 175, 228),
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                tileColor: Color.fromARGB(255, 255, 255, 255),
                                contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                                leading: Checkbox(
                                  onChanged: (value) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    // チェックボックスが変更されたときの処理
                                    setState(() {
                                      item.isChecked = value! ? 1 : 0;
                                    });
                                    _updateCheck(item.id, item.isChecked);
                                  },
                                  value: item.isChecked == 1,
                                ),
                                title: Focus(
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus) {
                                      print("==========================================");
                                      print("フォーカス外れました");
                                      print(item.controller.text);
                                      print("==========================================");
                                      _updateContent(item.id, item.controller.text);
                                    }
                                  },
                                  child: TextField(
                                    controller: item.controller,
                                    onChanged: (value) {},
                                    onEditingComplete: () {
                                      print("==========================================");
                                      print("onEditingComplete");
                                      print("==========================================");
                                      _updateContent(item.id, item.controller.text);
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    // アイテムを削除する処理
                                    _delete(item.id);
                                  },
                                ),
                                dense: true,
                              ),
                            ),
                          );
                        } else {
                          //チェックボックスオン＝読み取り専用のテキストボックス
                          return Material(
                            color: Color.fromARGB(255, 122, 175, 228),
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                tileColor: Color.fromARGB(255, 141, 141, 141),
                                contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                                leading: Checkbox(
                                  onChanged: (value) {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    // チェックボックスが変更されたときの処理
                                    setState(() {
                                      item.isChecked = value! ? 1 : 0;
                                    });
                                    _updateCheck(item.id, item.isChecked);
                                  },
                                  value: item.isChecked == 1,
                                ),
                                title: Focus(
                                  onFocusChange: (hasFocus) {
                                    if (!hasFocus) {
                                      print("==========================================");
                                      print("フォーカス外れました");
                                      print(item.controller.text);
                                      print("==========================================");
                                      _updateContent(item.id, item.controller.text);
                                    }
                                  },
                                  child: TextField(
                                    readOnly: true,
                                    controller: item.controller,
                                    onChanged: (value) {},
                                    onEditingComplete: () {
                                      print("==========================================");
                                      print("onEditingComplete");
                                      print("==========================================");
                                      _updateContent(item.id, item.controller.text);
                                      FocusScope.of(context).requestFocus(FocusNode());
                                    },
                                    style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: const Color.fromARGB(255, 65, 65, 65),
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    // アイテムを削除する処理
                                    _delete(item.id);
                                  },
                                ),
                                dense: true,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                child: Text(
                  'Query',
                  style: TextStyle(fontSize: 35),
                ),
                onPressed: _queryALL,
              ),
              ElevatedButton(
                child: Text(
                  'Insert',
                  style: TextStyle(fontSize: 35),
                ),
                onPressed: _insert,
              ),
              // Admob
              FutureBuilder(
                future: AdSize.getAnchoredAdaptiveBannerAdSize(
                    Orientation.portrait,
                    MediaQuery.of(context).size.width.truncate()),
                builder: (BuildContext context,
                    AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      width: double.infinity,
                      child: _adMob.getAdBanner(),
                    );
                  } else {
                    return Container(
                      height: _adMob.getAdBannerHeight(),
                      color: Colors.white,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
