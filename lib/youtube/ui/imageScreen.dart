// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:whats_app_saver/youtube/ui/viewphotos.dart';

final Directory newPhotoDir = Directory(
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("image screen app life cycle $state");
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused) {
      imageList = newPhotoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.jpg'))
          .toList();
      //print("image list set $imageList");

    }
    setState(() {});
  }

  RefreshController controller = RefreshController();
  List<String> imageList = [];

  @override
  Widget build(BuildContext context) {
    if (!Directory(newPhotoDir.path).existsSync()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Install WhatsApp', style: TextStyle(fontSize: 18.0)),
          SizedBox(height: 10),
          Text("Your Friend's Status Will Be Available Here",
              style: TextStyle(fontSize: 18.0)),
        ],
      );
    } else {
      setState(() {
        imageList = newPhotoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg'))
            .toList();
      });
      if (imageList.isNotEmpty) {
        return Container(
            margin: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              key: PageStorageKey(widget.key),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  maxCrossAxisExtent: 150),
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                String imgPath = imageList[index];
                return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(ViewPhotos(imgPath: imgPath));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.94),
                            border: Border.all(color: Colors.white)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.94),
                          child: Image.file(
                            File(imageList[index]),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    ));
              },
            ));
      } else {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Sorry, No Image Found!',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
