// ignore_for_file: prefer_const_constructors

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:whats_app_saver/GenrateVideoFromPath.dart';

class DownloadedList extends StatefulWidget {
  _DownloadedListState createState() => _DownloadedListState();
}

class _DownloadedListState extends State<DownloadedList> {
  var box = GetStorage();
  bool loadingVideos = true;
  List allVideos = [];

  @override
  void initState() {
    allVideos = box.read("allVideo") ?? [];
    loadingVideos = false;

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Downloaded Reels",
          style: TextStyle(
              color: AdaptiveTheme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        ),
        iconTheme: IconThemeData(
            color: AdaptiveTheme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
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
      body: loadingVideos
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.3,
              children: List<Widget>.generate(
                  allVideos.length,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GenrateVideoFrompath(allVideos[index]),
                      )),
            ),
    );
  }
}
