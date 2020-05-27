import 'dart:io';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

/* GLOBAIS */
var token;
var email;
var userId;
List paths = new List();
String mainUrl = "http://192.168.0.193";

Map<String, String> headers = {
  "Content-Type": "application/x-www-form-urlencoded"
};

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
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  Future<String> sendRecord(String url, String filename, dynamic data) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['idUser'] = data["idUser"].toString();
    request.fields['token'] = data["token"].toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        'record',
        filename
      )
    );

    var response = await request.send();

    return response.reasonPhrase;
  }
}