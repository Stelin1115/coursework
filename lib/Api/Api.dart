import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  var baseUrl = "https://stuiis.cms.gre.ac.uk/COMP1424CoreWS/comp1424cw/";

  var token;

  postData(data, apiUrl) async {
    var fullUrl = Uri.parse(baseUrl + apiUrl);

    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  getData(apiUrl) async {
    var fullUrl = Uri.parse(baseUrl + apiUrl);
    return await http.get(
      fullUrl,
    );
  }

  putData(data, apiUrl) async {
    var fullUrl = Uri.parse(baseUrl + apiUrl);
    return await http.put(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        // 'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token;
  }
}
