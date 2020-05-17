import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectlight/components/IOSorAndroidComponents.dart';

/// Referenced by https://github.com/divyanshub024/flutter_camera/tree/master/lib
class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String currentFilePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: FutureBuilder(
        future: _getAllImages(),
        builder: (context, AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Container();
          }
//          print('${snapshot.data.length} ${snapshot.data}');
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No images found.'),
            );
          }

          return PageView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              currentFilePath = snapshot.data[index].path;
              var extension = path.extension(snapshot.data[index].path);
              if (extension == '.jpeg' ||
                  extension == '.jpg' ||
                  extension == '.png') {
                return Container(
//                  height: MediaQuery.of(context).size.height,
//                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.file(
                    File(snapshot.data[index].path),
                    fit: BoxFit.fill,
                  ),
                );
              } else {
                return Container(
                  child: Text('Only images can be previewed.'),
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  onPressed: _chooseFile,
                  child: Text(
                    'Select ✔',
                    style: TextStyle(color: Colors.green),
                  )),
              VerticalDivider(),
              FlatButton(
                child: Text(
                  'Delete 🗑️',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: _deleteFile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _chooseFile() async {
    var extension = path.extension(currentFilePath);
    if (extension == '.jpeg' || extension == '.jpg' || extension != '.png') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
//        return Screen(
//          image: currentFilePath,
//        );
      }));
    } else {
      IOSorAndroidComponents().alertWarningDialog(
          title: 'Only images can be selected', context: context);
    }
  }

  _deleteFile() {
    final dir = Directory(currentFilePath);
    dir.deleteSync(recursive: true);
    setState(() {});
  }

  Future<List<FileSystemEntity>> _getAllImages() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    return _images;
  }
}
