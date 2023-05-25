import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_placement_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InterstitialPage extends StatefulWidget {
  const InterstitialPage({Key? key}) : super(key: key);

  @override
  State<InterstitialPage> createState() => _InterstitialPageState();
}

class _InterstitialPageState extends State<InterstitialPage> {
  late List<String> interstitialPlacement;
  late InterstitialAd _interstitialAd;
  bool _isLoaded = false;
  int interstitialIndex = 0;

  @override
  void initState() {
    initAds();
    super.initState();
  }

  void initAds() async {
    interstitialPlacement = await AppBrodaPlacementHandler.loadPlacement(
        "com_ea_game_pvzfree_row_Interstitial_1");
    loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interstitial Ad'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: _isLoaded?Colors.blue:Colors.grey,
                    border: Border.all(
                      color: _isLoaded?Colors.blue:Colors.grey,
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
                if(_isLoaded) _interstitialAd.show()
              },
            )
          ],
        ),
      ),
    );
  }

  void loadInterstitialAd() {
    String adUnitId = interstitialPlacement[interstitialIndex];
    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            _isLoaded = true;
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            Fluttertoast.showToast(
              msg: "loaded @index: ${interstitialIndex}",
              toastLength: Toast.LENGTH_SHORT,
            );
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
              msg: "loading failed @index: ${interstitialIndex}",
              toastLength: Toast.LENGTH_SHORT,
            );
            loadNextAd();
          },
          
        ));
  }

  void loadNextAd() {
    if (interstitialIndex == interstitialPlacement.length) {
      interstitialIndex = 0;
      return;
    }
    interstitialIndex++;
    loadInterstitialAd();
  }
}
