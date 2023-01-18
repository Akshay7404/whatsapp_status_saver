// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'imageScreen.dart';
import 'videoScreen.dart';

class Dashboard extends StatefulWidget {
  final TabController tabcontroller;

  const Dashboard({Key? key, required this.tabcontroller}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  RefreshController controller = RefreshController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabcontroller,
      children: [
        ImageScreen(),
        VideoScreen(),
      ],
    );
  }
}
