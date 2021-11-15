import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:omsnepal/graphql/custom_types/custom_user_role.dart';
import 'package:omsnepal/graphql/custom_types/error.dart';
import 'package:omsnepal/graphql/models/get_new_token_response.dart';
import 'package:omsnepal/graphql/models/login_response.dart';
import 'package:omsnepal/graphql/models/user.dart';
import 'package:omsnepal/graphql/mutations/automaticLogin.dart';
import 'package:omsnepal/graphql/mutations/login.dart';
import 'package:omsnepal/graphql/queries/me.dart';
import 'package:omsnepal/models/constants.dart';
import 'package:omsnepal/services/client.dart';
import 'package:omsnepal/services/preferences.dart';

class AuthState extends ChangeNotifier {
  User? _userInfo;
  String? _token;
  String? _refreshToken;

  LoadingState _loadingStateUserFetch = LoadingState.loading;
  LoadingState? _loadingStateUserLogin;
  LoadingState? _loadingStateLogOut;

  String? _errorMessage;

  // AuthState();

  User? get userInfo => this._userInfo;
  String? get token => this._token;
  String? get errorMessage => this._errorMessage;
  String? get refreshToken => this._refreshToken;
  LoadingState get loadingStateUserFetch => this._loadingStateUserFetch;
  LoadingState? get loadingStateUserLogin => this._loadingStateUserLogin;
  LoadingState? get loadingStateLogOut => this._loadingStateLogOut;

  bool isNotAdmin() {
    if (_userInfo?.role != USER_ROLE.ADMIN) {
      return true;
    } else
      return false;
  }

  String getFullName() {
    return '${userInfo?.firstName != null ? userInfo?.firstName : ''} ${userInfo?.lastName != null ? userInfo?.lastName : ''} ';
  }

  String getFirstName() {
    return '${userInfo?.firstName ?? ''}';
  }

  String getEmail() {
    return '${userInfo?.email ?? ''}';
  }

  String getUserTypeInString() {
    return userInfo?.role != null ? getUserType(userInfo!.role) : '';
  }

  void automaticLogin(String refreshToken) async {
    if (true) {
      _loadingStateUserFetch = LoadingState.loading;
      notifyListeners();
    }
    Map payload = {"query": gqlAutomaticLogin(refreshToken)};
    final Response? response = await http
        .post(
      Uri.parse(ENDPOINT),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    )
        .catchError((e) {
      if (e is SocketException) {
        _errorMessage = 'No Internet connection';
      }
      _loadingStateUserFetch = LoadingState.error;
      notifyListeners();
    });
    if (response?.body != null) {
      _loadingStateUserFetch = LoadingState.loaded;
      try {
        Map<String, dynamic> incoming = json.decode(response!.body);
        if (incoming["errors"] != null ||
            incoming["data"]["getNewToken"] == null) {
          if (incoming["errors"] != null) {
            List<ErrorModel> errors = List.generate(incoming["errors"].length,
                (index) => ErrorModel.fromJson(incoming["errors"][index]));
            if (errors.length > 0) {
              if (errors.first.extensions?.code == ErrorCode.LOGIN_EXPIRED) {
                _errorMessage = errors.first.message;
                // _errorMessage = 'Login session has expired';
              } else
                _errorMessage = null;
            }
          }
          _loadingStateUserFetch = LoadingState.error;
          notifyListeners();
        } else {
          GetNewTokenResponse _response =
              GetNewTokenResponse.fromJson(incoming["data"]["getNewToken"]);
          _userInfo = _response.user;
          _token = _response.accessToken;
          _refreshToken = _response.refreshToken;
          sharedPreferenceService.setToken(_refreshToken);
          // _token = token;
          _loadingStateUserFetch = LoadingState.loaded;
          notifyListeners();
        }
      } catch (err) {
        _loadingStateUserFetch = LoadingState.error;
        _errorMessage = 'Something went wrong';

        notifyListeners();
      }
    } else {
      _loadingStateUserFetch = LoadingState.error;
      notifyListeners();
    }
  }

  void fetchUserInfo(String? token) async {
    if (true) {
      _loadingStateUserFetch = LoadingState.loading;
      notifyListeners();
    }
    Map payload = {"query": GQL_USER_INFO};
    final Response? response = await http
        .post(
      Uri.parse(ENDPOINT),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(payload),
    )
        .catchError((onError) {
      _loadingStateUserFetch = LoadingState.error;
      notifyListeners();
    });

    if (response?.body != null) {
      _loadingStateUserFetch = LoadingState.loaded;
      Map<String, dynamic> incoming = json.decode(response!.body);
      if (incoming["errors"] != null || incoming["data"]["me"] == null) {
        _loadingStateUserFetch = LoadingState.error;
        notifyListeners();
      } else {
        _userInfo = User.fromJson(incoming["data"]["me"]);
        _token = token;
        _loadingStateUserFetch = LoadingState.loaded;
        notifyListeners();
      }
    } else {
      _loadingStateUserFetch = LoadingState.error;
      notifyListeners();
    }
  }

  Future<void> login(
      {required String email,
      required String password,
      required bool? remember}) async {
    _errorMessage = null;

    if (_userInfo == null || _token == null) {
      _loadingStateUserLogin = LoadingState.loading;
      notifyListeners();
    }
    Map payload = {"query": gqlLogin(email, password)};
    final Response? response = await http
        .post(
      Uri.parse(ENDPOINT),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    )
        .catchError((e) {
      if (e is SocketException) {
        _errorMessage = 'No Internet connection';
      }
      _loadingStateUserLogin = LoadingState.error;
      // if (onError is Exception)
      notifyListeners();
    });
    if (response?.body != null) {
      // print("RESPONSE BODY...........${response.body}");
      _loadingStateUserLogin = LoadingState.loaded;
      Map<String, dynamic> incoming = json.decode(response!.body);
      if (incoming["errors"] != null) {
        List<ErrorModel> errors = List.generate(incoming["errors"].length,
            (index) => ErrorModel.fromJson(incoming["errors"][index]));
        if (errors.length > 0) {
          _errorMessage = errors.first.message;
        } else {
          _errorMessage = null;
        }
        _loadingStateUserLogin = LoadingState.error;
        notifyListeners();
      } else {
        try {
          LoginResponse tokenAuth =
              LoginResponse.fromJson(incoming["data"]["login"]);
          _token = tokenAuth.accessToken;
          _refreshToken = tokenAuth.refreshToken;
          _userInfo = tokenAuth.user;

          if (remember!) {
            sharedPreferenceService.setToken(_refreshToken);
          } else {
            sharedPreferenceService.clearToken();
          }
          _loadingStateUserLogin = LoadingState.loaded;
          _loadingStateUserFetch = LoadingState.loaded;
        } catch (error) {
          _loadingStateUserLogin = LoadingState.error;
          _errorMessage = null;
        } finally {
          notifyListeners();
        }
      }
      // notifyListeners();
    } else {
      _loadingStateUserLogin = LoadingState.error;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    if (true) {
      _loadingStateLogOut = LoadingState.loading;
      notifyListeners();
    }
    try {
      await sharedPreferenceService.clearToken();
      _token = null;
      _userInfo = null;
      _refreshToken = null;
      _loadingStateUserLogin = null;
      _loadingStateUserFetch = LoadingState.loading;
      _loadingStateLogOut = LoadingState.loaded;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      notifyListeners();
      return;
    } catch (err) {
      _loadingStateLogOut = LoadingState.error;
      notifyListeners();
      return;
    }
  }
}
