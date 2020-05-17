import 'dart:convert';
import 'package:http/http.dart';
import 'package:connectivity/connectivity.dart';
import 'package:projectlight/components/IOSorAndroidComponents.dart';
import 'package:projectlight/dev/Log.dart';
import 'package:flutter/material.dart';

class HTTPRequestHelper {
  final String url;
  final log = Log().logger;

  HTTPRequestHelper({this.url});

  Future<String> getUrlValue() async {
    try {
      Response response = await get(url);
      if (response.statusCode == 200) {
//        print('Success in response ${response.body}');
        return response.body;
      } else {
        print('Failed response ${response.statusCode}');
        return '';
      }
    } catch (e) {
      log.e('Failed get $e');
      return '';
    }
  }

  /// Get Api keys
  Future<String> postMethod(Map body) async {
    try {
//      print('${jsonEncode(body)} being posted');
      String json = jsonEncode(body);
      Response response = await post(url,
          headers: {"Content-Type": "application/json"}, body: json);
      if (response.statusCode == 200) {
//        print('Success in response ${response.body}');
        return response.body;
      } else {
        print('Failed response ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Failed HTTP request ' + e);
      return null;
    }
  }

  /// Check if connected to internet before continuing process
  static Future<bool> checkIfConnectedToWeb() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Check if user is connected to internet and location enabled
  void checkPhoneSettingFirst(BuildContext context) async {
    bool connectedToInternet = await HTTPRequestHelper.checkIfConnectedToWeb();
    if (!connectedToInternet) {
      return IOSorAndroidComponents().alertWarningDialog(
          title: 'WIFI or data need to be enabled', context: context);
    }
  }
}
