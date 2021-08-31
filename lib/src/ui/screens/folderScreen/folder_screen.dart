import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'folderScreen_viewModel.dart';

class FolderScreen extends StatefulWidget {
  final int? index;

  FolderScreen({Key? key, this.index}) : super(key: key);
  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  void didChangeDependencies() {
    Provider.of<FolderScreenViewModel>(context).initState(widget.index);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final folderModel =
        Provider.of<FolderScreenViewModel>(context, listen: false);
    print(folderModel.folder!.files ?? "Non ");
    return Scaffold(
      appBar: AppBar(
        title: Text(folderModel.folder!.folderName ?? "non"),
      ),
      body: folderModel.files!.length != 0
          ? GridView.builder(
              itemCount: folderModel.files!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.grey.withOpacity(0.5),
                  height: 150,
                  width: 150,
                  child: Image.file(File(folderModel.files![index]),
                      fit: BoxFit.fitHeight),
                );
              },
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          folderModel.onPressed();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
