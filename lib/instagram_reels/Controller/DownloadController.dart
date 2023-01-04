// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart' as wb;
import 'package:whats_app_saver/instagram_reels/Controller/instagram_login.dart';
import 'package:whats_app_saver/instagram_reels/model/insta_post_with_login.dart';
import 'package:whats_app_saver/instagram_reels/model/insta_post_without_login.dart';

class DownloadController extends GetxController {
  var processing = false.obs;
  bool isLogin = false;
  String? path;
  var box = GetStorage();
  Dio dio = Dio();

  Future<String?> _startDownload(String link, BuildContext context) async {
    // Asking for video storage permission
    await Permission.storage.request();
    isLogin = false;
    // Checking for Cookies
    final cookieManager = wb.WebviewCookieManager();
    final gotCookies =
        await cookieManager.getCookies('https://www.instagram.com/');
    // is Cookie found then set isLogin to true
    if (gotCookies.length > 0) isLogin = true;

    // Build the url
    var linkParts = link.replaceAll(" ", "").split("/");
    var url =
        '${linkParts[0]}//${linkParts[2]}/${linkParts[3]}/${linkParts[4]}' +
            "?__a=1&__d=dis";
    print("url parts $url");

    // Make Http requiest to get the download link of video
    var httpClient = HttpClient();
    String? videoURLLLLL;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      gotCookies.forEach((element) {
        request.cookies.add(Cookie(element.name, element.value));
      });
      print("request ${request}");
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        if (isLogin) {
          InstaPostWithLogin postWithLogin = InstaPostWithLogin.fromJson(data);
          videoURLLLLL = postWithLogin.items?.first.videoVersions?.first.url;
        } else {
          InstaPostWithoutLogin post = InstaPostWithoutLogin.fromJson(data);
          videoURLLLLL = post.graphql?.shortcodeMedia?.videoUrl;
          print("videoURLLLLLLLLLLLL $videoURLLLLL");
        }
      }
    } catch (exception) {
      log(exception.toString());
      // Login to instagram in case of Cookie expire or download any private account's video
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => InstaLogin()));
    }

    // Download video & save
    if (videoURLLLLL == null) {
      return null;
    } else {
      if (!dir.existsSync()) {
        dir.create();
      }
      String savePath = dir.path +
          "/${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.mp4";

      await dio.download(videoURLLLLL, savePath);
      // final result = await ImageGallerySaver.saveFile(
      //   savePath,
      //   isReturnPathOfIOS: true,
      // );
      //print("==============" + result["Path"]);
      return savePath;
    }
  }

  Directory dir = Directory("storage/emulated/0/InstaReelsDownloader");

  downloadReal(String link, BuildContext context) async {
    processing.value = true;
    try {
      path = null;
      update();
      await _startDownload(link, context).then((value) {
        if (value == null) throw Exception();
        path = value;
        update();
        List allVideosPath = box.read("allVideo") ?? [];
        allVideosPath.add(path);
        box.write("allVideo", allVideosPath);
      });
    } catch (e) {}
    processing.value = false;
  }
}
