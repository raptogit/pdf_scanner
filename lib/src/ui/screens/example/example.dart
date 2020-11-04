import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  List<File> _files = [];
  File _file;
  String error;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: 300,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: _files
                  .map((e) =>
                      Container(height: 200, width: 200, child: Image.file(e)))
                  .toList()
                  .reversed
                  .toList(),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
              onPressed: () async {
                File _pickedFile = await ImagePicker()
                    .getImage(source: ImageSource.gallery)
                    .then((value) => File(value.path));

                _file = _pickedFile;
                _files.add(File(_file.path));
                setState(() {});
              },
              child: Text("PickImage"))
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: null),
    );
  }
}
