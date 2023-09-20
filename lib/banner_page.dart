import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_adunit_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  late List<String> adUnit;
  late BannerAd _bannerAd;
  bool _isLoaded = false;
  int bannerIndex = 0;

  @override
  void initState() {
    initAds();
    super.initState();
  }

  void initAds() async {
    adUnit =  AppBrodaAdUnitHandler.loadAdUnit("com_flutter_sample_app_bannerAds");
    loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner Ad'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _isLoaded
                ? SizedBox(
                    //padding: const EdgeInsets.all(10),
                    height: _bannerAd.size.height.toDouble(),
                    width: _bannerAd.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void loadBannerAd() {
    if(adUnit.isEmpty || bannerIndex >= adUnit.length) return;

    String adUnitId = adUnit[bannerIndex];
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          Fluttertoast.showToast(
              msg: "Banner ad loaded @index: $bannerIndex",
              toastLength: Toast.LENGTH_SHORT,
            );
          // Reset bannerIndex to 0
          bannerIndex = 0;
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          Fluttertoast.showToast(
              msg: "Banner ad failed to load @index: $bannerIndex",
              toastLength: Toast.LENGTH_SHORT,
            );
          ad.dispose();
          loadNextAd();
        },
        onAdImpression: (Ad ad) {},
      ),
    )..load();
  }

  void loadNextAd(){
    bannerIndex++;
    if(bannerIndex >= adUnit.length){
      bannerIndex=0;
      return;
  }
  loadBannerAd();
}

}
