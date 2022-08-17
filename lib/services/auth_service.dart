import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wordpress_app/config/server_config.dart';
import 'package:wordpress_app/models/jwt_response.dart';
import 'package:wordpress_app/models/jwt_status.dart';

import '../models/auth_status.dart';
import '../models/user.dart';
import 'custom_wordpress.dart';

class AuthService {


  Future<JwtStatus?> customAuthenticationViaJWT() async {
    JwtStatus? status;
    final body = {
      'username': WpConfig.websiteAdminName,
      'password': WpConfig.websiteAdminPassword,
    };

    final response = await http.post(
      Uri.parse(WpConfig.apiUrl + '/wp-json/jwt-auth/v1/token'),
      body: body,
    );

    print(response.statusCode);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      JWTResponse authResponse = JWTResponse.fromJson(json.decode(response.body));
      String _urlHeader = 'Bearer ${authResponse.token}';
      status = JwtStatus(
        isSuccessfull: true,
        urlHeader: _urlHeader
      );
      print('authentication successfull');
      return status;
    } else {

      print('jwt authentication error');
      return status;
      // try {
      //   throw new WordPressError.fromJson(json.decode(response.body));
      // } catch (e) {
      //   throw new WordPressError(message: response.body);
      // }
    }
  }



  Future<UserModel?> loginWithUsernamePassword(String userName, String password) async {
    UserModel? userModel;
    final http.Response response = await http.post(Uri.parse('${WpConfig.apiUrl}/wp-json/jwt-auth/v1/token?username=$userName&password=$password'));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      String? _token = decodedData['token'];
      await CustomWordpress().authenticateViaTokenCustom(_token).then((value) {
        Map _decodedUserData = value.toJson();
        print('decoded data : $decodedData');
        userModel = UserModel(
          id: _decodedUserData['id'],
          userEmail: decodedData['user_email'],
        );
      });
    } else {
      print('login error');
    }

    return userModel;
  }

  Future<AuthStatus?> createUserWithUsernamePassword(String? _urlHeader, String userName, String email, String password) async {
    AuthStatus? status;
    final StringBuffer url = new StringBuffer(WpConfig.apiUrl + '/wp-json/wp/v2/users');
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url.toString()));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    request.headers.set(HttpHeaders.acceptHeader, "application/json");
    request.headers.set('Authorization', "$_urlHeader");

    request.add(utf8.encode(json.encode({
      'username': userName.trim(),
      'email': email.trim(),
      'password': password,
      'roles': ['subscriber']
    })));
    HttpClientResponse response = await request.close();
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      await getUserId(userName, password).then((int? userId)async {
        if(userId != 0 || userId != null){
          status = AuthStatus(
            isSuccessfull: true,
            errorMessage: 'null',
            userModel: UserModel(
              id: userId,
              userName: userName.trim(),
              userEmail: email.trim()
            ),
          );
        }else{
          status = AuthStatus(
            isSuccessfull: false,
            errorMessage: 'Problem with getting user id. Try Again',
          );
        }
      });
      return status;
    } else {
        response.transform(utf8.decoder).listen((contents) async {
        var _decodedcontents = await json.decode(contents);
        String? _errorMessage = await _decodedcontents['message'];
        print(_errorMessage);
        status = AuthStatus(
          isSuccessfull: false,
          errorMessage: '_errorMessage',
        );
      });
      print('status: $status');
      return status == null ? AuthStatus(
        errorMessage: 'Problem in the site',
        isSuccessfull: false,)
        : status;
    }
  }
  


  Future<int?> getUserId(String userName, String password) async {
    int? userId;
    final http.Response response = await http.post(Uri.parse('${WpConfig.apiUrl}/wp-json/jwt-auth/v1/token?username=$userName&password=$password'));
    if (response.statusCode == 200) {
      var decodedData = await jsonDecode(response.body);
      String? _token = decodedData['token'];
      await CustomWordpress().authenticateViaTokenCustom(_token)
      .then((value) {
        Map _decodedUserData = value.toJson();
        userId = _decodedUserData['id'];
        
        
      });
      print('user id : $userId');
      return userId;
      
    } else {
      print('login error');
      return 0;
    }
  }
}


