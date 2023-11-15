
import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';

class Todo extends StatelessWidget {

  const Todo({super.key});

  @override
  Widget build(BuildContext context) {

    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(350);
    final designH = screen.designH(60);

    return Container(
      width: designW,
      height: designH,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: const Center(child: Text('a')),
    );
  }
}