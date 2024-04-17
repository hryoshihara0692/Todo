import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _idFocusNode = FocusNode(); // 追加: フォーカスノード

  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    _adMob.load();
    // 追加: テキストフィールドにフォーカスを当てる
    Future.delayed(Duration.zero, () {
      _idFocusNode.requestFocus();
    });
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
                        text: 'メールアドレスでログイン',
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
                    // color: Colors.yellow,
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
                            focusNode: _idFocusNode, // 追加: フォーカスノードを設定
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
                                // context.push('/');
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            RoundButton(
                              buttonName: 'ログイン',
                              buttonWidth: 150,
                              onPressed: () {
                                // context.push('/');
                                _loginAccount(context, _idController.text,
                                    _passController.text);
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

  void _loginAccount(BuildContext context, String id, String pass) async {
    try {
      /// credential にはアカウント情報が記録される
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id,
        password: pass,
      );

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return HomePage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
    }

    /// アカウントに失敗した場合のエラー処理
    on FirebaseAuthException catch (e) {
      /// パスワードが弱い場合
      if (e.code == 'invalid-email') {
        print('メールアドレスが有効ではありません');
      }

      /// メールアドレスが既に使用中の場合
      else if (e.code == 'user-disabled') {
        print('入力したアドレスは無効になっています');
      }
      // メールアドレスがおかしい場合
      else if (e.code == 'user-not-found') {
        print('メールアドレスが登録されていません。新規登録してください。');
      } else if (e.code == 'wrong-password') {
        print('パスワードが正しくありません');
      }

      /// その他エラー
      else {
        print('ログインエラー$e');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    print('AppSignInを実行');
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(appleCredential);
    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    // // ここに画面遷移をするコードを書く!
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => NextPage()));
    // print(appleCredential);

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }
}
