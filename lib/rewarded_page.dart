import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_adunit.dart';
import 'package:flutter_application/utils/appbroda_adunit_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RewardedPage extends StatefulWidget {
  const RewardedPage({Key? key}) : super(key: key);

  @override
  State<RewardedPage> createState() => _RewardedPageState();
}

class _RewardedPageState extends State<RewardedPage> {
  late List<String> adUnit;
  late RewardedAd _rewardedAd;
  late AppBrodaAdUnit appBrodaAdUnit;
  bool _isLoaded = false;

  @override
  void initState() {
    initAds();
    super.initState();
  }

  void initAds() async {
    rewardedAdLoader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewarded Ad'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                    color: _isLoaded ? Colors.blue : Colors.grey,
                    border: Border.all(
                      color: _isLoaded ? Colors.blue : Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
                width: 100,
                height: 40,
                child: const Center(
                  child: Text(
                    "Show Ad",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              onTap: () => {
                if (_isLoaded)
                  _rewardedAd.show(
                      onUserEarnedReward:
                          (AdWithoutView ad, RewardItem rewardItem) {})
              },
            )
          ],
        ),
      ),
    );
  }

  void rewardedAdLoader() {
    appBrodaAdUnit = AppBrodaAdUnitHandler.createAppBrodaAdUnit(
        null, "com_flutter_sample_app_rewardedAds");
    AppBrodaAdUnitHandler.load(appBrodaAdUnit, loadRewardedAd);
  }

  void loadRewardedAd() {
    String adUnitId = AppBrodaAdUnitHandler.getUnitId(appBrodaAdUnit);
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            Fluttertoast.showToast(
              msg: "Rewarded Ad loaded @index: ${appBrodaAdUnit.getIndex()}",
              toastLength: Toast.LENGTH_SHORT,
            );
            AppBrodaAdUnitHandler.resetAppBrodaAdUnit(appBrodaAdUnit);
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
            setState(() {
              _isLoaded = true;
            });
            ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            setState(() {
              _isLoaded = false;
            });
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            Fluttertoast.showToast(
              msg: "Rewarded Ad failed to load @index: ${appBrodaAdUnit.getIndex()}",
              toastLength: Toast.LENGTH_SHORT,
            );
            debugPrint('Rewarded Ad failed to load: $error');
            AppBrodaAdUnitHandler.loadNextAd(appBrodaAdUnit);
          },
        ));
  }
}
