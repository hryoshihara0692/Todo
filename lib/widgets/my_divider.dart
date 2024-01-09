import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      thickness: 2,
      indent: 0,
      endIndent: 0,
      // color: Colors.black,
      color: Colors.grey,
    );
  }
}
