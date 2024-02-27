import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/todo_data_service.dart';
import 'package:todo/database/todo_item.dart';
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

  @override
  void initState() {
    super.initState();
  }

  //画面消失時動作
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.todoListId == null || widget.todoListId == '') {
      return Text('${widget.todoListId}ドロップダウンリストで選択しているIDを受け取れていません');
    }
    return StreamBuilder<QuerySnapshot>(
      stream: getStream(widget.todoListId, widget.sortColumnTodoValue, widget.descendingTodoValue),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.data == null) {
          //TODO 初回起動時にここに入ってきてる
          return const Text('empty');
        } else if (snapshot.data!.docs.isEmpty) {
          //UUID生成
          var uuid = Uuid();
          var uuIdForTodo = uuid.v4();
          Map<String, dynamic> row = {
            "TodoListID": widget.todoListId,
            "Content": '',
            "isChecked": 0,
            "CreatedAt": Timestamp.fromDate(DateTime.now()),
            "UpdatedAt": Timestamp.fromDate(DateTime.now()),
          };

          TodoDataService.createTodoData(uuIdForTodo, row);

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
                          todoListId: documents[index]['TodoListID'],
                          content: documents[index]['Content'],
                          isChecked: documents[index]['isChecked'],
                          createdAt: documents[index]['CreatedAt'].toDate(),
                          updatedAt: documents[index]['UpdatedAt'].toDate(),
                          controller: TextEditingController(
                              text: documents[index]['Content']),
                        );
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
                                    item.id, item.isChecked);
                              },
                              value: item.isChecked == 1,
                            ),
                            title: Focus(
                              onFocusChange: (hasFocus) {
                                if (!hasFocus) {
                                  TodoDataService.updateTodoContentData(
                                      item.id, item.controller.text);
                                }
                              },
                              child: TextField(
                                readOnly: item.isChecked == 1,
                                controller: item.controller,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onEditingComplete: () {
                                  TodoDataService.updateTodoContentData(
                                      item.id, item.controller.text);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () =>
                                  TodoDataService.deleteTodoData(item.id),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //UUID生成
                  var uuid = Uuid();
                  var uuIdForTodo = uuid.v4();
                  Map<String, dynamic> row = {
                    "TodoListID": widget.todoListId,
                    "Content": '',
                    "isChecked": 0,
                    "CreatedAt": Timestamp.fromDate(DateTime.now()),
                    "UpdatedAt": Timestamp.fromDate(DateTime.now()),
                  };

                  TodoDataService.createTodoData(uuIdForTodo, row);
                },
                child: Text('追加'),
              ),
            ],
          ),
        );
      },
    );
  }

  /**
   * todoListId : 対象TodoListのID,
   * sortColumnTodo : ソートするカラム,
   * descendingTodo : 昇順(false),降順(true)
   */
  Stream<QuerySnapshot> getStream(String todoListId, String sortColumnTodo, bool descendingTodo) {
  // Stream<QuerySnapshot> getStream(String todoListId) {
    final db = FirebaseFirestore.instance;
    final collectionRef = db
        .collection('TODO')
        .where('TodoListID', isEqualTo: todoListId)
        // .orderBy(sortColumnTodo, descending: descendingTodo)
        // .orderBy('CreatedAt', descending: false);
        .orderBy(sortColumnTodo, descending: descendingTodo);
    return collectionRef.snapshots();
  }
}
