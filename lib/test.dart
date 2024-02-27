import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.6),
          child: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   height: 100, // 画像の高さ
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image:
                //           AssetImage("assets/images/your_image.png"), // 画像のパス
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                Container(
                  // width: designW,
                  height: 250,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                  // margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: const Center(child: Text('Flex 1')),
                ),
                Container(
                  height: kToolbarHeight,
                  child: TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: 'ログイン',),
                      Tab(text: '新規登録',),
                      // Tab(icon: Icon(Icons.directions_bike)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Text('ログイン画面'),
            Text('新規登録'),
            // Icon(Icons.directions_transit),
            // Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
