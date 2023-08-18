import 'package:firebase_remote_config/firebase_remote_config.dart';

class AppBrodaPlacementHandler {
  static void initRemoteConfigAndSavePlacements() async {
    var firebaseRemoteConfig = FirebaseRemoteConfig.instance;
    await firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 0),
    ));

      await firebaseRemoteConfig.fetchAndActivate().then((isUpdated) {
        print('Fetch and activate succeeded!!');
        if (isUpdated) {
          print('Updated remote config data found!');
        } else {
          print('Remote config data is the same!');
        }
      });
  }

  static List<String> loadPlacement(String key) {
    String? value = FirebaseRemoteConfig.instance.getString(key);
    if (value == '') return [];

    var placement = convertToArray(value);
    return placement ?? [];
  }

  static List<String>? convertToArray(String value) {
    List<String>? array;
    value = value.substring(1, value.length - 1);
    array = value.split(',');
    for (int i = 0; i < array.length; i++) {
      array[i] = array[i].trim().replaceAll(RegExp('^"|"\$'), '');
    }
    return array;
  }
}