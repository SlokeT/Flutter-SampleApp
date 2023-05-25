import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_placement_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  late List<String> bannerPlacement;
  late BannerAd _bannerAd;
  bool _isLoaded = false;
  int bannerIndex = 0;

  @override
  void initState() {
    initAds();
    super.initState();
  }

  void initAds() async {
    bannerPlacement = await AppBrodaPlacementHandler.loadPlacement("com_ea_game_pvzfree_row_Banner_1");
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
            SizedBox(height: 20),
            _isLoaded
                ? Container(
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
    String adUnit = bannerPlacement[bannerIndex];
    _bannerAd = BannerAd(
      adUnitId: adUnit,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          Fluttertoast.showToast(
              msg: "loaded @index: $bannerIndex",
              toastLength: Toast.LENGTH_SHORT,
            );
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          Fluttertoast.showToast(
              msg: "failed to load @index: $bannerIndex",
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
  if(bannerIndex==bannerPlacement.length){
      bannerIndex=0;
      return;
  }
  bannerIndex++;
  loadBannerAd();
}

}
