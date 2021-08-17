import 'package:enum_to_string/enum_to_string.dart';

enum ErrorCode { UNAUTHENTICATED, LOGIN_EXPIRED }

class ErrorModel {
  String? message;
  ErrorExtensionModel? extensions;

  ErrorModel(this.message, this.extensions);

  ErrorModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    extensions = json['extensions'] != null
        ? ErrorExtensionModel.fromJson(json['extensions'])
        : null;
  }

  Map toJson() {
    Map data = {};
    data['message'] = message;
    data['extensions'] = extensions?.toJson();
    return data;
  }
}

class ErrorExtensionModel {
  ErrorCode? code;

  ErrorExtensionModel({this.code});

  ErrorExtensionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'] != null
        ? EnumToString.fromString(ErrorCode.values, json['code'])
        : null;
  }

  Map toJson() {
    Map data = {};
    data['code'] = EnumToString.convertToString(code);
    return data;
  }
}
