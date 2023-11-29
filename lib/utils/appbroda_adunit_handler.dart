import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_application/utils/appbroda_adunit.dart';

class AppBrodaAdUnitHandler {
  static void initRemoteConfigAndSaveAdUnits() async {
    final firebaseRemoteConfig = FirebaseRemoteConfig.instance;
    await firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
      // change these settings as per your requirement
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 900),
    ));

    // set the minimum fetch interval to 0 during testing
    await firebaseRemoteConfig.fetchAndActivate();
  }

  static void fetchAndSaveAdUnits() async {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
  }

  static List<String> loadAdUnit(String key) {
    String? value = FirebaseRemoteConfig.instance.getString(key);
    if (value.isEmpty) return [];

    return _convertToArray(value);
  }

  static void loadNextAd(AppBrodaAdUnit appBrodaAdUnit) {
    void Function() adLoader = appBrodaAdUnit.getAdLoader();
    if (appBrodaAdUnit.nextAdUnitAvailable() && !appBrodaAdUnit.loadingPaused) {
      appBrodaAdUnit.incrementIndex();
      adLoader();
      return;
    }
    appBrodaAdUnit.reset();
  }

  static String getUnitId(AppBrodaAdUnit appBrodaAdUnit) {
    return appBrodaAdUnit.getCurrentAdUnit() ?? "";
  }

  static void loadAndRefresh(AppBrodaAdUnit appBrodaAdUnit, void Function() adLoader, int defaultRefreshRate) {
    appBrodaAdUnit.setAdLoader(adLoader);
    appBrodaAdUnit.loadAndRefresh(defaultRefreshRate);
  }

  static void load(AppBrodaAdUnit appBrodaAdUnit, void Function() adLoader) {
    appBrodaAdUnit.setAdLoader(adLoader);
    appBrodaAdUnit.load();
  }

  static AppBrodaAdUnit createAppBrodaAdUnit(AppBrodaAdUnit? appBrodaAdUnit, String adUnit) {
    if (appBrodaAdUnit != null) {
      appBrodaAdUnit.stopAdLoading();
    }
    return AppBrodaAdUnit(adUnit);
  }

  static void resetAppBrodaAdUnit(AppBrodaAdUnit appBrodaAdUnit) {
    appBrodaAdUnit.reset();
  }

  static void stopLoading(AppBrodaAdUnit appBrodaAdUnit) {
    if (appBrodaAdUnit != null) {
      appBrodaAdUnit.stopAdLoading();
    }
  }

   static List<String> _convertToArray(String value) {
    List<String> array = [];
    if(value.isEmpty || value == null) return array;

    value = value.substring(1, value.length - 1);
    array = value.split(',');
    for (int i = 0; i < array.length; i++) {
      array[i] = array[i].trim().replaceAll(RegExp('^"|"\$'), '');
    }
    return array;
  }
}