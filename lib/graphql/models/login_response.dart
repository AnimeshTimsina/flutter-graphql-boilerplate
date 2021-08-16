import 'package:omsnepal/graphql/models/user.dart';

class LoginResponse {
  User? user;
  String? accessToken;
  String? refreshToken;
  LoginResponse(
      {required this.user,
      required this.accessToken,
      required this.refreshToken});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map toJson() {
    Map data = {};
    data['user'] = user?.toJson();
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}
