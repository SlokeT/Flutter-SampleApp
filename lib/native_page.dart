import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_adunit.dart';
import 'package:flutter_application/utils/appbroda_adunit_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NativePage extends StatefulWidget {
  const NativePage({Key? key}) : super(key: key);

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> with WidgetsBindingObserver {
  late List<String> adUnit;
  late NativeAd _nativeAd;
  late AppBrodaAdUnit appBrodaAdUnit;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    initAds();
    WidgetsBinding.instance.addObserver(this);
  }

  void initAds() async {
    nativeAdLoader();
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
      nativeAdLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Ad'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _isLoaded
                ? ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 320, // minimum recommended width
                      minHeight: 90, // minimum recommended height
                      maxWidth: 400,
                      maxHeight: 200,
                    ),
                    child: AdWidget(ad: _nativeAd),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void nativeAdLoader() {
    appBrodaAdUnit = AppBrodaAdUnitHandler.createAppBrodaAdUnit(
        null, "com_flutter_sample_app_nativeAds");
    AppBrodaAdUnitHandler.loadAndRefresh(appBrodaAdUnit, loadNativeAd, 15);
  }

  void loadNativeAd() {
    setState(() {
      _isLoaded = false;
    });
    String adUnitId =  AppBrodaAdUnitHandler.getUnitId(appBrodaAdUnit);
    _nativeAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            Fluttertoast.showToast(
              msg: "Native ad loaded @index: ${appBrodaAdUnit.getIndex()}",
              toastLength: Toast.LENGTH_SHORT,
            );
            AppBrodaAdUnitHandler.resetAppBrodaAdUnit(appBrodaAdUnit);
            setState(() {
              _isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            Fluttertoast.showToast(
              msg: "Native ad failed to load @index: ${appBrodaAdUnit.getIndex()}",
              toastLength: Toast.LENGTH_SHORT,
            );
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
            AppBrodaAdUnitHandler.loadNextAd(appBrodaAdUnit);
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.white,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }
}
