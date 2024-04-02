import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todo/database/todo_data_service.dart';
import 'package:todo/database/todo_item.dart';
import 'package:todo/pages/settings.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListFirestore extends StatefulWidget {
  final String todoListId;
  final String sortColumnTodoValue;
  final bool descendingTodoValue;

  TodoListFirestore({
    Key? key,
    required this.todoListId,
    required this.sortColumnTodoValue,
    required this.descendingTodoValue,
  }) : super(key: key);

  @override
  _TodoListFirestoreState createState() => _TodoListFirestoreState();
}

class _TodoListFirestoreState extends State<TodoListFirestore> {
  bool _isShowingSnackbar = false;

  final deleteButtonModeSPKeyName = 'deleteButtonMode';

  String _deleteButtonModeValue = 'long';

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
    if (prefs.containsKey(deleteButtonModeSPKeyName)) {
      setState(() {
        final deleteButtonModeValue =
            prefs.getString(deleteButtonModeSPKeyName);
        _deleteButtonModeValue = deleteButtonModeValue!;
      });
    }
  }

  void showDeleteButtonSnackbar(String deleteButtonModeName) {
    String modeName = '';
    if (deleteButtonModeName == 'long') {
      modeName = '長押し';
    } else if (deleteButtonModeName == 'single') {
      modeName = '1回タップ';
    } else if (deleteButtonModeName == 'double') {
      modeName = '2回タップ';
    }

    if (!_isShowingSnackbar) {
      setState(() {
        _isShowingSnackbar = true;
      });
      final snackBar = SnackBar(
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('削除ボタンは$modeNameで実行できます。'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('設定で変更可能です。'),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                        Colors.blue,
                      ),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(decoration: TextDecoration.underline))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // （2） 実際に表示するページ(ウィジェット)を指定する
                        builder: (context) => SettingsPage(),
                      ),
                    );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Text('設定画面へ'),
                )
              ],
            ),
          ],
        ),
        duration: const Duration(seconds: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(left: 23, right: 23, bottom: 23),
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar)
          .closed
          .then((reason) {
        setState(() {
          _isShowingSnackbar = false;
        });
      });
    }
  }

  Map<String, FocusNode> focusNodes = {};

  @override
  Widget build(BuildContext context) {
    if (widget.todoListId == null || widget.todoListId == '') {
      return Text('${widget.todoListId}ドロップダウンリストで選択しているIDを受け取れていません');
    }
    return StreamBuilder<QuerySnapshot>(
      // stream: getStream(widget.todoListId, widget.sortColumnTodoValue,
      //     widget.descendingTodoValue),
      stream: TodoDataService.getTodoData(widget.todoListId, widget.sortColumnTodoValue,
          widget.descendingTodoValue),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.data == null) {
          ///
          /// 処理を待つ表示にする
          ///
          return const Text('empty');
        } else if (snapshot.data!.docs.isEmpty) {

          // if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          //UUID生成
          var uuid = Uuid();
          var todoId = uuid.v4();
          Map<String, dynamic> row = {
            // "TodoListID": widget.todoListId,
            "Content": '',
            "isChecked": 0,
            "CreatedAt": Timestamp.fromDate(DateTime.now()),
            "UpdatedAt": Timestamp.fromDate(DateTime.now()),
          };

          TodoDataService.createTodoData(widget.todoListId, todoId, row);

          ///
          /// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
          /// バグ2024031201
          /// 下のreturnに来る可能性を潰す
          /// ※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※
          ///
          return const Text('empty');
        }
        final documents = snapshot.data!.docs;

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  // color: Colors.white,
                  child: Scrollbar(
                    thickness: 20,
                    thumbVisibility: true,
                    child: ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        TodoItem item = TodoItem(
                          id: documents[index].id,
                          // todoListId: documents[index]['TodoListID'],
                          content: documents[index]['Content'],
                          isChecked: documents[index]['isChecked'],
                          createdAt: documents[index]['CreatedAt'].toDate(),
                          updatedAt: documents[index]['UpdatedAt'].toDate(),
                          controller: TextEditingController(
                              text: documents[index]['Content']),
                          focusNode: FocusNode(),
                        );
                        // documents[index] に focusNode を追加
                        focusNodes[documents[index].id] = item.focusNode;

                        return Card(
                          color: item.isChecked == 1
                              ? Color.fromARGB(255, 141, 141, 141)
                              : Colors.white,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Checkbox(
                              onChanged: (value) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                // チェックボックスが変更されたときの処理
                                setState(() {
                                  item.isChecked = value! ? 1 : 0;
                                });
                                TodoDataService.updateTodoIsCheckedData(
                                    widget.todoListId, item.id, item.isChecked);
                              },
                              value: item.isChecked == 1,
                            ),
                            title: Focus(
                              onFocusChange: (hasFocus) async {
                                if (!hasFocus) {
                                  if (item.content != item.controller.text) {
                                    await TodoDataService.updateTodoContentData(
                                        widget.todoListId, item.id, item.controller.text);
                                  }
                                }
                              },
                              child: TextFormField(
                                focusNode: item.focusNode,
                                readOnly: item.isChecked == 1,
                                controller: item.controller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // labelText: 'Enter your text',
                                  // labelStyle: TextStyle(
                                  //     fontFamily: 'NotoSansJP-Medium'),
                                ),
                                // style:
                                //     TextStyle(fontFamily: 'NotoSansJP-Medium'),
                                onEditingComplete: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  await TodoDataService.updateTodoContentData(
                                      widget.todoListId, item.id, item.controller.text);
                                  // 編集が完了したら次のフォーカスに移動する
                                  if (index < documents.length - 1) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    FocusScope.of(context).requestFocus(
                                        focusNodes[documents[index + 1].id]);
                                  } else {
                                    // // リストの最後の場合、キーボードを閉じる
                                    // FocusScope.of(context).unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    //UUID生成
                                    var uuid = Uuid();
                                    var todoId = uuid.v4();
                                    Map<String, dynamic> row = {
                                      // "TodoListID": widget.todoListId,
                                      "Content": '',
                                      "isChecked": 0,
                                      "CreatedAt":
                                          Timestamp.fromDate(DateTime.now()),
                                      "UpdatedAt":
                                          Timestamp.fromDate(DateTime.now()),
                                    };
                                    await TodoDataService.createTodoData(
                                        widget.todoListId, todoId, row);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    FocusScope.of(context).requestFocus(
                                        focusNodes[documents[index + 1].id]);
                                  }
                                },
                              ),
                            ),
                            //削除ボタン
                            trailing: GestureDetector(
                              onLongPress: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (_deleteButtonModeValue == 'long') {
                                  TodoDataService.deleteTodoData(widget.todoListId,item.id);
                                } else {
                                  showDeleteButtonSnackbar(
                                      _deleteButtonModeValue);
                                }
                              },
                              onDoubleTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (_deleteButtonModeValue == 'double') {
                                  TodoDataService.deleteTodoData(widget.todoListId,item.id);
                                } else {
                                  showDeleteButtonSnackbar(
                                      _deleteButtonModeValue);
                                }
                              },
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (_deleteButtonModeValue == 'single') {
                                    TodoDataService.deleteTodoData(widget.todoListId,item.id);
                                  } else {
                                    showDeleteButtonSnackbar(
                                        _deleteButtonModeValue);
                                  }
                                },
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 500.ms);
                      },
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
                      FocusScope.of(context).requestFocus(FocusNode());
                      //UUID生成
                      var uuid = Uuid();
                      var uuIdForTodo = uuid.v4();
                      Map<String, dynamic> row = {
                        // "TodoListID": widget.todoListId,
                        "Content": '',
                        "isChecked": 0,
                        "CreatedAt": Timestamp.fromDate(DateTime.now()),
                        "UpdatedAt": Timestamp.fromDate(DateTime.now()),
                      };
                      TodoDataService.createTodoData(widget.todoListId, uuIdForTodo, row);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.post_add),
                        Text(' 追 加 '),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
