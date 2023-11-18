import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/s1.dart';

class MyWidget extends ConsumerWidget {
  const MyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s1 = ref.watch(s1NotifierProvider);

    ref.listen(s1NotifierProvider, (oldState, newState) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$oldStateから$newStateへ変更')));
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$s1'),
            ElevatedButton(
              onPressed: () {
                final notifier = ref.read(s1NotifierProvider.notifier);
                notifier.updateState();
              },
              child: Text('ボタン'),
            )
          ],
        ),
      ),
    );
  }
}
