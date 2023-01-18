// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_app_saver/youtube/pages/youtube.dart';
import 'package:whats_app_saver/youtube/ui/dashboard.dart';


class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with TickerProviderStateMixin {
  final html =
      '<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Galery :)</p><p>- You can also Use Multiple Saving. [to do]</p>';

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late TabController tabcontroller;

  @override
  void initState() {
    super.initState();
    tabcontroller = TabController(length: 2, vsync: this);
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    result = await _connectivity.checkConnectivity();
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  final databaseReference = FirebaseDatabase.instance.ref();

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    result == ConnectivityResult.none
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                            child:
                                Image.asset("assets/images/no_internet.png")),
                        SizedBox(height: 20),
                        Text(
                          "No Internet",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Please check your connection status and try again",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 45),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                            ),
                            child: Center(child: Text("Close")),
                          ),
                        )
                      ]),
                ),
              );
            },
          )
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Saver'),
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
              setState(() {
                print("on tap");
                if (AdaptiveTheme.of(context).brightness == Brightness.light) {
                  AdaptiveTheme.of(context)
                      .setThemeMode(AdaptiveThemeMode.dark);
                } else if (AdaptiveTheme.of(context).brightness ==
                    Brightness.dark) {
                  AdaptiveTheme.of(context)
                      .setThemeMode(AdaptiveThemeMode.light);
                }
              });
            },
            icon: AdaptiveTheme.of(context).brightness == Brightness.light
                ? SvgPicture.asset('assets/images/moon.svg')
                : SvgPicture.asset('assets/images/sun.svg'),
          ),
          IconButton(
              onPressed: () {
                var isAppInstalled = DeviceApps.isAppInstalled('com.whatsapp');
                isAppInstalled.then((value) {
                  value == true
                      ? DeviceApps.openApp('com.whatsapp')
                      : Get.snackbar("Error", "Please install Whatsapp");
                });
              },
              icon: Icon(Icons.whatsapp))
        ],
        bottom: TabBar(controller: tabcontroller, tabs: [
          Container(
            padding: EdgeInsets.all(12.0),
            child: Text('IMAGES',
                style: TextStyle(
                    color:
                        AdaptiveTheme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
          ),
          Container(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'VIDEOS',
              style: TextStyle(
                  color:
                      AdaptiveTheme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white),
            ),
          ),
        ]),
      ),
      drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: AdaptiveTheme.of(context).brightness ==
                          Brightness.light
                      ? LinearGradient(
                          stops: [0.1, 0.5],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topRight,
                          colors: <Color>[Color(0xFFff99cc), Color(0xFF9999ff)])
                      : LinearGradient(
                          stops: [0.2, 0.5],
                          transform: GradientRotation(50),
                          begin: Alignment.bottomCenter,
                          end: Alignment.topRight,
                          colors: <Color>[
                            Color(0xFF660033),
                            Color(0xFF000066)
                          ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(5, 5)),
                          ]),
                      child: ClipOval(
                        child: Image.asset(
                            "assets/images/new_logo-modified.png",
                            fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(height: 5),
                    Flexible(
                      child: Text(
                        "Welcome to Status Downloader",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("Downloader"),
                leading: Icon(Icons.download_for_offline_outlined,
                    color:
                        AdaptiveTheme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Youtube(),
                      ));
                },
              ),
              ListTile(
                title: Text("Share with friends"),
                leading: Icon(Icons.share,
                    color:
                        AdaptiveTheme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white),
                onTap: () {
                  final myUri = Uri.parse(
                      "https://play.google.com/store/apps/details?id=com.storysaver.app");
                  Share.share(myUri.toString());
                },
              ),
              ListTile(
                title: Text("Rate APP"),
                leading: Icon(Icons.star,
                    color:
                        AdaptiveTheme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white),
                onTap: () async {
                  final myUri = Uri.parse(
                      "https://play.google.com/store/apps/details?id=com.storysaver.app");
                  launchUrl(myUri, mode: LaunchMode.externalApplication);
                },
              ),
            ],
          )),
      body: Dashboard(tabcontroller: tabcontroller),
    );
  }
}
