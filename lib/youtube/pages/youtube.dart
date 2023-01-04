// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:whats_app_saver/youtube/models/download_helper.dart';
import 'package:whats_app_saver/youtube/widgets/my_bottom_sheet.dart';

class Youtube extends StatefulWidget {
  const Youtube({Key? key}) : super(key: key);

  @override
  _YoutubeState createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  DownloaderHelper downloaderHelper = DownloaderHelper();

  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  bool? isDowloanding;
  final GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Youtube Downloader'),
          centerTitle: true,
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
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      suffix: InkWell(
                          onTap: () {
                            textEditingController.clear();
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
                      hintText: "Enter YT url here",
                      fillColor: Colors.white70),
                  onFieldSubmitted: (value) {
                    print(value);
                    fieldValidate();
                  },
                  validator: (value) {
                    if (textEditingController.text.isEmpty) {
                      return "Enter a URL first !";
                    }
                    if (!textEditingController.text.contains("youtu")) {
                      return "Enter a YouTube URL !";
                    }
                  },
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: fieldValidate,
                  child: Container(
                    height: 40,
                    width: 150,
                    child: Center(
                        child: Text(
                          "Download",
                          style: TextStyle(
                              color: AdaptiveTheme
                                  .of(context)
                                  .brightness ==
                                  Brightness.light
                                  ? Colors.black
                                  : Colors.white),
                        )),
                    decoration: BoxDecoration(
                      gradient: AdaptiveTheme
                          .of(context)
                          .brightness ==
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
                SizedBox(height: 30),
                if (isLoading)

                  CircularProgressIndicator(
                      backgroundColor: Color(0xFF660033),
                      color: Color(0xFF000066)),
              ],
            ),
          ),
        ));
  }

  void fieldValidate() {
    if (_globalKey.currentState!.validate()) {
      _validate();
    }
  }

  void _validate() async {
    setState(() {
      isLoading = true;
    });
    var data = await downloaderHelper
        .getVideoInfo(Uri.parse(textEditingController.text));
    setState(() {
      isLoading = false;
    });
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            MyBottomSheet(
              imageUrl: data['image'].toString(),
              title: data['title'],
              author: data["author"],
              duration: data['duration'].toString(),
              mp3Size: data['mp3'],
              mp4Size: data['mp4'],
              mp3Method: () async {
                setState(() {
                  isDowloanding = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Audio Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp3(data['id'], data['title']);
                setState(() {
                  isDowloanding = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('  Audio Downloaded')
                        ],
                      )));
                });
              },
              isDownloading: isDowloanding,
              mp4Method: () async {
                setState(() {
                  isDowloanding = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Video Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp4(data['id'], data['title']);
                setState(() {
                  isDowloanding = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('Video Downloaded')
                        ],
                      )));
                });
              },
            ));
  }
}
