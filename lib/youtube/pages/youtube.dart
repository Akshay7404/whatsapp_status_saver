// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, curly_braces_in_flow_control_structures

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_app_saver/instagram_reels/Controller/DownloadController.dart';
import 'package:whats_app_saver/instagram_reels/DownloadedList.dart';
import 'package:whats_app_saver/instagram_reels/GenrateVideoFromPath.dart';
import 'package:whats_app_saver/youtube/models/download_helper.dart';
import 'package:whats_app_saver/youtube/widgets/my_bottom_sheet.dart';

class Youtube extends StatefulWidget {
  const Youtube({Key? key}) : super(key: key);

  @override
  _YoutubeState createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  DownloaderHelper downloaderHelper = DownloaderHelper();
  DownloadController downloadController = Get.put(DownloadController());
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  bool? isDowloanding;
  var function_hide = false;
  final GlobalKey<FormState> _globalKey = GlobalKey();

  int? androidSDK;

  Future<int> _loadPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
      print("android sdk version $androidSDK");
    });
    if (androidSDK! >= 33) {
      final currentStatusManaged =
          await Permission.manageExternalStorage.status;
      print("currentStatusManaged $currentStatusManaged");
      if (currentStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final currentStatusStorage = await Permission.storage.status;
      if (currentStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    await _loadPermission();
    await requestStoragePermission();
    if (androidSDK! >= 33) {
      final requestStatusManaged =
          await Permission.manageExternalStorage.request();
      if (requestStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final requestStatusStorage = await Permission.storage.request();
      if (requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestStoragePermission() async {
    final result = await Permission.manageExternalStorage.request();
    setState(() {});
    if (result.isDenied) {
      print("permission is $result");
      return 0;
    } else if (result.isGranted) {
      print("permission is $result");
      return 1;
    } else {
      print("permission in else part $result");
      return 0;
    }
  }

  @override
  void initState() {
    requestPermission();
    readData();
    super.initState();
  }

  readData() async {
    FirebaseDatabase.instance.ref().onValue.listen((event) {
      print("Check Key::::${event.snapshot.children.length}");

      function_hide = event.snapshot.children.first.value as bool;
      print("realtime data ${event.snapshot.children.first.value}");
      print("Check :::: data $function_hide");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Downloader'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AdaptiveTheme.of(context).brightness == Brightness.light
                  ? LinearGradient(
                      stops: [0.1, 0.5],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      colors: <Color>[Color(0xFFff99cc), Color(0xFF9999ff)])
                  : LinearGradient(
                      stops: [0.1, 0.5],
                      transform: GradientRotation(50),
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      colors: <Color>[Color(0xFF660033), Color(0xFF000066)]),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DownloadedList(),
                  ));
                },
                icon: Icon(Icons.download))
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {
                            textEditingController.clear();
                          },
                          child: Icon(Icons.clear,
                              color: AdaptiveTheme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: GradientOutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              stops: [0.1, 0.5],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topRight,
                              colors: <Color>[
                                Color(0xFFff99cc),
                                Color(0xFF9999ff)
                              ])),
                      hintStyle:
                          TextStyle(color: Colors.grey[600], fontSize: 12),
                      hintText: "Enter url here",
                      fillColor: Colors.white70),
                  onFieldSubmitted: (value) {
                    print(value);
                    _validate();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter an URL first !";
                    } else if (!function_hide) {
                      return 'Enter valid URL';
                    } else if (!value.contains('instagram') &&
                        !value.contains('youtu')) {
                      return 'Invalid URL';
                    }

                    return null;
                  },
                ),
                TextButton(
                    onPressed: () {
                      Clipboard.getData(Clipboard.kTextPlain).then((value) =>
                          textEditingController.text = value!.text.toString());
                    },
                    child: Text("Paste Link")),
                SizedBox(height: 30),
                Obx(
                  () => downloadController.processing.value || isLoading
                      ? Center(
                          child: LoadingAnimationWidget.discreteCircle(
                              secondRingColor: Color(0xFF000066),
                              color: AdaptiveTheme.of(context).brightness ==
                                      Brightness.light
                                  ? Color(0xFF660033)
                                  : Colors.blue,
                              size: 35),
                        )
                      : InkWell(
                          borderRadius: BorderRadius.circular(35),
                          onTap: () {
                            if (_globalKey.currentState!
                                .validate()) if (textEditingController.text
                                    .contains("youtu") &&
                                function_hide &&
                                _globalKey.currentState!.validate()) {
                              print("in youtube");
                              _validate();
                            } else if (textEditingController.text
                                    .contains('instagram') &&
                                _globalKey.currentState!.validate()) {
                              downloadController.downloadReal(
                                  textEditingController.text, context);
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            margin: EdgeInsets.all(4),
                            child: Center(
                                child: Text(
                              "Download",
                              style: TextStyle(
                                  color: AdaptiveTheme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            )),
                            decoration: BoxDecoration(
                              gradient: AdaptiveTheme.of(context).brightness ==
                                      Brightness.light
                                  ? LinearGradient(
                                      stops: [0.1, 0.5],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        Color(0xFFff99cc),
                                        Color(0xFF9999ff)
                                      ])
                                  : LinearGradient(
                                      stops: [0.1, 0.5],
                                      transform: GradientRotation(50),
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        Color(0xFF660033),
                                        Color(0xFF000066)
                                      ]),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GetBuilder(
                    init: downloadController,
                    builder: (_) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: downloadController.path != null
                                ? Container(
                                    height: 300,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                                        colors: [
                                          Color(0xffb7d8cf),
                                          Color(0xffb7d8cf),
                                          Color(0xffb7d8cf),
                                          Color(0xffb7d8cf),
                                          Color(0xffb7d8cf),
                                        ],
                                      ),
                                    ),
                                    child: GenrateVideoFrompath(
                                        downloadController.path ?? ""))
                                : Center(child: Text("No recent download")),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _validate() async {
    setState(() {
      isLoading = true;
    });
    var data = await downloaderHelper
        .getVideoInfo(Uri.parse(textEditingController.text));
    setState(() {
      isLoading = false;
    });
    showModalBottomSheet(
        context: context,
        builder: (context) => MyBottomSheet(
              imageUrl: data['image'].toString(),
              title: data['title'],
              author: data["author"],
              duration: data['duration'].toString(),
              mp3Size: data['mp3'],
              mp4Size: data['mp4'],
              mp3Method: () async {
                setState(() {
                  isDowloanding = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Audio Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp3(data['id'], data['title']);
                setState(() {
                  isDowloanding = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('Audio Downloaded')
                        ],
                      )));
                });
              },
              isDownloading: isDowloanding,
              mp4Method: () async {
                setState(() {
                  isDowloanding = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Video Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp4(data['id'], data['title']);

                isDowloanding = false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.download_done,
                          color: Colors.green,
                          size: 30,
                        ),
                        Text('Video Downloaded')
                      ],
                    )));
              },
            ));
  }
}
