// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart';

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

  final LinearGradient backgroundGradient = const LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x00333333),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final _fabMiniMenuItemList = [
    Icons.share,
    Icons.reply,
  ];

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
      backgroundColor: Colors.black12,
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
            InkWell(
              onTap: () async {
                _onLoading(true, '');
                final myUri = Uri.parse(widget.imgPath);
                final originalImageFile = File.fromUri(myUri);
                late Uint8List bytes;
                await originalImageFile.readAsBytes().then((value) {
                  bytes = Uint8List.fromList(value);
                }).catchError((onError) {});
                await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
                _onLoading(false,
                    'If Image not available in gallary\n\nYou can find all images at');
              },
              child: Container(
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
                  child: Icon(
                    color: Color(0xFFFFFFFF),
                    Icons.save,
                    size: 25,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                final myUri = Uri.parse(widget.imgPath);
                Share.shareFiles(['$myUri']);
              },
              child: Container(
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
                    child: Icon(
                  Icons.share,
                  size: 25,
                  color: Colors.white,
                )),
              ),
            ),
            InkWell(
              onTap: () {
                final myUri = Uri.parse(widget.imgPath);
                Share.shareFiles(['$myUri']);
              },
              child: Container(
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
                    child: Icon(
                  Icons.repeat,
                  size: 25,
                  color: Colors.white,
                )),
              ),
            ),
            // Container(
            //   height: 50,
            //   width: 50,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(30),
            //       gradient: LinearGradient(
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //           colors: [
            //             Color(0xFF727272),
            //             Color(0xFF171717),
            //           ])),
            //   child: Center(
            //     child: PopupMenuButton<String>(
            //       color: Colors.transparent,
            //       enabled: true,
            //       icon: Icon(Icons.more_vert_outlined, color: Colors.white),
            //       onSelected: popupButtonAction,
            //       itemBuilder: (BuildContext context) {
            //         return buttonConstants.choices.map((String choice) {
            //           return PopupMenuItem<String>(
            //             enabled: true,
            //             value: choice,
            //             child: Column(children: [
            //               Container(
            //                 height: 50,
            //                 width: 50,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(30),
            //                     gradient: LinearGradient(
            //                         begin: Alignment.topCenter,
            //                         end: Alignment.bottomCenter,
            //                         colors: [
            //                           Color(0xFF727272),
            //                           Color(0xFF171717),
            //                         ])),
            //                 child: Column(
            //                   children: [
            //                     List.generate(icons.length, (index) {
            //                       return Icon(index);
            //                     }).toList()
            //                   ],
            //                 ),
            //               ),
            //               Text("${choice}",
            //                   style: TextStyle(color: Colors.white)),
            //               SizedBox(height: 20)
            //             ]),
            //           );
            //         }).toList();
            //       },
            //     ),
            //   ),
            // ),

            // SpeedDialFabWidget(
            // secondaryIconsList: _fabMiniMenuItemList,
            // secondaryIconsText: [
            //   "Share",
            //   "Repost",
            // ],
            // secondaryIconsOnPress: [
            //       () => {},
            //       () => {},
            // ],
            // primaryIconExpand: Icons.add,
            // primaryIconCollapse: Icons.add,
            // secondaryBackgroundColor: Colors.teal,
            // secondaryForegroundColor: Colors.white,
            // primaryBackgroundColor: Colors.teal,
            // primaryForegroundColor: Colors.white,
            // )
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

  var icons = [Icons.share, Icons.repeat];
}

void popupButtonAction(String choice) {
  if (choice == buttonConstants.Share) {}
  if (choice == buttonConstants.Repost) {}
  {}
}

class buttonConstants {
  static const String Share = 'Share';
  static const String Repost = 'Repost';

  static const List<String> choices = <String>[
    Share,
    Repost,
  ];
}
