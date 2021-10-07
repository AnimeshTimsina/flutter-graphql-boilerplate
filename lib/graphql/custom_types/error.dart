import 'package:enum_to_string/enum_to_string.dart';

enum ErrorCode {
  UNAUTHENTICATED,
  LOGIN_EXPIRED,
  DUPLICATE_RECORD,
  INVALID_CREDENTIALS
}

class ErrorModel {
  String? message;
  ErrorExtensionModel? extensions;

  ErrorModel(this.message, this.extensions);

  ErrorModel.fromJson(Map<String, dynamic> json) {
    message = getErrorMessage(
        json['extensions'] != null
            ? ErrorExtensionModel.fromJson(json['extensions']).code
            : null,
        json["message"]);
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

String getErrorMessage(ErrorCode? errorCode, String defaultMessage) {
  switch (errorCode) {
    case ErrorCode.LOGIN_EXPIRED:
      return "Login has expired";
    case ErrorCode.UNAUTHENTICATED:
      return "Not authenticated";
    case ErrorCode.DUPLICATE_RECORD:
      return defaultMessage;
    case ErrorCode.INVALID_CREDENTIALS:
      return defaultMessage;
    default:
      return "Internal Server Error";
  }
}
