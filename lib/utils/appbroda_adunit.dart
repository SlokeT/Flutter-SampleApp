import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'appbroda_adunit_handler.dart';

class AppBrodaAdUnit {
  bool loadingPaused = false;
  late List<String> unitsIds;
  late int index;
  late String adUnitId;
  late void Function() adLoader;
  late Timer timer;
  late int refreshRate;
  bool firstLoad = true;

  void setRefreshRate() {
    refreshRate = FirebaseRemoteConfig.instance.getDouble("${adUnitId}_refresh_rate").toInt();
  }

  int getRefreshRate() {
    return refreshRate;
  }

  void resetIndex() {
    index = 0;
  }

  void setAdUnitId(String adUnitId) {
    this.adUnitId = adUnitId;
  }

  void getAdUnitsFromRemoteConfig() {
    setRefreshRate();
    unitsIds = AppBrodaAdUnitHandler.loadAdUnit(adUnitId);
  }

  void setAdLoader(void Function() adLoader) {
    this.adLoader = adLoader;
  }

  void Function() getAdLoader(){
    return adLoader;
  }

  void stopAdLoading() {
    timer.cancel();
    firstLoad = true;
    loadingPaused = true;
  }

  AppBrodaAdUnit(String adUnitId) {
    resetIndex();
    setAdUnitId(adUnitId);
    getAdUnitsFromRemoteConfig();
  }

  List<String> getUnitsIds() {
    return unitsIds;
  }

  int getAdUnitsLength() {
    return unitsIds.length;
  }

  String? getCurrentAdUnit() {
    if (index >= 0 && index < unitsIds.length) {
      return unitsIds[index];
    } else {
      return null;
    }
  }

  bool nextAdUnitAvailable() {
    int nextIndex = index + 1;
    return nextIndex >= 0 && nextIndex < unitsIds.length;
  }

  int getIndex() {
    return index;
  }

  void setIndex(int index) {
    this.index = index;
  }

  void incrementIndex() {
    index++;
  }

  void reset() {
    setIndex(0);
    unitsIds = AppBrodaAdUnitHandler.loadAdUnit(adUnitId);
  }

  void loadAndRefresh(int defaultRefreshRateInSeconds) {
    int firebaseRefreshRate = getRefreshRate();
    int refreshRateInSeconds = firebaseRefreshRate == 0 ? defaultRefreshRateInSeconds : firebaseRefreshRate;
    int refreshRateInMilliSeconds = refreshRateInSeconds * 1000;

    if(firstLoad){
      adLoader();
      firstLoad = false;
    }

    timer = Timer.periodic(Duration(milliseconds: refreshRateInMilliSeconds), (timer) {
      if (loadingPaused) {
        timer.cancel();
      }
      if (getCurrentAdUnit() != null) {
        adLoader();
      }
    });
  }

  void load() {
    setAdLoader(adLoader);
    if (getUnitsIds() != null) adLoader();
  }
}
