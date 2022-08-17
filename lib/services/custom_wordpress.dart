import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/models/wp_user.dart';


class CustomWordpress {

  Map<String, String> _urlHeader = {
    'Authorization': '',
  };

  Future<WpUser> authenticateViaTokenCustom(String? token) async {

    _urlHeader['Authorization'] = 'Bearer $token';

    final response = await http.post(Uri.parse(WpConfig.apiUrl + '/wp-json/jwt-auth/v1/token/validate'), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fetchMeUser(_urlHeader);
    } else {
      print('authviaToken error : ${response.body}');
      throw Error();
    }
  }


  Future<WpUser> fetchMeUser(urlHeader) async {
    final response = await http.get(Uri.parse(WpConfig.apiUrl + '/wp-json/wp/v2/users/me'), headers: urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);
      if (jsonStr.length == 0)
        throw Error();
      return WpUser.fromJson(jsonStr);
    } else {
      print('fetch me user error');
      throw Error();
    }
  }
}