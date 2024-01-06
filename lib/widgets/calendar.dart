import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleDialogSample extends ConsumerStatefulWidget {
  SimpleDialogSample({Key? key}) : super(key: key);
  ConsumerState<ConsumerStatefulWidget> createState() => _SimpleDialogSample();
}

class _SimpleDialogSample extends ConsumerState<SimpleDialogSample> {
  @override
  Widget build(BuildContext context) {
    return Text('aho');
  }
}
