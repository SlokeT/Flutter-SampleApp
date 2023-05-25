import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBrodaPlacementHandler {
  static SharedPreferences? sharedPreferences;
  static FirebaseRemoteConfig? remoteConfig;
  static String abAppKey = '';

  static void initRemoteConfigAndSavePlacements() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    abAppKey = packageInfo.packageName.replaceAll('.', '_');
    remoteConfig = FirebaseRemoteConfig.instance;
    var configSettings = RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 0),
      minimumFetchInterval: Duration.zero,
    );
    remoteConfig!.setConfigSettings(configSettings);
    fetchAndSavePlacements(remoteConfig!);
  }

  static void fetchAndSavePlacements(
    FirebaseRemoteConfig remoteConfig,
  ) {
    try {
    remoteConfig.fetchAndActivate().then((isUpdated) {
        print('Fetch and activate succeeded');
        if (isUpdated) {
          print('Updated remote config data found');
        } else {
          print('Remote config data is the same ${!isUpdated} ');
        }
      });
    } catch (e) {
      print('Fetch failed');
    }

    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      Set<String> remoteConfigKeys =
          remoteConfig.getAll().keys.where((key) {
        return key.startsWith(abAppKey);
      }).toSet();
      for (String key in remoteConfigKeys) {
        String newKey = getKey(trimPrefix(key, abAppKey));
        print(newKey);
        String value = remoteConfig.getString(key);
        print(value);
        sharedPreferences!.setString(key, value);
      }
    });
  }

  static Future<List<String>> loadPlacement(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); 
    String newKey = getKey(key);
    String? value = sharedPreferences!.getString(newKey);
    print("Sloke - got value ${value}");
    if (value == '' || value == null) {
      return [];
    }
    var placement = convertToarray(value);
    print("Sloke - got placement ${placement}");
    return placement ?? [];
  }
  
  static List<String>? convertToarray(String value) {
    List<String>? array;
    value = value.substring(1, value.length - 1);
    array = value.split(',');
    for (int i = 0; i < array.length; i++) {
      array[i] = array[i].trim().replaceAll(RegExp('^"|"\$'), '');
    }
    return array;
  }

  static String getKey(String key) {
    return key;
  }

  static String trimPrefix(String? key, String abAppKey) {
    return key!.startsWith(abAppKey) ? key.substring(abAppKey.length) : key;
  }
}