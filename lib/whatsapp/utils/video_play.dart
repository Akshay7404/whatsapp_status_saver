// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:video_player/video_player.dart';

class PlayStatus extends StatefulWidget {
  final String videoFile;

  const PlayStatus({
    Key? key,
    required this.videoFile,
  }) : super(key: key);

  @override
  _PlayStatusState createState() => _PlayStatusState();
}

class _PlayStatusState extends State<PlayStatus> {
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.file(File(widget.videoFile))
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
                          Text(
                            'Great, Saved in Gallery',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(padding: EdgeInsets.all(10.0)),
                          Text(str,
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          Padding(padding: EdgeInsets.all(10.0)),
                          Text('FileManager > wa_status_saver',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.teal)),
                          Padding(padding: EdgeInsets.all(10.0)),
                          MaterialButton(
                            child: Text('Close'),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(top: 30, left: 25, bottom: 25, right: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
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
                child: IconButton(
                  onPressed: () async {
                    _onLoading(true, '');
                    final originalVideoFile = File(widget.videoFile);
                    if (!Directory('/storage/emulated/0/wa_status_saver')
                        .existsSync()) {
                      Directory('/storage/emulated/0/wa_status_saver')
                          .createSync(recursive: true);
                    }
                    final newFileName =
                        '/storage/emulated/0/wa_status_saver/${widget.videoFile
                        .split("/")
                        .last}';
                    await originalVideoFile.copy(newFileName);

                    _onLoading(false,
                        'If Video not available in gallary\n\nYou can find all videos at');
                  },
                  icon: Icon(Icons.save, size: 25),
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
            Container(
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
                  child: IconButton(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    onPressed: () {
                      final myUri = Uri.parse(widget.videoFile);
                      Share.shareFiles(['$myUri']);
                    },
                    icon: Icon(Icons.share, size: 25),
                    color: Colors.white,
                  )),
            ),
            Container(
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
                  child: IconButton(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    onPressed: () {
                      var file = XFile(widget.videoFile);
                      shareWhatsapp.shareFile(file);
                    },
                    icon: Icon(Icons.repeat, size: 25),
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
