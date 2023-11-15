
import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';

class RoundButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonName;
  final double buttonWidth;

  const RoundButton({super.key, required this.buttonName, required this.buttonWidth, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(buttonWidth);
    final designH = screen.designH(50);

    return OutlinedButton(
      child: Text(buttonName),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.white,
        shape: const StadiumBorder(),
        side: const BorderSide(color: Colors.green),
        minimumSize: Size(designW, designH),
      ),
      onPressed: () {
        debugPrint('Pressed LoginButton');
        onPressed?.call(); // null チェックを追加
        debugPrint('Completed onPressed() of LoginButton');
      },
    );
  }
}
