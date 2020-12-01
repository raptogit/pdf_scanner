import 'dart:io';

import 'package:hive/hive.dart';
part 'folder_model.g.dart';

@HiveType(typeId: 0)
class Folder extends HiveObject {
  @HiveField(0)
  final String folderName;

  @HiveField(1)
  final List<String> files;

  @HiveField(2)
  final String numberOfItems;
  @HiveField(3)
  final DateTime createdOn;

  Folder({this.createdOn, this.files, this.folderName, this.numberOfItems});
}
