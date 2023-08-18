import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_placement_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RewardedPage extends StatefulWidget {
  const RewardedPage({Key? key}) : super(key: key);

  @override
  State<RewardedPage> createState() => _RewardedPageState();
}

class _RewardedPageState extends State<RewardedPage> {
  late List<String> rewardedPlacement;
  late RewardedAd _rewardedAd;
  bool _isLoaded = false;
  int rewardedIndex = 0;

  @override
  void initState() {
    initAds();
    super.initState();
  }

  void initAds() async {
    rewardedPlacement =  AppBrodaPlacementHandler.loadPlacement("com_flutter_sample_app_rewardedAds");
    loadRewardedAd();
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

  void loadRewardedAd() {
    if(rewardedPlacement.isEmpty || rewardedIndex >= rewardedPlacement.length) return;

    String adUnitId = rewardedPlacement[rewardedIndex];
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            Fluttertoast.showToast(
              msg: "Rewarded Ad loaded @index: $rewardedIndex",
              toastLength: Toast.LENGTH_SHORT,
            );
            // Reset the rewardedIndex to 0
            rewardedIndex = 0;
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
            // Load a new ad after a delay, so that an ad is always ready to be displayed
            Future.delayed(const Duration(milliseconds: 3000), () {
              loadRewardedAd();
            });
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            Fluttertoast.showToast(
              msg: "Rewarded Ad failed to load @index: $rewardedIndex",
              toastLength: Toast.LENGTH_SHORT,
            );
            debugPrint('Rewarded Ad failed to load: $error');
            loadNextAd();
          },
        ));
  }

  void loadNextAd() {
    rewardedIndex++;
    if (rewardedIndex >= rewardedPlacement.length) {
      rewardedIndex = 0;
      return;
    }
    loadRewardedAd();
  }
}
