import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/database/todo_item.dart';

import 'package:todo/pages/login.dart';
import 'package:todo/pages/create_account.dart';

import 'package:todo/database/user_data_service.dart';
import 'package:todo/pages/todo_list_admin.dart';

// test
import 'package:todo/test.dart';

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
                // context.push('/login');
                // （1） 指定した画面に遷移する
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('新規登録'),
              onTap: () {
                // context.push('/account_registration');
                // （1） 指定した画面に遷移する
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => CreateAccountPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('通知設定'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('プレミアムプラン'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('ヘルプ'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('ご要望・不具合'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('アプリについて'),
              onTap: () {
                // context.push('/login');
                // （1） 指定した画面に遷移する
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => TestPage(),
                  ),
                );
              },
            ),
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
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('ユーザIDあります'),
              onTap: () {
                // context.push('/login');
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('新規登録'),
              onTap: () {
                // context.push('/account_registration');
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('TodoList登録'),
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
              leading: Icon(Icons.notifications),
              title: Text('通知設定'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('プレミアムプラン'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('ヘルプ'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('ご要望・不具合'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('アプリについて'),
              onTap: () {
                // context.push('/login');
                // （1） 指定した画面に遷移する
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => TestPage(),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
