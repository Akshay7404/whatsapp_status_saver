// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whats_app_saver/VideoPlayer.dart';

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
          ? CupertinoActivityIndicator()
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
