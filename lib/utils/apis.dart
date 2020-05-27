import 'dart:async';

import 'package:midiapp/utils/info.dart';

Future sendRecord(path) async {
  
  var response = await Session().sendRecord(mainUrl + "/sendRecord", path, {"idUser": userId, "token": token}); 

  print(response);
}