import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Api {
  static execute({url, data}) async {
    try {
      var urls = Uri.parse(url.toString());
      var result = await http.post(urls, body:data);
      var response = jsonDecode(result.body.toString());
      return response;
    } catch (e) {
      Get.snackbar('API ERROR!', 'Some Error Occurred During Payment Processing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
