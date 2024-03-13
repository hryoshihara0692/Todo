import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sign_button/sign_button.dart';
import 'package:todo/pages/home.dart';
import 'package:todo/pages/create_account.dart';
import 'package:todo/pages/login.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class UserAdminPage extends StatefulWidget {
  final bool isNewAccount;

  const UserAdminPage({Key? key, required this.isNewAccount}) : super(key: key);

  @override
  State<UserAdminPage> createState() => _UserAdminPageState();
}

class _UserAdminPageState extends State<UserAdminPage> {

  late int initialTabIndex;
  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    initialTabIndex = widget.isNewAccount ? 1 : 0;
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
    final designH = screen.designH(400);

    return DefaultTabController(
      initialIndex: initialTabIndex,
      length: 2,
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
                  height: screen.designH(250),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 50),
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
                        text: 'ログイン',
                      ),
                      Tab(
                        text: '新規登録',
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
            ///
            /// ログイン側
            ///
            Container(
              // color: Colors.green,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // color: Colors.amber,
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: SignInButton(
                            buttonType: ButtonType.appleDark,
                            imagePosition: ImagePosition.left,
                            buttonSize: ButtonSize.large,
                            btnTextColor: Colors.white,
                            btnColor: Colors.black,
                            width: 300,
                            btnText: 'AppleID でログイン',
                            onPressed: () async {
                              await signInWithApple();
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return HomePage();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    // 右から左
                                    final Offset begin = Offset(1.0, 0.0);
                                    // 左から右
                                    // final Offset begin = Offset(-1.0, 0.0);
                                    final Offset end = Offset.zero;
                                    final Animatable<Offset> tween =
                                        Tween(begin: begin, end: end).chain(
                                            CurveTween(
                                                curve: Curves.easeInOut));
                                    final Animation<Offset> offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          // color: Colors.blueAccent,
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: SignInButton(
                            buttonType: ButtonType.google,
                            imagePosition: ImagePosition.left,
                            buttonSize: ButtonSize.large,
                            btnTextColor: Colors.black87,
                            btnColor: Colors.white,
                            width: 300,
                            btnText: 'Google でログイン',
                            onPressed: () async {
                              await signInWithGoogle();
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return HomePage();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    // 右から左
                                    final Offset begin = Offset(1.0, 0.0);
                                    // 左から右
                                    // final Offset begin = Offset(-1.0, 0.0);
                                    final Offset end = Offset.zero;
                                    final Animatable<Offset> tween =
                                        Tween(begin: begin, end: end).chain(
                                            CurveTween(
                                                curve: Curves.easeInOut));
                                    final Animation<Offset> offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          // color: Colors.deepOrange,
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: SignInButton(
                            // buttonType: ButtonType.mail,
                            buttonType: ButtonType.custom,
                            customImage: CustomImage('assets/images/mail.png'),
                            imagePosition: ImagePosition.left,
                            buttonSize: ButtonSize.large,
                            btnColor: Color.fromARGB(255, 202, 233, 248),
                            btnTextColor: Colors.black87,
                            width: 300,
                            btnText: 'メールアドレスでログイン',
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return LoginPage();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    // 右から左
                                    final Offset begin = Offset(1.0, 0.0);
                                    // 左から右
                                    // final Offset begin = Offset(-1.0, 0.0);
                                    final Offset end = Offset.zero;
                                    final Animatable<Offset> tween =
                                        Tween(begin: begin, end: end).chain(
                                            CurveTween(
                                                curve: Curves.easeInOut));
                                    final Animation<Offset> offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  AdMobBanner(),
                ],
              ),
            ),
            ///
            /// 登録側
            ///
            Container(
              // color: Colors.green,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // color: Colors.amber,
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: SignInButton(
                            buttonType: ButtonType.appleDark,
                            imagePosition: ImagePosition.left,
                            buttonSize: ButtonSize.large,
                            btnTextColor: Colors.white,
                            btnColor: Colors.black,
                            width: 300,
                            btnText: 'AppleID で登録',
                            onPressed: () async {
                              await signInWithApple();
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return HomePage();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    // 右から左
                                    final Offset begin = Offset(1.0, 0.0);
                                    // 左から右
                                    // final Offset begin = Offset(-1.0, 0.0);
                                    final Offset end = Offset.zero;
                                    final Animatable<Offset> tween =
                                        Tween(begin: begin, end: end).chain(
                                            CurveTween(
                                                curve: Curves.easeInOut));
                                    final Animation<Offset> offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          // color: Colors.blueAccent,
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: SignInButton(
                            buttonType: ButtonType.google,
                            imagePosition: ImagePosition.left,
                            buttonSize: ButtonSize.large,
                            btnTextColor: Colors.black87,
                            btnColor: Colors.white,
                            width: 300,
                            btnText: 'Google で登録',
                            onPressed: () async {
                              await signInWithGoogle();
                              checkUid();
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return HomePage();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    // 右から左
                                    final Offset begin = Offset(1.0, 0.0);
                                    // 左から右
                                    // final Offset begin = Offset(-1.0, 0.0);
                                    final Offset end = Offset.zero;
                                    final Animatable<Offset> tween =
                                        Tween(begin: begin, end: end).chain(
                                            CurveTween(
                                                curve: Curves.easeInOut));
                                    final Animation<Offset> offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          // color: Colors.deepOrange,
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: SignInButton(
                            // buttonType: ButtonType.mail,
                            buttonType: ButtonType.custom,
                            customImage: CustomImage('assets/images/mail.png'),
                            imagePosition: ImagePosition.left,
                            buttonSize: ButtonSize.large,
                            btnColor: Color.fromARGB(255, 202, 233, 248),
                            btnTextColor: Colors.black54,
                            width: 300,
                            btnText: 'メールアドレスで登録',
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return CreateAccountPage();
                                  },
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    // 右から左
                                    final Offset begin = Offset(1.0, 0.0);
                                    // 左から右
                                    // final Offset begin = Offset(-1.0, 0.0);
                                    final Offset end = Offset.zero;
                                    final Animatable<Offset> tween =
                                        Tween(begin: begin, end: end).chain(
                                            CurveTween(
                                                curve: Curves.easeInOut));
                                    final Animation<Offset> offsetAnimation =
                                        animation.drive(tween);
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  AdMobBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<UserCredential> signInWithGoogle() async {
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

  void checkUid() {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    ///
    /// checkUidの名前を変える
    /// 取得したuidでTodoListIDを生成して登録する処理を追加予定
    ///
    if (uid != null) {
      print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
      print(uid);
      print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
    }
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
