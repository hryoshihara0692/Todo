// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/screen_pod.dart';

// Project imports:
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/side_menu.dart';
import 'package:go_router/go_router.dart';

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
    final designW = screen.designW(110);
    final designH = screen.designH(105);
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
                    image: AssetImage('images/tomato.png'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          drawer: SideMenu(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: 350,
                  margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color.fromARGB(255, 145, 145, 145),
                  ),
                  child: Image.asset('images/tomato.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
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
                            width: designW,
                            height: designH,
                            decoration: const BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color.fromARGB(255, 232, 89, 79),
                            ),
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Center(
                              child: Image.asset('images/tomato.png'),
                            ),
                          ),
                        ),
                        Container(
                          width: designW,
                          height: designH,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 79, 232, 138),
                          ),
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Center(
                            child: Image.asset('images/tomato.png'),
                          ),
                        ),
                        Container(
                          width: designW,
                          height: designH,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 128, 79, 232),
                          ),
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Center(
                            child: Image.asset('images/tomato.png'),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: designW,
                          height: designH,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 128, 79, 232),
                          ),
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Center(
                            child: Image.asset('images/tomato.png'),
                          ),
                        ),
                        Container(
                          width: designW,
                          height: designH,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 232, 89, 79),
                          ),
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Center(
                            child: Image.asset('images/tomato.png'),
                          ),
                        ),
                        Container(
                          width: designW,
                          height: designH,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 79, 232, 138),
                          ),
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Center(
                            child: Image.asset('images/tomato.png'),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: designW,
                          height: designH,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 79, 232, 138),
                          ),
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Center(
                            child: Image.asset('images/tomato.png'),
                          ),
                        ),
                        Container(
                          width: designW,
                          height: designH,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 128, 79, 232),
                          ),
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Center(
                            child: Image.asset('images/tomato.png'),
                          ),
                        ),
                        Container(
                          width: designW,
                          height: designH,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color.fromARGB(255, 232, 89, 79),
                          ),
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Center(
                            child: Image.asset('images/tomato.png'),
                          ),
                        ),
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
        ),
      ),
    );
  }
}
