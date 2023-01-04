// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whats_app_saver/instagram_reels/instagram_reels.dart';
import 'package:whats_app_saver/youtube/pages/youtube.dart';

import 'dashboard.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final html =
      '<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Galery :)</p><p>- You can also Use Multiple Saving. [to do]</p>';

  List<Alignment> get getAlignments => [
        Alignment.bottomLeft,
        Alignment.bottomRight,
        Alignment.topRight,
        Alignment.topLeft,
      ];
  var counter = 0;

  ColorAnimationTimer() {
    ///Animating for the first time.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      counter++;
      setState(() {});
    });

    const interval = Duration(seconds: 5);
    Timer.periodic(
      interval,
      (Timer timer) {
        counter++;
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    ColorAnimationTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Saver'),
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
        actions: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                AdaptiveTheme.of(context).toggleThemeMode();
              });
            },
            child: AdaptiveTheme.of(context).brightness == Brightness.light
                ? SvgPicture.asset('assets/images/moon.svg')
                : SvgPicture.asset('assets/images/sun.svg'),
          ),
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        bottom: TabBar(tabs: [
          Container(
            padding: EdgeInsets.all(12.0),
            child: Text('IMAGES',
                style: TextStyle(
                    color:
                        AdaptiveTheme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
          ),
          Container(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'VIDEOS',
              style: TextStyle(
                  color:
                      AdaptiveTheme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white),
            ),
          ),
        ]),
      ),
      drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 280,
                decoration: BoxDecoration(color: Colors.tealAccent),
                child: DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(5, 5)),
                            ]),
                        child: ClipOval(
                            child: Image.asset("assets/images/avatar.png",
                                fit: BoxFit.fill)),
                      ),
                      Flexible(
                        child: Text(
                          "Welcome to Status Downloader",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Instagram_reels(),
                      ));
                },
                child: AnimatedContainer(
                  height: 40,
                  width: 170,
                  margin: EdgeInsets.only(left: 15, top: 15),
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        stops: [0.0, 0.2, 0.5, 1.0],
                        begin: getAlignments[counter % getAlignments.length],
                        end:
                            getAlignments[(counter + 2) % getAlignments.length],
                        colors: <Color>[
                          Color(0xFF4367ca),
                          Color(0xFFb933b7),
                          Color(0xFFf08048),
                          Color(0xFFf6c753)
                        ]..shuffle()),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  duration: Duration(seconds: 2),
                  child: Row(children: [
                    SvgPicture.asset("assets/images/instagram.svg",
                        width: 30, height: 30, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      "InstaGram Reels",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )
                  ]),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Youtube(),
                      ));
                },
                child: AnimatedContainer(
                  height: 40,
                  width: 170,
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        stops: [0.0, 0.2, 0.5, 1.0],
                        begin: getAlignments[counter % getAlignments.length],
                        end:
                            getAlignments[(counter + 2) % getAlignments.length],
                        colors: <Color>[
                          Color(0xFFe12b26),
                          Color(0xFFc11b1d),
                          Colors.red.shade400,
                          Colors.red.shade200,
                        ]..shuffle()),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  duration: Duration(seconds: 2),
                  child: Row(children: [
                    SvgPicture.asset("assets/images/youtube.svg",
                        width: 30, height: 30, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      "Youtybe URL",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )
                  ]),
                ),
              )
            ],
          )),
      body: const Dashboard(),
    );
  }
}

void choiceAction(String choice) {
  if (choice == Constants.about) {
  } else if (choice == Constants.rate) {
  } else if (choice == Constants.share) {}
}

class Constants {
  static const String about = 'About App';
  static const String rate = 'Rate App';
  static const String share = 'Share with friends';

  static const List<String> choices = <String>[about, rate, share];
}
