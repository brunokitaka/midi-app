import 'dart:async';

import 'package:midiapp/utils/info.dart';

Future sendRecord(path, idIdea) async {
  
  var response = await Session().sendRecord(mainUrl + "/sendRecord", path, {"idIdea":idIdea.toString()}); 

  print(response);
}

Future<bool> requestEraseIdea(idIdea, name) async {
  
  var response = await Session().post(mainUrl + "/deleteIdea", {"idIdea": idIdea.toString(), "name": name});
  if(response["status"] != "success"){
    return false;
  }
  else{
    return true;
  }  
}