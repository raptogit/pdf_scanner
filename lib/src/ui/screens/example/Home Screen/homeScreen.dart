import 'package:flutter/material.dart';
import 'package:pdf_scanner/src/ui/screens/example/example.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf Scanner'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ExamplePage(),
        )),
        child: Icon(Icons.add_circle),
      ),
    );
  }
}
