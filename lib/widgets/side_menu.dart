import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('新規登録'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('通知設定'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('プレミアムプラン'),
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
          ),
        ],
      ),
    );
  }
}
