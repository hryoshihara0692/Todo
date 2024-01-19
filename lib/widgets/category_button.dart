import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/pages/category_todo.dart';

class CategoryButton extends StatelessWidget {
  final String imagePath;

  const CategoryButton({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final categoryFrameWidth = screen.designW(110);
    final categoryFrameHeight = screen.designH(105);
    final categoryImageWidthHeight = screen.designW(75);

    // final imagePath = 'images/tomato.png';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          SlidePageRoute(
            page: CategoryTodoPage(),
          ),
        );
      },
      onDoubleTap: () {
        print('ダブルタップした！');
      },
      onLongPress: () {
        print('長押しした！');
      },
      child: Container(
        width: categoryFrameWidth,
        height: categoryFrameHeight,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromARGB(255, 232, 89, 79),
        ),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Center(
          child: Image.asset(
            imagePath,
            width: categoryImageWidthHeight,
            height: categoryImageWidthHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutQuart;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
