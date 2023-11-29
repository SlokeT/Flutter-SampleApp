import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_adunit.dart';
import 'package:flutter_application/utils/appbroda_adunit_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InterstitialPage extends StatefulWidget {
  const InterstitialPage({Key? key}) : super(key: key);

  @override
  State<InterstitialPage> createState() => _InterstitialPageState();
}

class _InterstitialPageState extends State<InterstitialPage> {
  late InterstitialAd _interstitialAd;
  late AppBrodaAdUnit appBrodaAdUnit;
  bool _isLoaded = false;

  @override
  void initState() {
    initAds();
    super.initState();
  }

  void initAds() async {
    interstitialAdLoader();
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

  void interstitialAdLoader() {
    appBrodaAdUnit = AppBrodaAdUnitHandler.createAppBrodaAdUnit(
        null, "com_flutter_sample_app_interstitialAds");
    AppBrodaAdUnitHandler.load(appBrodaAdUnit, loadInterstitialAd);
  }

  void loadInterstitialAd() {
    String adUnitId = AppBrodaAdUnitHandler.getUnitId(appBrodaAdUnit);
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
              msg: "Interstitial ad loaded @index: ${appBrodaAdUnit.getIndex()}",
              toastLength: Toast.LENGTH_SHORT,
            );
            AppBrodaAdUnitHandler.resetAppBrodaAdUnit(appBrodaAdUnit);
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
              msg: "Interstitial ad loading failed @index: ${appBrodaAdUnit.getIndex()}",
              toastLength: Toast.LENGTH_SHORT,
            );
            AppBrodaAdUnitHandler.loadNextAd(appBrodaAdUnit);
          },
          
        ));
  }
}
