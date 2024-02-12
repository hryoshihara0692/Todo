import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/todo_data_service.dart';
import 'package:todo/database/todo_item.dart';

class TodoListFirestore extends StatefulWidget {
  TodoListFirestore({Key? key}) : super(key: key);

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
    return StreamBuilder<QuerySnapshot>(
      stream: getStream(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Text('empty');
        }
        final documents = snapshot.data!.docs;
        // final datas = snapshot.data!.docs.map((doc) => doc.data());

        return Expanded(
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
                    controller: TextEditingController(
                        text: documents[index]['Content']),
                  );
                  return Card(
                    // key: ValueKey(item.id),
                    color: item.isChecked == 1
                        ? Color.fromARGB(255, 141, 141, 141)
                        : Colors.white,

                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      // leading: Checkbox(
                      //   onChanged: (value) {
                      //     setState(() {
                      //       item.isChecked = value! ? 1 : 0;
                      //     });
                      //     _updateCheck(item.id, item.isChecked);
                      //   },
                      //   value: item.isChecked == 1,
                      // ),
                      leading: Checkbox(
                        onChanged: (value) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          print(
                              "------------------CheckBoxタップしてます------------------");
                          // FocusScope.of(context)
                          //     .requestFocus(FocusNode());
                          // チェックボックスが変更されたときの処理
                          setState(() {
                            item.isChecked = value! ? 1 : 0;
                          });
                          TodoDataService.updateTodoIsCheckedData(
                              item.id, item.isChecked);
                          // _updateCheck(item.id, item.isChecked);
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
                            print("==========================================");
                            print("onEditingComplete");
                            print("==========================================");
                            TodoDataService.updateTodoContentData(
                                item.id, item.controller.text);
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        // onPressed: () => _delete(item.id),
                        onPressed: () => TodoDataService.deleteTodoData(item.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Stream<QuerySnapshot> getStream() {
    final db = FirebaseFirestore.instance;
    //TODO notkaraユーザを直指定中（TodoListIDを変数で）
    final collectionRef = db
        .collection('TODO')
        .where('TodoListID', isEqualTo: 'WINDHJOqoOPV8Q7jq10eMTv0ESD2');
    return collectionRef.snapshots();
  }
}
