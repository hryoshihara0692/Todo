import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';
import 'package:go_router/go_router.dart';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    // final designW = screen.designW(350);
    final designH = screen.designH(60);

    return Row(
      children: [
        Expanded(
          child: Container(
            // width: designW,
            height: designH,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
            ),
            child: Center(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // print('トマトをタップした！');
                      context.push('/category_todo');
                    },
                    onDoubleTap: () {
                      print('ダブルタップした！');
                    },
                    onLongPress: () {
                      print('長押しした！');
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        'Todoの中身あああああああああああああああああああああああああああああああああああああああああああああ',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 40,
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
