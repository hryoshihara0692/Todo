import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';
import 'package:go_router/go_router.dart';

class CreateTodoPage extends StatelessWidget {
  const CreateTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    // final designW = screen.designW(350);
    final designH = screen.designH(60);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            // 閉じるときはネストしているModal内のRouteではなく、root側のNavigatorを指定する必要がある
            onPressed: () {
              print('object');
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: Icon(Icons.close)),
        title: Text('Modal'),
      ),
    );
  }
}
