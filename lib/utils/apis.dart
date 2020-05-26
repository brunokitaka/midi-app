import 'dart:async';

import 'package:midiapp/utils/info.dart';

Future<List> getUserIdeas() async {
  
  var response = await Session().post(mainUrl + "/selectUserIdeas", {"idUser": "", "token": token}); 

  print(response);
  if(response["status"] == "success"){
    return response["data"];
  }
  else if(response["status"] == "none"){
    print(response["msg"]);
    return [];
  }
  else{
    print(response["msg"]);
    return [];
  }
}