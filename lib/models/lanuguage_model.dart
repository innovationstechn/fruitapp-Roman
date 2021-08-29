import 'dart:convert';
import 'package:flutter/foundation.dart';

class LanguageModel extends ChangeNotifier {

  String language;

  Future setLanguage(String lang) async{
    language = lang;
    notifyListeners();
  }

  String translate(String content){
    try {if (jsonDecode(content)[language] != null)
      return jsonDecode(content)[language];
    else
      return "Unknown";
    }catch (Exception){
      return "Unknown";
    }
  }

  String createEncodedJSONString(String previousJSONObject,String newContent){
    Map<String,dynamic> element = jsonDecode(previousJSONObject);
    element[language] = newContent;
    print(jsonEncode(element).toString());
    return jsonEncode(element).toString();
  }

}
