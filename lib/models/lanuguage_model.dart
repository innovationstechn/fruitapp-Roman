import 'dart:convert';
import 'package:flutter/foundation.dart';

// This model is used to change the language and notifies to program if change occurs.
class LanguageModel extends ChangeNotifier {

  String language;

  // Used for changing language and notifies to developer.
  Future setLanguage(String lang) async{
    language = lang;
    notifyListeners();
  }

  // Getting content of specific language
  String translate(String content){
    try {if (jsonDecode(content)[language] != null)
      return jsonDecode(content)[language];
    else
      return "Unknown";
    }catch (Exception){
      return "Unknown";
    }
  }

  // Changing content according to language currently selected.
  String createEncodedJSONString(String previousJSONObject,String newContent){
    Map<String,dynamic> element = jsonDecode(previousJSONObject);
    element[language] = newContent;
    print(jsonEncode(element).toString());
    return jsonEncode(element).toString();
  }

}
