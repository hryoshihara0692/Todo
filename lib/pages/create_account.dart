import 'package:flutter/material.dart';
import 'package:todo/screen_pod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo/components/ad_mob.dart';
import 'package:todo/widgets/round_button.dart';
import 'package:go_router/go_router.dart';

class CreateAccountPage extends StatefulWidget {
  // const AccountRegistrationPage({super.key});
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() =>
      _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
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
            color: Colors.blue,
          ),
          margin: const EdgeInsets.fromLTRB(0, 100, 0, 100),
          child: const Center(child: Text('Flex 1')),
        ),
        // Container(
        //   child: TextField(),
        // ),
        Expanded(
          child: Container(
            color: Colors.pink,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 3)),
                      hintText: 'メールアドレス',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                const SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 3)),
                      hintText: 'パスワード',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      buttonName: 'キャンセル',
                      buttonWidth: 150,
                      onPressed: () {
                        context.push('/');
                      },
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    RoundButton(
                      buttonName: 'アカウント登録する',
                      buttonWidth: 150,
                      onPressed: () {
                        context.push('/');
                      },
                    ),
                  ],
                ),
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
