import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    String selectedRadioButton = 'button1';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: designW,
                // height: designH,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                // margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: const Center(child: Text('Flex 1')),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('ボタン1'),
                    value: 'button1',
                    groupValue: selectedRadioButton,
                    onChanged: (value) {
                      setState(() {
                        selectedRadioButton = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('ボタン2'),
                    value: 'button2',
                    groupValue: selectedRadioButton,
                    onChanged: (value) {
                      setState(() {
                        selectedRadioButton = value.toString();
                      });
                    },
                  ),
                ),
                // 他のラジオボタンがあればここに追加
              ],
            ),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 244, 125, 164),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 3)),
                          hintText: 'メールアドレス',
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
                          hintText: 'パスワード',
                        ),
                        obscureText: true,
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
                          buttonName: 'アカウント登録する',
                          buttonWidth: 150,
                          onPressed: () {
                            _createAccount(context, _idController.text,
                                _passController.text);
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) => HomePage(),
                            //   ),
                            // );
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
      ),
    );
  }

  void _createAccount(BuildContext context, String id, String pass) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: id, password: pass);

      // ユーザー情報の再取得（UIDを取得するため）
      await credential.user?.reload();

      // 更新されたユーザー情報を再度取得
      final updatedUser = FirebaseAuth.instance.currentUser;
      final uid = updatedUser?.uid;

      if (uid != null) {
        String date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        Map<String, dynamic> data = {date + '-' + uid: 'マイリスト'};
        await FirebaseFirestore.instance.collection('USER').doc(uid).set(data);

        // ログイン状態の確認と遷移
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
          );
        }
      } else {
        //TODO UIDが取得できない場合の処理
      }
    }
    // アカウントに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      // パスワードが弱い場合
      if (e.code == 'weak-password') {
        print('パスワードが弱いです');
      }

      // メールアドレスが既に使用中の場合
      else if (e.code == 'email-already-in-use') {
        print('すでに使用されているメールアドレスです');
      }
      // メールアドレスがおかしい場合
      else if (e.code == 'invalid-email') {
        print('メールアドレスが有効ではありません。');
      }
      // その他エラー
      else {
        print('アカウント作成エラー');
      }
    } catch (e) {
      print(e);
    }
  }

  // void _createAccount(BuildContext context, String id, String pass) async {
  //   try {
  //     final credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: id,
  //       password: pass,
  //     );

  //     // ユーザー情報の再取得（UIDを取得するため）
  //     await credential.user?.reload();

  //     // 更新されたユーザー情報を再度取得
  //     final updatedUser = FirebaseAuth.instance.currentUser;
  //     final uid = updatedUser?.uid;

  //     if (uid != null) {
  //       String date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
  //       Map<String, dynamic> data = {date + '-' + uid: 'マイリスト'};
  //       await FirebaseFirestore.instance.collection('USER').doc(uid).set(data);
  //     } else {
  //       //TODO UIDが取得できない場合の処理
  //     }
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
