import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/database/user_data_service.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListEditPage extends StatefulWidget {
  final String todoListId;

  const TodoListEditPage({
    Key? key,
    required this.todoListId,
  }) : super(key: key);

  @override
  State<TodoListEditPage> createState() => _TodoListEditPageState();
}

class _TodoListEditPageState extends State<TodoListEditPage> {
  final TextEditingController _todoListNameController = TextEditingController();
  // final TextEditingController _passController = TextEditingController();

  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    // _initSharedPreferencesData();
    _adMob.load();
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(200);
    final designH = screen.designH(200);

    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('ABC'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('TODOリスト名'),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _todoListNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 3)),
                        hintText: 'TodoList名',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundButton(
                        buttonName: 'キャンセル',
                        buttonWidth: 150,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      RoundButton(
                        buttonName: '決定する',
                        buttonWidth: 150,
                        onPressed: () {
                          createTodoList(_todoListNameController.text, uid);
                          // Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(),
                            ),
                          );
                        },
                      ),
                    ],
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
    var todoListId = uuid.v4();

    // Firestoreのコレクション参照
    CollectionReference users = FirebaseFirestore.instance.collection('USER');

    DocumentReference docRef = users.doc(uid);

    // 追加するデータ
    String date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    Map<String, dynamic> newData = {
      date + '-' + todoListId: todoListName, // 新しいフィールドと値
    };

    // ドキュメントを更新（既存のデータとマージ）
    docRef.update({
      'TodoLists.$date-$todoListId': todoListName,
    }).catchError((error) {
      print("ドキュメントの更新中にエラーが発生しました： $error");
    });

    // await FirebaseFirestore.instance.collection('USER').doc(uid).add({
    //   todoListId: todoListName,
    // });
    // await FirebaseFirestore.instance.collection('USER').doc(uid).set();
  }
}
