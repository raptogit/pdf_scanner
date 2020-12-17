import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pdf_scanner/src/models/folder_model.dart';
import 'package:pdf_scanner/src/ui/screens/folderScreen/folder_screen.dart';
import 'package:provider/provider.dart';
import 'homeScreen_viewModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller;
  TextEditingController _saveNameController;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _saveNameController = TextEditingController();
  }

  @override
  didChangeDependencies() {
    Provider.of<HomeScreenViewModel>(context).initState();
    super.didChangeDependencies();
  }

  Future<Widget> showDialogC({
    String actionLabel,
    TextEditingController controller,
    Function onPressed,
  }) async {
    return await showDialog(
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
                  controller: controller,
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
                      onPressed: onPressed,
                      child: Center(
                        child: Text(actionLabel),
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
  }

  @override
  Widget build(BuildContext context) {
    final homeModel = Provider.of<HomeScreenViewModel>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<Box<Folder>>(
              valueListenable: homeModel.folderBox.listenable(),
              builder: (context, folderbox, child) {
                List<int> keys =
                    folderbox.keys.cast<int>().toList().reversed.toList();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    Folder folder = folderbox.get(keys[index]);

                    return ListTile(
                      onLongPress: () {
                        //longpress to create and save pdf to storage
                        showDialogC(
                          actionLabel: "Create PDF and save to Storage",
                          controller: _saveNameController,
                          onPressed: () {
                            homeModel
                                .generatePDF(
                              imagesPath: folder.files,
                              pdfName: _saveNameController.text,
                            )
                                .then((value) {
                              _saveNameController.clear();
                              Navigator.of(context).pop();
                            });
                          },
                        );
                      },
                      onTap: () async {
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(child: Icon(Icons.folder)),
        onPressed: () {
          showDialogC(
            controller: _controller,
            actionLabel: "Create Folder",
            onPressed: () async {
              Folder newFolder = Folder(
                createdOn: DateTime.now(),
                files: [],
                folderName: _controller.text,
                numberOfItems: "",
              );
              await homeModel.folderBox.add(newFolder).then(
                (value) {
                  Navigator.pop(context);
                  _controller.clear();
                },
              );
            },
          );
        },
      ),
    );
  }
}
