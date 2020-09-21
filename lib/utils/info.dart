import 'dart:io';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'storage.dart';

/* GLOBAIS */
var token;
var email;
var userId;
List paths = new List();
// String mainUrl = "http://192.168.0.193";
String mainUrl = "http://ec2-3-131-99-53.us-east-2.compute.amazonaws.com";

Map<String, String> headers = {
  "Content-Type": "application/x-www-form-urlencoded"
};

Map<String, String> multiPartHeaders = {};

class Session {

  Future<Map> get(String url) async {
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode != 200) {
      updateCookie(response);
      return json.decode(response.body);
    } else {
        return {"status": "error"};
    }
  }

  Future<Map> post(String url, dynamic data) async {
    print(url);
    print(data);
    print(headers);
    http.Response response = await http.post(url, body: data, headers: headers);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      updateCookie(response);
      return json.decode(response.body);
    } else {
        return {"status": "error", "msg": "Ocorreu um erro, tente novamente mais tarde."};
    }
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      multiPartHeaders['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  void updateMultiCookie(http.StreamedResponse response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      multiPartHeaders['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  Future<String> sendRecord(String url, String filename, dynamic data, idIdea) async {
    print("SENDING TO SERVER");
    
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll(multiPartHeaders);

    request.fields.addAll(data);

    request.files.add(
      await http.MultipartFile.fromPath(
        'record',
        filename
      )
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      updateMultiCookie(response);
      print(response.reasonPhrase);
      var res = json.decode(response.reasonPhrase);

      var webId = res["data"]["idIdea"];

      DbConnection database = new DbConnection();
      
      await database.updateWebId(webId, idIdea);

      return response.reasonPhrase;
    } else {
      print(response.reasonPhrase);
      return "Ocorreu um erro, tente novamente mais tarde.";
    }
  }
}