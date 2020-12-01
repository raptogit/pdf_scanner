import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_scanner/src/models/folder_model.dart';
import 'package:pdf_scanner/src/services/hive_pref.dart';
import 'package:pdf_scanner/src/ui/screens/example/folderScreen/folder_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> _files = [];
  Box<Folder> _folderBox;
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    setState(() {
      _folderBox = Hive.box<Folder>(HiveInit.boxName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<Box<Folder>>(
              valueListenable: _folderBox.listenable(),
              builder: (context, folderbox, child) {
                List<int> keys =
                    folderbox.keys.cast<int>().toList().reversed.toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    Folder folder = folderbox.get(keys[index]);

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FolderScreen(
                              index: keys[index],
                            ),
                          ),
                        );
                      },
                      leading: Icon(Icons.folder),
                      title: Text(folder.folderName ?? "Non"),
                      subtitle: Text(
                        folder.createdOn.toString(),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
              width: 300,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: _files
                    .map((e) => Container(
                        height: 200, width: 200, child: Image.file(e)))
                    .toList()
                    .reversed
                    .toList(),
              ),
            ),
            SizedBox(height: 10),
            // TextButton(
            //   onPressed: ,
            //   child: Text("PickImage"),
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(child: Icon(Icons.folder)),
        onPressed: () {
          showDialog(
            context: context,
            child: Dialog(
              child: Container(
                color: Colors.white,
                height: 200,
                width: 400,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                          child: TextField(
                        controller: _controller,
                      )),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text("Cancel"),
                            ),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () async {
                              Folder newFolder = Folder(
                                createdOn: DateTime.now(),
                                files: [],
                                folderName: _controller.text,
                                numberOfItems: "",
                              );
                              await _folderBox.add(newFolder).then(
                                (value) {
                                  Navigator.pop(context);
                                  _controller.clear();
                                },
                              );
                            },
                            child: Center(
                              child: Text("Create Folder"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
