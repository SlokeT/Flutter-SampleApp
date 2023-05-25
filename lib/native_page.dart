import 'package:flutter/material.dart';
import 'package:flutter_application/utils/appbroda_placement_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NativePage extends StatefulWidget {
  const NativePage({Key? key}) : super(key: key);

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  late List<String> nativePlacement;
  late NativeAd _nativeAd;
  bool _isLoaded = false;
  int nativeIndex = 0;

  @override
  void initState() {
    initAds();
    super.initState();
  }

  void initAds() async {
    nativePlacement = await AppBrodaPlacementHandler.loadPlacement(
        "com_ea_game_pvzfree_row_Native_1");
    loadNativeAd();
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
            SizedBox(height: 20),
            _isLoaded
                ? ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 320, // minimum recommended width
                      minHeight: 90, // minimum recommended height
                      maxWidth: 400,
                      maxHeight: 200,
                    ),
                    child: AdWidget(ad: _nativeAd!),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void loadNativeAd() {
    String adUnitId = nativePlacement[nativeIndex];
    _nativeAd = NativeAd(
        adUnitId: adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            Fluttertoast.showToast(
              msg: "loaded @index: $nativeIndex",
              toastLength: Toast.LENGTH_SHORT,
            );
            setState(() {
              _isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            Fluttertoast.showToast(
              msg: "failed to load @index: $nativeIndex",
              toastLength: Toast.LENGTH_SHORT,
            );
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
            loadNextAd();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
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

  void loadNextAd() {
    if (nativeIndex == nativePlacement.length) {
      nativeIndex = 0;
      return;
    }
    nativeIndex++;
    loadNativeAd();
  }
}
