import 'dart:io';
import 'dart:math';

import 'package:cr_file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'video_controller.dart';

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
    super.initState();
  }

  @override
  void dispose() {
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
                          const Text(
                            'Great, Saved in Gallary',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: const TextStyle(
                                fontSize: 16.0,
                              )),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          const Text('FileManager > wa_status_saver',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.teal)),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: const Text('Close'),
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
      body: StatusVideo(
        videoPlayerController:
            VideoPlayerController.file(File(widget.videoFile)),
        videoSrc: widget.videoFile,
      ),
      // ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: const Icon(Icons.save),
          onPressed: () async {
            _onLoading(true, '');
            final originalVideoFile = File(widget.videoFile);
            if (!Directory('/storage/emulated/0/wa_status_saver')
                .existsSync()) {
              Directory('/storage/emulated/0/wa_status_saver')
                  .createSync(recursive: true);
            }

            final newFileName = '/storage/emulated/0/wa_status_saver/${widget.videoFile.split("/").last}';

            await originalVideoFile.copy(newFileName);


            _onLoading(false, 'If Video not available in gallary\n\nYou can find all videos at');
          }),
    );
  }
  void _createTempPressed() async {
    final folder = await getTemporaryDirectory();
    final filePath = '${folder.parent.parent.path}/whatsapp_status_saver';
    final file = File(filePath);
    final raf = await file.open(mode: FileMode.read);
    await raf.writeString('string\n');
    await raf.close();

    print('Created temp file: ${file.path}');
    setState(() {});
  }
}
