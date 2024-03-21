import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screen_pod.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/admob_banner.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:todo/pages/home.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /**
   * Todoソート
   */
  final sortColumnSPKeyName = "SortColumnTodo";
  final descendingTodoSPKeyName = "DescendingTodo";
  final sortTypeSPKeyName = "SortTypeTodoList";
  final descendingTodoListSPKeyName = "DescendingTodoList";

  final deleteButtonModeSPKeyName = 'deleteButtonMode';

  String _sortColumnTodoValue = 'CreatedAt';
  bool _descendingTodoValue = false;
  String _sortTypeTodoListValue = 'CreatedAt';
  bool _descendingTodoListValue = false;

  String _deleteButtonModeValue = 'long';

  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    _initSharedPreferencesData();
    _adMob.load();
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  void _initSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(sortColumnSPKeyName)) {
      setState(() {
        final sortColumnTodoValue = prefs.getString(sortColumnSPKeyName);
        _sortColumnTodoValue = sortColumnTodoValue!;
      });
    }
    if (prefs.containsKey(descendingTodoSPKeyName)) {
      setState(() {
        final descendingTodoValue = prefs.getBool(descendingTodoSPKeyName);
        _descendingTodoValue = descendingTodoValue!;
      });
    }
    if (prefs.containsKey(sortTypeSPKeyName)) {
      setState(() {
        final sortTypeTodoListValue = prefs.getString(sortTypeSPKeyName);
        _sortTypeTodoListValue = sortTypeTodoListValue!;
      });
    }
    if (prefs.containsKey(descendingTodoListSPKeyName)) {
      setState(() {
        final descendingTodoListValue =
            prefs.getBool(descendingTodoListSPKeyName);
        _descendingTodoListValue = descendingTodoListValue!;
      });
    }
    if (prefs.containsKey(deleteButtonModeSPKeyName)) {
      setState(() {
        final deleteButtonModeValue =
            prefs.getString(deleteButtonModeSPKeyName);
        _deleteButtonModeValue = deleteButtonModeValue!;
      });
    }
  }

  void _setSharedPreferenceSortColumn(String sortColumnTodoValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(sortColumnSPKeyName, sortColumnTodoValue);
  }

  void _setSharedPreferenceDescending(bool descendingTodoValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(descendingTodoSPKeyName, descendingTodoValue);
  }

  void _setSharedPreferenceSortType(String sortTypeTodoListValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(sortTypeSPKeyName, sortTypeTodoListValue);
  }

  void _setSharedPreferenceDescendingTodoList(
      bool descendingTodoListValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(descendingTodoListSPKeyName, descendingTodoListValue);
  }

  void _setSharedPreferenceDeleteButtonMode(
      String deleteButtonModeValue) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(deleteButtonModeSPKeyName, deleteButtonModeValue);
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final designW = screen.designW(200);
    final designH = screen.designH(200);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: designW,
              // height: designH,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
              child: const Center(child: Text('Flex 1')),
            ),
            Expanded(
              child: Container(
                color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Todo並び順'),
                        // ToggleButtons(children: , isSelected: isSelected)
                      ],
                    ),
                    DropdownButton(
                      items: const [
                        DropdownMenuItem(
                          value: 'CreatedAt',
                          child: Text('Todo作った順'),
                        ),
                        DropdownMenuItem(
                          value: 'Content',
                          child: Text('Todo名前の順'),
                        ),
                      ],
                      value: _sortColumnTodoValue,
                      onChanged: (String? value) {
                        setState(() {
                          _sortColumnTodoValue = value!;
                          _setSharedPreferenceSortColumn(_sortColumnTodoValue);
                        });
                      },
                    ),
                    DropdownButton(
                      items: const [
                        DropdownMenuItem(
                          value: 'false',
                          child: Text('昇順'),
                        ),
                        DropdownMenuItem(
                          value: 'true',
                          child: Text('降順'),
                        ),
                      ],
                      value: _descendingTodoValue ? 'true' : 'false',
                      onChanged: (String? value) {
                        setState(() {
                          bool descendingTodoValue = value == 'true';
                          _descendingTodoValue = descendingTodoValue;
                          _setSharedPreferenceDescending(descendingTodoValue);
                        });
                      },
                    ),
                    DropdownButton(
                      items: const [
                        DropdownMenuItem(
                          value: 'CreatedAt',
                          child: Text('TodoList作った順'),
                        ),
                        DropdownMenuItem(
                          value: 'Name',
                          child: Text('TodoList名前の順'),
                        ),
                      ],
                      value: _sortTypeTodoListValue,
                      onChanged: (String? value) {
                        setState(() {
                          _sortTypeTodoListValue = value!;
                          _setSharedPreferenceSortType(_sortTypeTodoListValue);
                        });
                      },
                    ),
                    DropdownButton(
                      items: const [
                        DropdownMenuItem(
                          value: 'false',
                          child: Text('昇順'),
                        ),
                        DropdownMenuItem(
                          value: 'true',
                          child: Text('降順'),
                        ),
                      ],
                      value: _descendingTodoListValue ? 'true' : 'false',
                      onChanged: (String? value) {
                        setState(() {
                          bool descendingTodoListValue = value == 'true';
                          _descendingTodoListValue = descendingTodoListValue;
                          _setSharedPreferenceDescendingTodoList(
                              descendingTodoListValue);
                        });
                      },
                    ),
                    DropdownButton(
                      items: const [
                        DropdownMenuItem(
                          value: 'long',
                          child: Text('長押し'),
                        ),
                        DropdownMenuItem(
                          value: 'single',
                          child: Text('1回タップ'),
                        ),
                        DropdownMenuItem(
                          value: 'double',
                          child: Text('2回タップ'),
                        ),
                      ],
                      value: _deleteButtonModeValue,
                      onChanged: (value) {
                        setState(() {
                          _deleteButtonModeValue = value!;
                          _setSharedPreferenceDeleteButtonMode(
                              _deleteButtonModeValue);
                        });
                      },
                    ),
                    RoundButton(
                      buttonName: 'キャンセル',
                      buttonWidth: 150,
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => HomePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            AdMobBanner(),
          ],
        ),
      ),
    );
  }
}
