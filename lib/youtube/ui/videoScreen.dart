// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:whats_app_saver/whatsapp/utils/video_play.dart';

final Directory _videoDir = Directory(
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  VideoScreenState createState() => VideoScreenState();
}

List<String> videoList = [];

class VideoScreenState extends State<VideoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('${_videoDir.path}').existsSync()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Install WhatsApp\n',
            style: TextStyle(fontSize: 18.0),
          ),
          const Text(
            "Your Friend's Status Will Be Available Here",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
    } else {
      return VideoGrid(directory: _videoDir);
    }
  }
}

class VideoGrid extends StatefulWidget {
  final Directory? directory;

  const VideoGrid({Key? key, this.directory}) : super(key: key);

  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> with WidgetsBindingObserver {
  Future<String?> _getImage(videoPathUrl) async {
    final thumb = await VideoThumbnail.thumbnailFile(video: videoPathUrl);
    return thumb;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(("did app change life cycle"));
    if (state == AppLifecycleState.resumed) {
      print("app life cycle is resumed $state");
      videoList = widget.directory!
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.mp4'))
          .toList(growable: false);
      //setState(() {});
      print("video list set $videoList");
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      videoList = widget.directory!
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.mp4'))
          .toList(growable: false);
      print("build widget $videoList");
    });

    if (videoList.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: GridView.builder(
          itemCount: videoList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(
                  PlayStatus(videoFile: videoList[index]),
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(
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
                  child: FutureBuilder<String?>(
                      future: _getImage(videoList[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Hero(
                              tag: videoList[index],
                              child: Image.file(
                                File(snapshot.data!),
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return Center(
                              child: LoadingAnimationWidget.discreteCircle(
                                  secondRingColor: Color(0xFF000066),
                                  color: Color(0xFF660033),
                                  size: 35),
                            );
                          }
                        } else {
                          return Hero(
                            tag: videoList[index],
                            child: SizedBox(
                              height: 280.0,
                              child:
                                  Image.asset('assets/images/video_loader.gif'),
                            ),
                          );
                        }
                      }),
                  //new cod
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text(
          'Sorry, No Videos Found.',
          style: TextStyle(fontSize: 18.0),
        ),
      );
    }
  }
}
