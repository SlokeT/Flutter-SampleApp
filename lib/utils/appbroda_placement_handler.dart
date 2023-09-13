import 'package:firebase_remote_config/firebase_remote_config.dart';

class AppBrodaPlacementHandler {
  static void initRemoteConfigAndSavePlacements() async {
    final firebaseRemoteConfig = FirebaseRemoteConfig.instance;
    await firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
      // change these settings as per your requirement
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 0),
    ));
    await firebaseRemoteConfig.fetchAndActivate();
  }

  static void fetchAndSavePlacements() async {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
  }

  static List<String> loadPlacement(String key) {
    String? value = FirebaseRemoteConfig.instance.getString(key);
    if (value.isEmpty) return [];

    return _convertToArray(value);
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