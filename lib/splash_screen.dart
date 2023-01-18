// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_app_saver/youtube/ui/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    requestPermission().then((value) {
      print("permission Value:: ${value}");
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return MyHome();
        },
      ));
    });
    super.initState();
  }

  int? _storagePermissionCheck;

  int? androidSDK;

  Future<int> _loadPermission() async {
    //Get phone SDK version first inorder to request correct permissions.

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    //
    if (androidSDK! >= 30) {
      final currentStatusManaged =
          await Permission.manageExternalStorage.status;
      if (currentStatusManaged.isGranted) {
        //Update
        return 1;
      } else {
        return 0;
      }
    } else {
      final currentStatusStorage = await Permission.storage.status;
      if (currentStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    await _loadPermission();
    await requestStoragePermission();
    if (androidSDK! >= 30) {
      //request management permissions for android 11 and higher devices
      final requestStatusManaged =
          await Permission.manageExternalStorage.request();
      //Update Provider model
      if (requestStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final requestStatusStorage = await Permission.storage.request();
      //Update provider model
      if (requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestStoragePermission() async {
    /// PermissionStatus result = await
    /// SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    final result = await [Permission.storage].request();
    if (result[Permission.storage]!.isDenied) {
      return 0;
    } else if (result[Permission.storage]!.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/new_logo-modified.png",
            height: 100, width: 100),
      ),
    );
  }
}
