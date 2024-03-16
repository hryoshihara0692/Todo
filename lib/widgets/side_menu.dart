import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/database/todo_item.dart';

import 'package:todo/pages/login.dart';
import 'package:todo/pages/create_account.dart';

import 'package:todo/database/user_data_service.dart';
import 'package:todo/pages/todo_list_admin.dart';

import 'package:todo/pages/user_admin.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid.toString();

    //if uid==nullの処理(ログアウト時)
    if (uid == null) {
      return Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(),
                child: Container(
                  color: Colors.yellow,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('ログイン'),
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return UserAdminPage(isNewAccount: false);
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final Offset begin = Offset(1.0, 0.0); // 右から左
                      // final Offset begin = Offset(-1.0, 0.0); // 左から右
                      final Offset end = Offset.zero;
                      final Animatable<Offset> tween =
                          Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: Curves.easeInOut));
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
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('新規登録'),
              onTap: () {
                // （1） 指定した画面に遷移する
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return UserAdminPage(isNewAccount: true);
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      final Offset begin = Offset(1.0, 0.0); // 右から左
                      // final Offset begin = Offset(-1.0, 0.0); // 左から右
                      final Offset end = Offset.zero;
                      final Animatable<Offset> tween =
                          Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: Curves.easeInOut));
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
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定'),
            ),
            ListTile(
              leading: Icon(Icons.live_help),
              title: Text('ヘルプ'),
            ),
            ListTile(
              leading: Icon(Icons.volunteer_activism),
              title: Text('ご要望・不具合'),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('アプリについて'),
              // onTap: () {
              //   // context.push('/login');
              //   // （1） 指定した画面に遷移する
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       // （2） 実際に表示するページ(ウィジェット)を指定する
              //       builder: (context) => UserAdminPage(),
              //     ),
              //   );
              // },
            ),
            // ListTile(
            //   leading: Icon(Icons.logout),
            //   title: Text('ログアウト'),
            //   onTap: () async {
            //     await FirebaseAuth.instance.signOut();
            //   },
            // ),
          ],
        ),
      );
    } else {
      //if uidにuidがある場合
      return Drawer(
        // ... 登録TodoListがない場合
        child: ListView(
          children: [
            SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(),
                child: Container(
                  color: Colors.yellow,
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage('assets/images/mail.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              //単語調整
              title: Text('TODOリスト管理'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => TodoListAdminPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定'),
            ),
            ListTile(
              leading: Icon(Icons.live_help),
              title: Text('ヘルプ'),
            ),
            ListTile(
              leading: Icon(Icons.volunteer_activism),
              title: Text('ご要望・不具合'),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('アプリについて'),
              // onTap: () {
              //   // context.push('/login');
              //   // （1） 指定した画面に遷移する
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       // （2） 実際に表示するページ(ウィジェット)を指定する
              //       builder: (context) => UserAdminPage(),
              //     ),
              //   );
              // },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ログアウト'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      );
    }
  }
}
