import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 80,
            child: DrawerHeader(
              decoration: BoxDecoration(),
              child: Container(
                color: Colors.yellow,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Person1'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Person2'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Person3'),
          ),
        ],
      ),
    );
  }
}
