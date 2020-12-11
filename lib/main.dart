import 'package:flutter/material.dart';
import 'package:pdf_scanner/src/services/hive_pref.dart';
import 'package:pdf_scanner/src/ui/screens/example/Home%20Screen/homeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInit.hiveInit();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
//Error in storing images
//database not working properly when we try to store the images
//App crashes when we try to save the file

// This app works fine. or at least on my phone
// which android version do you have/use on your phone?
// I will try on other people's phone and update you in our next meeting.
