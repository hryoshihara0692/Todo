import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/database/todo_data_service.dart';
import 'package:todo/database/todolist_data_service.dart';
import 'package:todo/database/user_data_service.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
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

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(designH),
          child: AppBar(
            // backgroundColor: Colors.brown,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // width: designW,
                  height: screen.designH(125),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                  // margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: const Center(child: Text('Flex 1')),
                ),
                Container(
                  // color: Colors.amber,
                  height: kToolbarHeight,
                  child: TabBar(
                    // indicatorSize: ,
                    indicatorColor: Colors.blue,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'メールアドレスで登録',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    // color: Colors.pink,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _idController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3)),
                              hintText: 'mail_address@sample.com',
                              labelText: 'メールアドレス',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _passController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 3)),
                              hintText: 'ex) Password1234',
                              labelText: 'パスワード',
                            ),
                            obscureText: true,
                            obscuringCharacter: '*',
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
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
                              buttonName: '登録する',
                              buttonWidth: 150,
                              onPressed: () {
                                _createAccount(context, _idController.text,
                                    _passController.text, 'AOYAGI');
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
          ],
        ),
      ),
    );
  }

  void _createAccount(BuildContext context, String id, String pass, String userName) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: id,
        password: pass,
      );

      // ユーザー情報の再取得（UIDを取得するため）
      await credential.user?.reload();

      // 更新されたユーザー情報を再度取得
      final updatedUser = FirebaseAuth.instance.currentUser;
      final uid = updatedUser?.uid;

      if (uid != null) {
        String todoListID =
            DateFormat('yyyyMMddHHmmss').format(DateTime.now()) + '-' + uid;

        // USERコレクション用データ
        Map<String, dynamic> userRow = {
          "UserName": userName,
          "TodoLists": {todoListID: "マイリスト"},
          "CreatedAt": Timestamp.fromDate(DateTime.now()),
          "UpdatedAt": Timestamp.fromDate(DateTime.now()),
          "IconNo": '001',
          "IconFileName": "",
        };

        // USERコレクションにドキュメント追加
        await UserDataService.createUserData(uid, userRow);

        Map<String, dynamic> todolistRow = {
          "TodoListName": "マイリスト",
          "Administrator": uid,
          "EditingPermission": 0,
          "CreatedAt": Timestamp.fromDate(DateTime.now()),
          "UpdatedAt": Timestamp.fromDate(DateTime.now()),
        };

        // TODOLISTコレクションにドキュメント追加
        await TodoListDataService.createTodoListData(todoListID, todolistRow);

        var uuid = Uuid();
        var todoId = uuid.v4();

        Map<String, dynamic> todoRow = {
          "Content": "",
          "isChecked": 0,
          "CreatedAt": Timestamp.fromDate(DateTime.now()),
          "UpdatedAt": Timestamp.fromDate(DateTime.now()),
        };

        // TODOコレクションにドキュメント追加
        await TodoDataService.createTodoData(todoListID, todoId, todoRow);


        // Map<String, dynamic> data = {date + '-' + uid: 'マイリスト'};
        // await FirebaseFirestore.instance.collection('USER').doc(uid).set(data);

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return HomePage();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // 右から左
              final Offset begin = Offset(1.0, 0.0);
              // 左から右
              // final Offset begin = Offset(-1.0, 0.0);
              final Offset end = Offset.zero;
              final Animatable<Offset> tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: Curves.easeInOut));
              final Animation<Offset> offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      } else {
        //TODO UIDが取得できない場合の処理
      }
    }

    /// アカウントに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      /// パスワードが弱い場合
      if (e.code == 'weak-password') {
        print('パスワードが弱いです');
      }

      /// メールアドレスが既に使用中の場合
      else if (e.code == 'email-already-in-use') {
        print('すでに使用されているメールアドレスです');
      }
      // メールアドレスがおかしい場合
      else if (e.code == 'invalid-email') {
        print('メールアドレスが有効ではありません。');
      }

      /// その他エラー
      else {
        print('アカウント作成エラー');
      }
    } catch (e) {
      print(e);
    }
  }
}
