import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/round_button.dart';

class InitialPage extends StatefulWidget {
  // const initialPage({super.key});
  const InitialPage({super.key, required this.title});

  final String title;

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
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
    final designW = screen.designW(200);
    final designH = screen.designH(200);

    return Scaffold(
        body: SafeArea(
      child: Column(children: [
        Container(
          width: designW,
          height: designH,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
          child: const Center(child: Text('Flex 1')),
        ),
        Expanded(
          child: Container(
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RoundButton(
                      buttonName: '新しく登録する',
                      onPressed: () {
                        print('test');
                      }),
                  const SizedBox(
                    height: 50.0,
                  ),
                  RoundButton(
                      buttonName: 'データを復元する',
                      onPressed: () {
                        print('test');
                      }),
                ])
              ],
            ),
          ),
        ),
        FutureBuilder(
            future: AdSize.getAnchoredAdaptiveBannerAdSize(Orientation.portrait,
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
            }),
      ]),
    ));
  }
}
