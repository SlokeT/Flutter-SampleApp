import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/banner_page.dart';
import 'package:flutter_application/utils/appbroda_placement_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  AppBrodaPlacementHandler.initRemoteConfigAndSavePlacements();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Padding(
        padding: EdgeInsets.all(8.0),
        child: const BannerPage(),
      ),
    );
  }
}
