import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_adunit.dart';
import 'package:flutter_application/utils/appbroda_adunit_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BannerPage extends StatefulWidget {
  const BannerPage({Key? key}) : super(key: key);

  @override
  State<BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> with WidgetsBindingObserver {
  late List<String> adUnit;
  late BannerAd _bannerAd;
  late AppBrodaAdUnit appBrodaAdUnit;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    initAds();
    WidgetsBinding.instance.addObserver(this);
  }

  void initAds() async {
    bannerAdLoader();
  }

  @override
  void dispose() {
    AppBrodaAdUnitHandler.stopLoading(appBrodaAdUnit);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      AppBrodaAdUnitHandler.stopLoading(appBrodaAdUnit);
    } else if (state == AppLifecycleState.resumed) {
      bannerAdLoader();
    }
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
            _isLoaded ? SizedBox(
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

  void bannerAdLoader() {
    appBrodaAdUnit = AppBrodaAdUnitHandler.createAppBrodaAdUnit(
        null, "com_flutter_sample_app_bannerAds");
    AppBrodaAdUnitHandler.loadAndRefresh(appBrodaAdUnit, loadBannerAd, 15);
  }

 void loadBannerAd() {
    String adUnitId = AppBrodaAdUnitHandler.getUnitId(appBrodaAdUnit);
    setState(() {
      _isLoaded = false;
    });
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          Fluttertoast.showToast(
              msg: "Banner ad loaded @index: ${appBrodaAdUnit.getIndex()}",
              toastLength: Toast.LENGTH_SHORT,
            );
          setState(() {
            _isLoaded = true;
          });
          AppBrodaAdUnitHandler.resetAppBrodaAdUnit(appBrodaAdUnit);
        },
        onAdFailedToLoad: (ad, err) {
          Fluttertoast.showToast(
              msg: "Banner ad failed to load @index: ${appBrodaAdUnit.getIndex()}",
              toastLength: Toast.LENGTH_SHORT,
            );
          ad.dispose();
          AppBrodaAdUnitHandler.loadNextAd(appBrodaAdUnit);
        },
        onAdImpression: (Ad ad) {
          Fluttertoast.showToast(
            msg: "Impression received @index: ${appBrodaAdUnit.getIndex()}",
            toastLength: Toast.LENGTH_SHORT,
          );
        },
      ),
    )..load();
  }

}
