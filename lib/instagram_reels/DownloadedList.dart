// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unrelated_type_equality_checks

import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_saver/instagram_reels/GenrateVideoFromPath.dart';

class DownloadedList extends StatefulWidget {
  @override
  _DownloadedListState createState() => _DownloadedListState();
}

class _DownloadedListState extends State<DownloadedList> {
  bool loadingVideos = true;

  List allVideos = [];
  List reelsVideos = [];
  List ytVideos = [];

  final Directory reelDir =
  Directory('/storage/emulated/0/InstaReelsDownloader/');
  final Directory ytDir =
  Directory('/storage/emulated/0/InstaReelsDownloader/Video');

  @override
  void initState() {
    setState(() {
      !ytDir.existsSync()
          ? allVideos = reelsVideos
          : allVideos = reelsVideos + ytVideos;


      if (!Directory('/storage/emulated/0/InstaReelsDownloader/')
          .existsSync()) {
        print("not");
      } else {
        reelsVideos = reelDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.mp4'))
            .toList();
        allVideos = reelsVideos;
      }
      if (!ytDir.existsSync()) {} else {
        ytVideos = ytDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.mp4'))
            .toList();
        allVideos = ytVideos + reelsVideos;

      }
      print("all videos length ${allVideos}");
    });

    //print("all videos $allVideos");
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
          "Downloaded Media",
          style: TextStyle(
              color: AdaptiveTheme
                  .of(context)
                  .brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        ),
        iconTheme: IconThemeData(
            color: AdaptiveTheme
                .of(context)
                .brightness == Brightness.light
                ? Colors.black
                : Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AdaptiveTheme
                .of(context)
                .brightness == Brightness.light
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
      body: allVideos.isEmpty
          ? Center(
        child: Text("No video found"),
      )
          : loadingVideos
          ? Center(
        child: Image.asset('assets/images/video_loader.gif'),
      )
          : GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.3,
        children: List<Widget>.generate(
          allVideos.length,
              (index) =>
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GenrateVideoFrompath(allVideos[index]),
              ),
        ),
      ),
    );
  }
}
