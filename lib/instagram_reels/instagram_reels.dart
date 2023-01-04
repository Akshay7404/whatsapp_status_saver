// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_app_saver/instagram_reels/Controller/DownloadController.dart';
import 'package:whats_app_saver/instagram_reels/DownloadedList.dart';
import 'package:whats_app_saver/instagram_reels/GenrateVideoFromPath.dart';

class Instagram_reels extends StatefulWidget {
  @override
  _Instagram_reelsState createState() => _Instagram_reelsState();
}

class _Instagram_reelsState extends State<Instagram_reels> {
  DownloadController downloadController = Get.put(DownloadController());
  TextEditingController urlController = TextEditingController();
  int? androidSDK;

  Future<int> _loadPermission() async {
    //Get phone SDK version first inorder to request correct permissions.

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    //
    if (androidSDK! >= 30) {
      //Check first if we already have the permissions
      final _currentStatusManaged =
          await Permission.manageExternalStorage.status;
      if (_currentStatusManaged.isGranted) {
        //Update
        return 1;
      } else {
        return 0;
      }
    } else {
      //For older phones simply request the typical storage permissions
      //Check first if we already have the permissions
      final _currentStatusStorage = await Permission.storage.status;
      if (_currentStatusStorage.isGranted) {
        //Update provider
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    await _loadPermission();
    await requestStoragePermission();
    if (androidSDK! >= 30) {
      //request management permissions for android 11 and higher devices
      final _requestStatusManaged =
          await Permission.manageExternalStorage.request();
      //Update Provider model
      if (_requestStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final _requestStatusStorage = await Permission.storage.request();
      //Update provider model
      if (_requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestStoragePermission() async {
    /// PermissionStatus result = await
    /// SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    final result = await [Permission.storage].request();
    setState(() {});
    if (result[Permission.storage]!.isDenied) {
      return 0;
    } else if (result[Permission.storage]!.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Reels Downloader",
          style: TextStyle(
              color: AdaptiveTheme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DownloadedList(),
                  ));
                },
                child: Icon(
                  Icons.download,
                  color:
                      AdaptiveTheme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                )),
          )
        ],
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
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        constraints: BoxConstraints.expand(),
        child: ListView(
          children: [
            TextFormField(
              controller: urlController,
              autocorrect: true,
              decoration: InputDecoration(
                  suffix: InkWell(
                      onTap: () {
                        urlController.clear();
                      },
                      child: Icon(Icons.clear)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  hintText: "Paste instagram reel link here",
                  fillColor: Colors.white70),
            ),
            TextButton(
                onPressed: () {
                  Clipboard.getData(Clipboard.kTextPlain).then(
                      (value) => urlController.text = value!.text.toString());
                },
                child: Text("Past Link")),
            Obx(
              () => Container(
                height: 100,
                child: downloadController.processing.value
                    ? Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : Center(
                        child: InkWell(
                          onTap: () {
                            downloadController.downloadReal(
                                urlController.text, context);
                          },
                          child: Container(
                            height: 40,
                            width: 150,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GetBuilder(
                init: downloadController,
                builder: (_) =>
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: downloadController.path != null
                        ? Container(
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
    );
  }
}
