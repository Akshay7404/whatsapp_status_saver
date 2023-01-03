// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whats_app_saver/DownloadedList.dart';

import 'dashboard.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final html =
      '<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Galery :)</p><p>- You can also Use Multiple Saving. [to do]</p>';

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
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DownloadedList(),
                    ));
              },
              child: Icon(Icons.download)),
          SizedBox(width: 10)
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
          Container(
            padding: EdgeInsets.all(12.0),
            child: Text('REELS',
                style: TextStyle(
                    color:
                        AdaptiveTheme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)),
          ),
        ]),
      ),
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
