import 'package:flutter/material.dart';
import 'package:pdf_scanner/src/ui/screens/example/example.dart';

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf Scanner'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ExamplePage(),
        child: Icon(Icons.add_circle),
      ),
    );
  }
}
