import 'package:flutter/material.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/database/todo_item.dart';
import 'package:uuid/uuid.dart';

class TodoListSqflite extends StatefulWidget {
  TodoListSqflite({Key? key}) : super(key: key);

  @override
  _TodoListSqfliteState createState() => _TodoListSqfliteState();
}

class _TodoListSqfliteState extends State<TodoListSqflite> {
  List<TodoItem> todoItemsList = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _queryAllFromSQLite();
  }

  //画面消失時動作
  @override
  void dispose() {
    super.dispose();
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

  void _insert() async {
    //UUID生成
    var uuid = Uuid();
    var uuIdForTodo = uuid.v4();

    //SQLite用データ作成
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: uuIdForTodo,
      DatabaseHelper.columnTodoListId: '',
      DatabaseHelper.columnContent: '',
      DatabaseHelper.columnIsChecked: 0,
    };
    await dbHelper.insert(row);

    // リストに新しいTodoアイテムを直接追加
    TodoItem newItem = TodoItem(
      id: uuIdForTodo,
      todoListId: '',
      content: '',
      isChecked: 0,
      controller: TextEditingController(text: ''),
    );
    setState(() {
      todoItemsList.add(newItem);
    });
  }

  void _updateCheck(String id, int isChecked) async {
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
  }

  void _updateContent(String id, String content) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnContent: content,
    };
    await dbHelper.update(row);
  }

  // 削除ボタンクリック
  void _delete(String id) async {
    await dbHelper.delete(id);
    _queryAllFromSQLite();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
