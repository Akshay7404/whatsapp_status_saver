// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlay extends StatefulWidget {
  final String path;

  VideoPlay(this.path);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.file(File(widget.path))
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController,
        customVideoPlayerSettings: CustomVideoPlayerSettings(
            controlBarAvailable: true,
            exitFullscreenOnEnd: true,
            showDurationPlayed: true,
            customVideoPlayerProgressBarSettings:
                CustomVideoPlayerProgressBarSettings(
                    allowScrubbing: true, showProgressBar: true)));
    super.initState();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController),
    );
  }
}
