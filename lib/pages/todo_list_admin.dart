import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TodoListAdminPage extends StatefulWidget {
  // const AccountRegistrationPage({super.key});
  const TodoListAdminPage({super.key});

  @override
  State<TodoListAdminPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<TodoListAdminPage> {
  final TextEditingController _todoListNameController = TextEditingController();
  // final TextEditingController _passController = TextEditingController();

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

    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: designW,
              // height: designH,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
              child: const Center(child: Text('Flex 1')),
            ),
            // Container(
            //   child: TextField(),
            // ),
            Expanded(
              child: Container(
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const SizedBox(
                      height: 25.0,
                    ),
                    // SizedBox(
                    //   height: 50,
                    //   child: TextField(
                    //     controller: _passController,
                    //     decoration: const InputDecoration(
                    //       border: OutlineInputBorder(
                    //           borderSide: BorderSide(width: 3)),
                    //       hintText: 'パスワード',
                    //     ),
                    //     obscureText: true,
                    //   ),
                    // ),
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
                            // context.push('/');
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        RoundButton(
                          buttonName: 'TodoList登録',
                          buttonWidth: 150,
                          onPressed: () {
                            // context.push('/');
                            // _createAccount(context, _todoListNameController.text,
                            //     _passController.text);
                            createTodoList(_todoListNameController.text, uid);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AdMobBanner(),
            // FutureBuilder(
            //   future: AdSize.getAnchoredAdaptiveBannerAdSize(
            //       Orientation.portrait,
            //       MediaQuery.of(context).size.width.truncate()),
            //   builder: (BuildContext context,
            //       AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot) {
            //     if (snapshot.hasData) {
            //       return SizedBox(
            //         width: double.infinity,
            //         child: _adMob.getAdBanner(),
            //       );
            //     } else {
            //       return Container(
            //         height: _adMob.getAdBannerHeight(),
            //         color: Colors.white,
            //       );
            //     }
            //   },
            // ),
          ],
        ),
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
    Map<String, dynamic> newData = {
      todoListId: todoListName, // 新しいフィールドと値
    };

    // ドキュメントを更新（既存のデータとマージ）
    docRef.set(newData, SetOptions(merge: true)).then((value) {
      print("ドキュメントが正常に更新されました");
    }).catchError((error) {
      print("ドキュメントの更新中にエラーが発生しました： $error");
    });

    // await FirebaseFirestore.instance.collection('USER').doc(uid).add({
    //   todoListId: todoListName,
    // });
    // await FirebaseFirestore.instance.collection('USER').doc(uid).set();
  }

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
