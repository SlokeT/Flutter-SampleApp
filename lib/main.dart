import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/banner_page.dart';
import 'package:flutter_application/interstitial_page.dart';
import 'package:flutter_application/native_page.dart';
import 'package:flutter_application/rewarded_page.dart';
import 'package:flutter_application/utils/appbroda_adunit_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  // Initialize the utility class
  AppBrodaAdUnitHandler.initRemoteConfigAndSaveAdUnits();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("AppBroda Sample app")),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color:  Colors.blue,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  width: 140,
                  height: 40,
                  child: const Center(
                    child: Text(
                      "Banner Ad",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BannerPage()))
                },
              ),
              const SizedBox(height: 40),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color:  Colors.blue,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  width: 140,
                  height: 40,
                  child: const Center(
                    child: Text(
                      "Interstitial Ad",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const InterstitialPage()))
                },
              ),
              const SizedBox(height: 40),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color:  Colors.blue,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  width: 140,
                  height: 40,
                  child: const Center(
                    child: Text(
                      "Rewarded Ad",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RewardedPage()))
                },
              ),
              const SizedBox(height: 40),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color:  Colors.blue,
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  width: 140,
                  height: 40,
                  child: const Center(
                    child: Text(
                      "Native Ad",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NativePage()))
                },
              ),
              const Spacer(),
            ],
          ),
        ),

      );
  }
}