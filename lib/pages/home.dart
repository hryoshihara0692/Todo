// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/pages/category_todo.dart';
import 'package:todo/screen_pod.dart';

// Project imports:
import 'package:todo/pages/create_todo.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/side_menu.dart';
import 'package:todo/widgets/category_button.dart';

import 'package:todo/widgets/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AdMob _adMob = AdMob();

  @override
  void initState() {
    super.initState();
    _adMob.load();
  }

  @override
  void dispose() {
    super.dispose();
    _adMob.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenRef(context).watch(screenProvider);
    final categoryWidth = screen.designW(110);
    final categoryHeight = screen.designH(105);

    final imagePath = 'images/tomato.png';

    //画面下のメニュー用
    // int _selectedIndex = 0;
    // void _onItemTapped(int index) {
    //   setState(() {
    //     _selectedIndex = index;
    //   });
    // }

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imagePath), fit: BoxFit.cover),
              ),
            ),
          ),
          drawer: SideMenu(),
          body: Stack(
            children: [
              Todo(),
              Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //TOP下の広いメニュー
                  // Expanded(
                  //   child: Container(
                  //     width: 350,
                  //     margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  //     decoration: const BoxDecoration(
                  //       shape: BoxShape.rectangle,
                  //       color: Color.fromARGB(255, 145, 145, 145),
                  //     ),
                  //     child: Image.asset(
                  //       'images/plus.png',
                  //       color: Colors.blue,
                  //     ),
                  //   ),
                  // ),
                  TextField(
                    maxLines: null, // nullで複数行入力が有効になります
                    // expands: true, // 常に複数行の状態を維持します
                    decoration: InputDecoration(
                      hintText: '複数行入力してください',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //カテゴリボタン9つの場所
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CategoryButton(imagePath: imagePath),
                            CategoryButton(imagePath: imagePath),
                            CategoryButton(imagePath: imagePath),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CategoryButton(imagePath: imagePath),
                            CategoryButton(imagePath: imagePath),
                            CategoryButton(imagePath: imagePath),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CategoryButton(imagePath: imagePath),
                            CategoryButton(imagePath: imagePath),
                            CategoryButton(imagePath: imagePath),
                          ],
                        )
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: AdSize.getAnchoredAdaptiveBannerAdSize(
                        Orientation.portrait,
                        MediaQuery.of(context).size.width.truncate()),
                    builder: (BuildContext context,
                        AsyncSnapshot<AnchoredAdaptiveBannerAdSize?> snapshot) {
                      if (snapshot.hasData) {
                        return SizedBox(
                          width: double.infinity,
                          child: _adMob.getAdBanner(),
                        );
                      } else {
                        return Container(
                          height: _adMob.getAdBannerHeight(),
                          color: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    // showModalBottomSheet<int>(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   // 自前でモーダル用Navigatorを作成
                    //   builder: (context) => Navigator(
                    //     onGenerateRoute: (context) =>
                    //         MaterialPageRoute<CreateTodoPage>(
                    //       builder: (context) => CreateTodoPage(),
                    //     ),
                    //   ),
                    // );
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      // showModalBottomSheetで表示される中身
                      builder: (context) => CreateTodoPage(),
                    );
                  },
                  onDoubleTap: () {
                    print('ダブルタップした！');
                  },
                  onLongPress: () {
                    print('長押しした！');
                  },
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, //色
                          spreadRadius: 2.5,
                          blurRadius: 2.5,
                          offset: Offset(1.0, 1.5),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 0, 15, 70),
                    child: const Center(child: Text('＋')),
                  ),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: _selectedIndex,
          //   onTap: _onItemTapped,
          //   items: const <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.favorite), label: 'お気に入り'),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.notifications), label: 'お知らせ'),
          //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
          //   ],
          //   type: BottomNavigationBarType.fixed,
          // ),
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
