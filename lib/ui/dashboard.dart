import 'package:flutter/material.dart';
import 'package:whats_app_saver/Home.dart';

import 'imageScreen.dart';
import 'videoScreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        ImageScreen(),
        VideoScreen(),
        Home(),
      ],
    );
  }
}
