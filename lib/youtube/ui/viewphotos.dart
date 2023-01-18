// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';
import 'package:share_whatsapp/share_whatsapp.dart';

class ViewPhotos extends StatefulWidget {
  final String imgPath;

  const ViewPhotos({
    Key? key,
    required this.imgPath,
  }) : super(key: key);

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  final String imgShare = 'Image.file(File(widget.imgPath),)';

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Great, Saved in Gallary',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: const TextStyle(
                                fontSize: 16.0,
                              )),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          const Text('FileManager > wa_status_saver',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.teal)),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: const Text('Close'),
                            color: Colors.teal,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    //The list of FabMiniMenuItems that we are going to use

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.indigo,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(top: 30, left: 25, bottom: 25, right: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF727272),
                        Color(0xFF171717),
                      ])),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  onPressed: () async {
                    _onLoading(true, '');
                    final myUri = Uri.parse(widget.imgPath);
                    final originalImageFile = File.fromUri(myUri);
                    late Uint8List bytes;
                    await originalImageFile.readAsBytes().then((value) {
                      bytes = Uint8List.fromList(value);
                    }).catchError((onError) {});
                    await ImageGallerySaver.saveImage(
                        Uint8List.fromList(bytes));
                    _onLoading(false,
                        'If Image not available in gallary\n\nYou can find all images at');
                  },
                  color: Color(0xFFFFFFFF),
                  icon: Icon(Icons.save, size: 25),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF727272),
                        Color(0xFF171717),
                      ])),
              child: Center(
                  child: IconButton(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                onPressed: () {
                  final myUri = Uri.parse(widget.imgPath);
                  Share.shareFiles(['$myUri']);
                },
                icon: Icon(Icons.share, size: 25),
                color: Colors.white,
              )),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF727272),
                        Color(0xFF171717),
                      ])),
              child: Center(
                  child: IconButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onPressed: () async {
                  var file = XFile(widget.imgPath);
                  shareWhatsapp.shareFile(file);
                },
                icon: Icon(Icons.repeat, size: 25),
                color: Colors.white,
              )),
            ),
          ],
        ),
      ),
      body: Center(
        child: Image.file(
          File(widget.imgPath),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
