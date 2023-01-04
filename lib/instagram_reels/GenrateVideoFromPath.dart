// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whats_app_saver/instagram_reels/VideoPlayer.dart';

class GenrateVideoFrompath extends StatefulWidget {
  final String path;

  GenrateVideoFrompath(this.path);

  @override
  _GenrateVideoFrompathState createState() => _GenrateVideoFrompathState();
}

class _GenrateVideoFrompathState extends State<GenrateVideoFrompath> {
  var uint8list;
  bool loading = true;

  @override
  void initState() {
    genrateThumb();
    super.initState();
  }

  genrateThumb() async {
    final thumb = await VideoThumbnail.thumbnailData(video: "/${widget.path}");

    uint8list = thumb;
    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: loading
          ? Container(
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
              child: Image.asset('assets/images/video_loader.gif'))
          : InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoPlay(widget.path)));
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: MemoryImage(uint8list), fit: BoxFit.cover)),
                  ),
                  ClipOval(
                    child: Container(
                        color: Colors.black38,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.play_arrow,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                  )
                ],
              )),
    );
  }
}
