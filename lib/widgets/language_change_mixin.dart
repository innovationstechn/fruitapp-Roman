import 'dart:convert';

class LanguageChangeMixin {

  String translate(String content){
    try {
      if (jsonDecode(content)["en"] != null)
        return jsonDecode(content)["en"];
      else
        return "Unknown";
    }catch (Exception){
      return "Unknown";
    }
  }

  String createEncodedJSONString(String previousJSONObject,String newContent){

    Map<String,dynamic> element = jsonDecode(previousJSONObject);
    element["en"] = newContent;
    print(jsonEncode(element).toString());
    return jsonEncode(element).toString();
  }


}
